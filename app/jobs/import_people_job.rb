class ImportPeopleJob < ApplicationJob
  attr_reader :import
  queue_as :default

  def perform(import)
    @import = import
    import.records_added = 0
    import.records_updated = 0
    import.records_failed = 0
    import.records_skipped = 0

    first = import.has_header? ? import.first_row + 1 : import.first_row
    (first..import.last_row).each do |row|
      import_person(row)
    end
  end

  def import_person(row)
    email = import.cell_for_column(row, :email)

    person = Person.find_by_email(email) if email
    person ||= Person.new
    family = {}

    if import.column_matches.any?{|match| match&.include?('name') && import.cell_for_column(row, match).present? }

      import.column_matches.select{|m| m.in? Import::PERSON_NAMES.map(&:to_s)}.each do |column_name|
        apply_column(row, person, column_name)
      end

      if person.last_name.present?
        family[:name] = person.last_name
        import.column_matches.select{|m| m.in? Import::FAMILY_NAMES.map(&:to_s)}.each do |column_name|
          family[column_name] ||= import.cell_for_column(row, column_name)
        end
      end

      if save_person(person)
        save_family(person, family) if family.present?
      end
    else
      import.records_skipped += 1
    end
  end

  def apply_column(row, model, column_name)
    new_val = model.send(column_name) || import.cell_for_column(row, column_name)
    model.send("#{column_name}=", new_val) if new_val.present?
  end

  def save_person(person)
    if person.id
      if person.save
        import.records_updated += 1
        true
      else
        import.records_failed += 1
        false
      end
    else
      if person.save
        import.records_added += 1
        true
      else
        import.records_failed += 1
        false
      end
    end
  end

  def save_family(person, args)
    person.families.find_by_name(args[:name])&.update_attributes(args) or person.families.create(args)
  end
end
