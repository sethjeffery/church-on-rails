class PropertyJoin < ApplicationRecord
  belongs_to :propertyable, polymorphic: true
  belongs_to :property
end
