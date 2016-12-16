module TeamsHelper
  def all_teams(*fields)
    fields = [:name, :icon, :color] if fields.blank?
    Team.select(fields).order(:name)
  end
end
