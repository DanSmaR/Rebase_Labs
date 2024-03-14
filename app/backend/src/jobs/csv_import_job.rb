require 'sidekiq'
require_relative '../database/database_setup.rb'
require_relative '../database/db_manager.rb'

class CSVImportJob
  include Sidekiq::Job

  def perform(file_path)
    conn = DBManager.conn
    DatabaseSetup.prepare_statements(conn)
    DatabaseSetup.insert_csv_data(file_path, conn)

    File.delete(file_path) if File.exist?(file_path)
  end
end
