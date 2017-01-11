class People::ImportsController < ApplicationController
  load_and_authorize_resource

  def show
    redirect_to new_import_path, alert: "File not found. Please upload a new file." unless @import
  end

  def create
    if @import.create
      redirect_to @import
    else
      render :new
    end
  end

  def update
    if @import.import
      @import.destroy
      redirect_to people_path, notice: import_notice
    else
      render :show
    end
  end

  private

  def create_params
    params.require(:import).permit(:file)
  end

  def update_params
    params.require(:import).permit(:has_header, column_matches: [])
  end

  def import_notice
    if @import.records_added > 0 || @import.records_updated > 0
      messages = []
      messages << "#{@import.records_added} added." if @import.records_added > 0
      messages << "#{@import.records_updated} updated." if @import.records_updated > 0
      messages << "#{@import.records_failed} invalid." if @import.records_failed > 0
      messages.join(' ')
    elsif @import.records_failed > 0
      "No records added. #{@import.records_failed} invalid."
    else
      "No records added."
    end
  end
end
