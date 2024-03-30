require 'csv'
require 'pg'
require_relative './db_manager.rb'
Dir[File.expand_path("../models/*.rb", __dir__)]
  .reject { |file| file.include? "base_model" }
  .each { |file| require file }

class DatabaseSetup
  CSV_FILE_PATH = File.expand_path(
    ENV['RACK_ENV'] == 'test' ? '../spec/support/data.csv' : '../data/data.csv', __dir__
  )
  MODELS = [PatientModel, DoctorModel, ExamModel, TestModel]

  def self.seed(conn)
    prepare_statements(conn)
    insert_csv_data(CSV_FILE_PATH, conn)
  end

  def self.prepare_statements(conn)
    MODELS.each do |model|
      model.prepare_insert(conn)
    end
  end

  def self.insert_csv_data(file_path, conn)

    puts 'Populating the tables with data...'

    conn.transaction do
      CSV.foreach(file_path, headers: true, col_sep: ';') do |row|
        MODELS.each do |model|
          model.exec_insert(conn, row.to_h)
        end
      end
    end

    puts 'Done'
  end

  def self.clean(conn)
    MODELS.reverse.each do |model|
      model.exec_delete_all(conn)
    end
  end
end
