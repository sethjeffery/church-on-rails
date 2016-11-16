class User < ApplicationRecord
  include Concerns::Naming
  delegate :admin?, to: :person, allow_nil: true

  # Include default devise modules. Others available are:
  # :lockable, and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :confirmable, :omniauthable, :validatable

  has_one :person

  validates_presence_of :name
end
