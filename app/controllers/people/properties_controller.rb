class People::PropertiesController < ApplicationController
  load_and_authorize_resource

  def index
    @properties = @properties.where("lower(name) LIKE ?", "%#{params[:q].downcase}%") if params[:q]
    @properties = @properties.page(params[:page]).per(20)
  end

  def create
    if @property.save
      redirect_to @property
    else
      render :new
    end
  end

  def update
    if @property.update_attributes create_params
      redirect_to @property
    else
      render :edit
    end
  end

  def destroy
    @property.destroy
    redirect_to properties_path
  end

  private

  def create_params
    blanks_to_nil params.require(:property).permit(:name, :description, :icon, :format)
  end
end
