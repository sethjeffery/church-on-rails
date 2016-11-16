class FamiliesController < ApplicationController
  load_and_authorize_resource

  def index
    @families.includes(:people)
  end
end
