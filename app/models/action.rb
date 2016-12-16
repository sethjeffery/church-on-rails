class Action < ApplicationRecord
  belongs_to :actor,      class_name: 'Person'
  belongs_to :actionable, polymorphic: true

  scope :of_type, -> type { where(action_type: type.to_s) }
  serialize :data
end
