class SearchesController < ApplicationController
  def show
    if params[:q].present?
      @search = Search.new people: fetch_people,
                           families: fetch_families,
                           teams: fetch_teams
    else
      @search = Search.new
    end
  end

  private

  def fetch_people
    if can?(:read, Person)
      people = Person
      people = people.where("search_name LIKE ?", "%#{params[:q].downcase}%") if params[:q].present?
      people = people.includes(:teams).order(:search_name).limit(3)
      people.all
    else
      []
    end
  end

  def fetch_families
    if can?(:read, Family)
      families = Family
      families = families.where("lower(name) LIKE ?", "%#{params[:q].downcase}%") if params[:q].present?
      families = families.includes(:people).order(:name).limit(3)
      families.all
    else
      []
    end
  end

  def fetch_teams
    if can?(:read, Team)
      teams = Team
      teams = teams.where("lower(name) LIKE ?", "%#{params[:q].downcase}%") if params[:q].present?
      teams = teams.includes(:team_memberships, :people).order(:name).limit(3)
      teams.all
    else
      []
    end
  end

end
