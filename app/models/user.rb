class User < ApplicationRecord
  delegate :teams, :families, :name, to: :person, allow_nil: true

  # Include default devise modules. Others available are:
  # :lockable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :confirmable, :omniauthable, :validatable,
         omniauth_providers: [:facebook]

  has_one :person

  before_save :auto_connect_person, if: :confirmed_at_changed?

  def to_s
    email
  end

  def auto_connect_person
    if confirmed_at.present?
      person = Person.find_by(email: email)
      person.update_attributes user_id: id if person && !person.user_id
    end
  end

  def self.from_omniauth(auth, current_church)
    user   = find_by(provider: auth.provider, uid: auth.uid) || find_by(email: auth.info.email)
    return nil unless user || current_church.can_sign_up?

    user ||= create do |new_user|
      new_user.provider = auth.provider
      new_user.uid = auth.uid
      new_user.email = auth.info.email
      new_user.password = Devise.friendly_token[0,20]
    end

    user.update_attributes(provider: auth.provider, uid: auth.uid) unless user.provider

    if user.person
      user.person.update_attributes(facebook: auth.uid) unless user.person.facebook
    else
      user.person = Person.create user: user,
                                  first_name: auth_info.info.first_name || auth.info.name.split(' ').first,
                                  middle_name: (auth.info.name.split(' ')[1..-2].join(' ') if auth.info.name.split(' ').length > 2),
                                  last_name: auth_info.info.last_name || auth.info.name.split(' ').last,
                                  facebook: auth.id
    end

    user
  end
end
