class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :confirmable, :omniauthable, :validatable

  def admin?
    email == 'test@example.com'
  end

  def name
    [first_name, last_name].select(&:present?).join(' ')
  end

  def full_name
    [prefix, first_name, middle_name, last_name, suffix].select(&:present?).join(' ')
  end

  validates_presence_of :name
end
