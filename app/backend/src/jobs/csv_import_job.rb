require 'sidekiq'
Dir[File.expand_path("../database/*.rb", __dir__)].each { |file| require file }

class CSVImportJob
  include Sidekiq::Job

  def perform(file_path)
    DatabaseSetup.seed(DBManager.conn, file_path)

    File.delete(file_path) if File.exist?(file_path)
  end
end
