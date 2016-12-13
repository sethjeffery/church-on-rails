module PropertiesHelper
  def all_properties
    @all_properties ||= Property.all
  end
end
