class Comment < ApplicationRecord
  belongs_to :person
  belongs_to :commentable, polymorphic: true

  validates_presence_of :person, :commentable
end
