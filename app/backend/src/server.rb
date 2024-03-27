require 'rack/handler/puma'
require 'sinatra'
require 'fileutils'
require 'pg'
require_relative './database/database_setup.rb'
require_relative './exam_data_builder.rb'
require_relative './services/exam_service.rb'
require_relative './jobs/csv_import_job.rb'
require_relative './middleware/pagination_middleware.rb'

use PaginationMiddleware, ExamModel, ExamService.new(ExamDataBuilder)

get '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  results = env['results']

  unless results.any?
    status 404
    return { total_pages: 0, previous: nil, next: nil, results: }.to_json
  end

  response = {
    total_pages: env['total_pages'],
    previous: env['previous'],
    next: env['next'],
    results:
  }

  response.to_json
end

get '/tests/:token' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  results = env['results']

  unless results.any?
    status 404
    return results.to_json
  end

  results.to_json
end

post '/import' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

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
