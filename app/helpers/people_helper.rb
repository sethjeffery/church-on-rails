module PeopleHelper
  def account_or_person_path(person)
    if person == current_user.person
      account_path
    else
      person_path(person)
    end
  end
end
