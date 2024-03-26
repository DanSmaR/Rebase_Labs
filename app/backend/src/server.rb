require 'rack/handler/puma'
require 'sinatra'
require 'fileutils'
require 'pg'
require_relative './database/database_setup.rb'
require_relative './exam_data_builder.rb'
require_relative './services/exam_service.rb'
require_relative './jobs/csv_import_job.rb'
require_relative './errors/database_error.rb'

exam_service = ExamService.new(ExamDataBuilder)

get '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  begin
    results = exam_service.get_exams

    status results.any? ? 200 : 404
    results.to_json

  rescue DataBaseError => e
    status 500
    { error: true,  message: 'An error has occurred. Try again' }.to_json
  end
end

get '/tests/:token' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  begin
    results = exam_service.get_exams(params[:token])

    status results.any? ? 200 : 404
    results.to_json

  rescue
    status 500
    { error: true,  message: 'An error has occurred. Try again' }.to_json
  end
end

post '/import' do
  content_type :json

  begin
    if params[:file] && (tempfile = params[:file][:tempfile])
      file_path = File.expand_path("./uploads/#{params[:file][:filename]}", __dir__)

      FileUtils.mv(tempfile.path, file_path)

      CSVImportJob.perform_async(file_path)

      status 200
      { success: true, message: 'Data imported successfully' }.to_json
    else
      status 400
      { sucess: false, message: 'No file was uploaded' }.to_json
    end
  rescue => e
    puts e.message

    status 500
    { error: true,  message: 'An error has occurred. Try again' }.to_json
  end
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3001,
    Host: '0.0.0.0'
  )
end
