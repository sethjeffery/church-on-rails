class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # Helper function to get I18n field names
  def self.field_name(key)
    ActionView::Helpers::Tags::Translator.new(self.new, self.name.underscore, key, scope: "activerecord.attributes").translate
  end
end
