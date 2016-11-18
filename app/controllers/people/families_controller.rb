module People
  class FamiliesController < ApplicationController
    load_and_authorize_resource

    def index
      @families = @families.where("name LIKE ?", "%#{params[:q]}%") if params[:q]
      @families = @families.includes(:people).order(:name).page(params[:page]).per(20)
    end

    def create
      if @family.save
        redirect_to family_path @family
      else
        render :new
      end
    end

    def update
      if @family.update_attributes(create_params)
        redirect_to family_path @family
      else
        render :edit
      end
    end

    private

    def create_params
      blanks_to_nil params.require(:family).permit(:address1, :address2, :postcode, :country, :name)
    end
  end
end
