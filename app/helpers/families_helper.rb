module FamiliesHelper
  def all_families(*fields)
    fields = [:id, :name] if fields.blank?
    Family.select(fields).order(:name)
  end
end
