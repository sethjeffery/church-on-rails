class Search
  attr_accessor :people, :families, :teams

  def initialize(people: [], families: [], teams: [])
    @people = people
    @families = families
    @teams = teams
  end

  def items
    [*people, *families, *teams].sort_by(&:to_s)[0..6]
  end

  def updated_at
    items.map(&:updated_at).max
  end
end
