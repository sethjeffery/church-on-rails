module PeopleHelper
  def account_or_person_path(person)
    if person == current_user.person
      account_path
    else
      person_path(person)
    end
  end

  def all_people
    Person.all.order(:first_name, :last_name)
  end
end
