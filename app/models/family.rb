class Family < ApplicationRecord
  include Concerns::Geocoding

  has_many :family_memberships
  has_many :people, through: :family_memberships, inverse_of: :families

  validates_presence_of :name

  def family_name
    name + ' Family'
  end

  def to_s
    family_name
  end
end
