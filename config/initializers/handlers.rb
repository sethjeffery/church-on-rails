require 'csv_handler'

ActionView::Template.register_template_handler :csvbuilder, CsvHandler::Handler
