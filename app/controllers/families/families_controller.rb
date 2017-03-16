class Families::FamiliesController < ApplicationController
  load_and_authorize_resource

  def index
    @families = @families.where("lower(name) LIKE ?", "%#{params[:q].downcase}%") if params[:q].present?
    @families = @families.where.not(id: params[:not].split(',')) if params[:not].present?
    @families = @families.includes(:people).order(:name).page(params[:page]).per(PAGE_SIZE)
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

  def destroy
    @family.destroy
    redirect_to families_path, notice: "#{@family} has been removed from the database."
  end

  private

  def create_params
    blanks_to_nil params.require(:family).permit(:address1, :address2, :postcode, :country, :name)
  end
end
