class User < ApplicationRecord
  delegate :teams, :families, :name, to: :person, allow_nil: true

  # Include default devise modules. Others available are:
  # :lockable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :confirmable, :omniauthable, :validatable

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
end
