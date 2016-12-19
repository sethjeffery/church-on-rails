module Concerns
  module Capitalize
    extend ActiveSupport::Concern

    # Calls .capitalize! on a field only if it is all lowercase or uppercase
    def safe_capitalize(field)
      field.capitalize! if needs_capitalize(field)
    end

    def needs_capitalize(field)
      field && (field == field.downcase || field == field.upcase)
    end

    included do
      # Allow us to define fields that should be automatically safe-capitalized before validation.
      def self.auto_capitalize(*fields)
        before_validation { fields.each { |field| safe_capitalize(send(field)) } }
      end
    end
  end
end
