require 'rack/handler/puma'
require 'sinatra'
require 'faraday'
Dir[File.expand_path("./services/*.rb", __dir__)].each { |file| require file }
Dir[File.expand_path("./errors/*.rb", __dir__)].each { |file| require file }

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
    page = params[:page] ? params[:page].to_i : 1
    limit = params[:limit] ? params[:limit].to_i : 20

    exam_service = ExamService.new(ApiService.new)
    exam_service.fetch_data(page, limit, params[:token])

  rescue ApiNotFoundError => e
    puts '------------- Frontend Error GET /data ---------------'
    puts e.message

    status 404
    return e.payload

  rescue ApiServerError => e
    puts '------------- Frontend Error GET /data ---------------'
    puts e.message

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
    payload = UploadCSVService.create_payload(validation_result[:tmpfile])

    exam_service = ExamService.new(ApiService.new)
    exam_service.send_file(payload)

    status 200
    { success: true, message: 'Data imported successfully' }.to_json

  rescue ApiServerError => e
    puts e

    status 500
    return { error: true,  message: 'An error has occurred. Try again' }.to_json

  rescue ApiBadRequestError => e
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
