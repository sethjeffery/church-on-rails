module People
  class UsersController < ApplicationController
    before_action :load_and_authorize_person

    private

    def load_and_authorize_person
      @person = Person.find(params[:person_id])
      authorize! :update, @person
    end
  end
end
