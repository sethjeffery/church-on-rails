class ImportPeopleJob < ApplicationJob
  attr_reader :import
  queue_as :default

  def perform(import)
    import.records_added = 0
    import.records_updated = 0
    import.records_failed = 0
    import.records_skipped = 0

    first = import.has_header? ? import.first_row + 1 : import.first_row
    (first..import.last_row).each do |row|

      email = import.cell_for_column(row, :email)

      person = Person.find_by_email(email) if email
      person ||= Person.new

      if import.column_matches.any?{|match| match.present? && import.cell_for_column(row, match).present? }
        import.column_matches.each do |match|
          if match.present?
            person.send("#{match}=", import.cell_for_column(row, match))
          end
        end

        if person.id
          if person.save
            import.records_updated += 1
          else
            import.records_failed += 1
          end
        else
          if person.save
            import.records_added += 1
          else
            import.records_failed += 1
          end
        end
      else
        import.records_skipped += 1
      end
    end
  end
end
