class Property < ApplicationRecord
  ICONS = %w(property cogs list-ul info-circle wheelchair blind deaf low-vision car bus subway bicycle home map-marker building medkit id-badge child user-md graduation-cap)

  has_many :property_joins, dependent: :destroy

  def to_s
    name
  end

  validates_inclusion_of :format, in: %w(flag list text)
  validates_presence_of :name

  def flag?
    format == 'flag'
  end

  def list?
    format == 'list'
  end

  def text?
    format == 'text'
  end
end
