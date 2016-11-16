module Concerns
  module Naming
    extend ActiveSupport::Concern

    def name
      [first_name, last_name].select(&:present?).join(' ')
    end

    def full_name
      [try(:prefix), first_name, try(:middle_name), last_name, try(:suffix)].select(&:present?).join(' ')
    end
  end
end
