class Merge
  include ActiveModel::Conversion
  extend  ActiveModel::Naming

  delegate :id, :name, :icon, :email, :phone, to: :merger, allow_nil: true
  attr_reader :person, :family

  def initialize(person: nil, family: nil)
    @person = person
    @family = family
  end

  def merger
    person || family
  end

  def merger_id
    id
  end

  def merger_data
    if merger.is_a?(Person)
      [{ id: id, text: name, icon: icon, email: email, phone: phone }]
    elsif merger.is_a?(Family)
      [{ id: id, text: name, members: family.people.pluck('first_name') }]
    else
      []
    end
  end

  def persisted?
    false
  end
end
