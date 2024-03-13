require 'sidekiq'
require_relative '../database/database_setup.rb'

class CSVImportJob
  include Sidekiq::Job

  def perform(file_path)
    DatabaseSetup.prepare_statements
    DatabaseSetup.insert_csv_data(file_path)

    File.delete(file_path) if File.exist?(file_path)
  end
end
