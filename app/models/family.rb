class Family < ApplicationRecord
  has_many :family_memberships
  has_many :people, through: :family_memberships, inverse_of: :families
end
