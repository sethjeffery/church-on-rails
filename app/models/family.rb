class Family < ApplicationRecord
  has_many :family_memberships
  has_many :people, through: :family_memberships, inverse_of: :families

  validates_presence_of :name

  def to_s
    name + ' Family'
  end
end
