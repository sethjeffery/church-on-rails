class Import
  include ActiveModel::Model
  attr_accessor :id, :file, :column_matches, :has_header, :spreadsheet
  attr_accessor :records_added, :records_skipped, :records_updated, :records_failed

  delegate :cell, :first_row, :last_row, :first_column, :last_column, to: :spreadsheet

  PERSON_NAMES = %i[ prefix first_name middle_name last_name name suffix dob gender email phone joined_at facebook twitter ]
  FAMILY_NAMES = %i[ address1 address2 postcode country ]
  COLUMN_NAMES = PERSON_NAMES + FAMILY_NAMES

  def initialize(args={})
    @column_matches = []
    @has_header = false
    super
  end

  # Called when the user has uploaded a file and wants to begin the import
  # process with the uploaded spreadsheet.
  def create
    if @file.present?
      @id = SecureRandom.urlsafe_base64
      FileUtils.mv @file.tempfile, temp_path
      true
    else
      errors.add(:file, 'is required')
      false
    end
  end

  # Called when the user has finished setting up the import process and
  # wishes to now import the data into the database.
  def import(args={})
    @column_matches = args[:column_matches] if args[:column_matches]
    @has_header     = args[:has_header]     if args[:has_header]
    ImportPeopleJob.perform_now(self)
    true
  end

  # Destroys the import task by deleting its temp file.
  def destroy
    File.delete(temp_path)
  end

  # Used for URL helpers. This model is persisted if the ID exists.
  def persisted?
    !!@id
  end

  # Opens the uploaded spreadsheet
  def open_spreadsheet
    @spreadsheet = SimpleSpreadsheet::Workbook.read(temp_path)
    @spreadsheet.selected_sheet = @spreadsheet.sheets.first

    columns.each do |column|
      name = self.class.column_names.find{ |column_name|
        cell_text = strip_all(cell(1, column))
        cell_text == strip_all(column_name[0]) || cell_text == strip_all(column_name[1])
      }
      @has_header = true if name.present?
      column_matches << name.try(:[], 1).to_s
    end
  end

  # Gets a range of the first rows of the spreadsheet, up to a default of 20.
  def rows(max: 20)
    (first_row..([last_row, max].min))
  end

  # Gets a range of the first columns of the spreadsheet, up to a default of 20.
  def columns(max: 20)
    (first_column..([last_column, max].min))
  end

  def cell_for_column(row, name)
    index = column_matches.index(name.to_s)
    cell(row, index + 1) if index
  end

  def has_header?; !!has_header; end

  def temp_path
    self.class.temp_path(id)
  end

  class << self
    # To treat this like an ActiveRecord model, we allow it to be "found"
    # which simply instantiates the model and reads the uploaded spreadsheet.
    def find(id)
      if File.exists?(temp_path(id))
        import = Import.new(id: id)
        import.open_spreadsheet
        import
      end
    end

    # The list of column names that are recognised by the importer
    def column_names
      keys = COLUMN_NAMES
      keys.map{|key| [Person.field_name(key), key]}
    end

    # Helper function to take a filename (id) and translate it into
    # a recognised tmp path within the website for reading and writing the spreadsheet.
    def temp_path(filename)
      "#{Rails.root}/tmp/import-#{filename}.xlsx"
    end
  end

  private

  def strip_all(text)
    text.to_s.downcase.gsub(/[^\w\d]/, '')
  end
end
