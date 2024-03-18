require 'rack/handler/puma'
require 'sinatra'
require 'faraday'
require_relative './services/upload_csv_service.rb'
require_relative './services/api_service.rb'

get '/' do
  erb :index
end

get '/exams' do
  erb :index
end

get '/exams/' do
  erb :index
end

get '/exams/:token' do
  erb :index
end

get '/search' do
  erb :index
end

# This route is used to get the data from the backend
get '/data' do
  content_type :json

  begin
    conn = ApiService.connection

    if params[:token]
      response = ApiService.get_exam_by_token(conn, params[:token])
    else
      response = ApiService.get_exams(conn)
    end

    response.body

  rescue Faraday::ResourceNotFound => e
    puts '------------- Frontend Error GET /data ---------------'
    puts e

    status 404
    return [].to_json
  rescue Faraday::ServerError, Faraday::Connection, Faraday::ConnectionFailed => e
    puts '------------- Frontend Error GET /data ---------------'
    puts e

    status 500
    return { error: true,  message: 'An error has occurred. Try again' }.to_json
  end

end

# This route is used to upload the CSV file to the backend
post '/upload' do
  content_type :json

  validation_result = UploadCSVService.validate(params[:csvFile])

  unless validation_result[:success]
    status 400
    return validation_result.to_json
  end

  begin
    conn = ApiService.connection

    payload = UploadCSVService.create_payload(validation_result[:tmpfile])

    ApiService.send_file(conn, payload)

    status 200
    { success: true, message: 'Data imported successfully' }.to_json

  rescue Faraday::ServerError, Faraday::Connection, Faraday::ConnectionFailed => e
    puts e

    status 500
    return { error: true,  message: 'An error has occurred. Try again' }.to_json

  rescue Faraday::BadRequestError => e
    puts e

    status 400
    return { sucess: false, message: 'No file was uploaded' }.to_json
  end
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
