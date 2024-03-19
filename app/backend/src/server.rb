require 'rack/handler/puma'
require 'sinatra'
require 'fileutils'
require 'pg'
require_relative './database/database_setup.rb'
require_relative './exam_data_builder.rb'
require_relative './jobs/csv_import_job.rb'
require_relative './middleware/pagination_middleware.rb'

use PaginationMiddleware

get '/tests' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  begin
    results = env['results']

    unless results.any?
      status 404
      return {
        "previous" => nil,
        "next" => nil,
        "results" => results
    }.to_json
    end

    exams = results.group_by { |item| item['token'] }.map do |token, items|
      ExamDataBuilder.build_exam_data(items)
    end

    response = {
      previous: env['previous'],
      next: env['next'],
      results: exams
    }

    response.to_json
  rescue PG::Error => e
    status 500
    return { error: true,  message: 'An error has occurred. Try again' }.to_json
  end

end

get '/tests/:token' do
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'

  begin
    results = env['results']

    unless results.any?
      status 404
      return results.to_json
    end

    response = results.group_by { |item| item['token'] }.map do |token, items|
      ExamDataBuilder.build_exam_data(items)
    end

    response.to_json
  rescue PG::Error => e
    status 500
    return { error: true,  message: 'An error has occurred. Try again' }.to_json
  end
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
