class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities

    user ||= User.new
    can :manage, user
    can :manage, user.person

    # Everyone can view the church info
    can :read, Church

    user.teams&.each do |team|
      add_team_abilities(user, team)
    end
  end

  def add_team_abilities(user, team)
    can :manage, :all if team.admin?

    [User, Person, Family, Team, TeamMembership, FamilyMembership, Property].each do |klass|
      can :read,   klass if team.people_reader?
      can :update, klass if team.people_editor?
      can :create, klass if team.people_editor?
      can :manage, klass if team.people_admin?
    end

    [ChurchProcess, PersonProcess].each do |klass|
      can :read,   klass if team.process_reader?
      can :update, klass if team.process_editor?
      can :create, klass if team.process_editor?
      can :manage, klass if team.process_admin?
    end

    [Event].each do |klass|
      can :read,   klass if team.event_reader?
      can :update, klass if team.event_editor?
      can :create, klass if team.event_editor?
      can :manage, klass if team.event_admin?
    end

    [ChildGroup].each do |klass|
      can :read,    klass if team.children_reader?
      can :update,  klass if team.children_editor?
      can :create,  klass if team.children_editor?
      can :manage,  klass if team.children_admin?
    end

    [ChildGroupMembership, ChildGroupCheckin].each do |klass|
      can :read,    klass if team.children_reader?
      can :update,  klass if team.children_editor?
      can :create,  klass if team.children_editor?
      can :destroy, klass if team.children_editor?
      can :manage,  klass if team.children_admin?
    end
  end
end
