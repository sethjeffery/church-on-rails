module PeopleHelper
  def account_or_person_path(person)
    if person == current_person
      account_path
    else
      person_path(person)
    end
  end

  def all_people(*fields)
    fields = [:first_name, :last_name] if fields.blank?
    Person.select(fields).order(:first_name, :last_name)
  end
end
