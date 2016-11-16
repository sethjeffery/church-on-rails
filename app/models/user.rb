class User < ApplicationRecord
  delegate :admin?, :name, to: :person, allow_nil: true

  # Include default devise modules. Others available are:
  # :lockable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :confirmable, :omniauthable, :validatable

  has_one :person

  def to_s
    email
  end
end
