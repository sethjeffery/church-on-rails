class Families::MergesController < ApplicationController
  before_action :load_and_authorize_family

  def show
    @merge = Merge.new(family: Family
                                 .where("lower(name) = ?", @family.name.downcase)
                                 .where.not(id: @family.id).first)
  end

  def update
    if merge_params[:merger_id].present?
      merger = Family.find(merge_params[:merger_id])
      @family.merge_into(merger)
      redirect_to merger, notice: "Families merged successfully."
    else
      render :show
    end
  end

  private

  def merge_params
    params.require(:merge).permit(:merger_id)
  end

  def load_and_authorize_family
    @family = Family.find(params[:family_id])
    authorize! :manage, @family
  end
end
