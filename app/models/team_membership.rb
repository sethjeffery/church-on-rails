class TeamMembership < ApplicationRecord
  belongs_to :person
  belongs_to :team

  validates_presence_of :team_id, :person_id
  validates_uniqueness_of :person_id, scope: :team_id
end
