# A model that represents a Google Calendar with its own specific settings
# within a CalendarSettings model.

class CalendarWithSettings
  include ActiveModel::Model

  attr_reader :calendar
  attr_writer :visibility, :team_ids
  delegate :summary, :id, to: :calendar

  def initialize(calendar)
    @calendar = calendar
  end

  def visibility
    if @visibility
      @visibility.to_sym
    elsif calendar_teams.blank?
      :none
    elsif calendar_teams.any?{|c| c.team_id.nil? }
      :all
    else
      :teams
    end
  end

  def calendar_teams
    @calendar_teams ||= CalendarTeam.where(calendar_id: id).includes(:team).all
  end

  def teams
    calendar_teams.map(&:team).compact
  end

  def team_ids
    @team_ids ||= teams.map(&:id)
  end

  def update_attributes(attrs)
    # clear out existing items then add new ones
    CalendarTeam.where(calendar_id: id).delete_all

    case attrs[:visibility]
      when 'all'
        CalendarTeam.create(calendar_id: id, team_id: nil)

      when 'teams'
        attrs[:team_ids].each{|team_id| CalendarTeam.create(calendar_id: self.id, team_id: team_id)}

      else
        nil # no op

    end
    true
  end
end
