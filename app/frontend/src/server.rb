require 'rack/handler/puma'
require 'sinatra'
require 'faraday'
require 'faraday/multipart'

get '/' do
  erb :index
end

get '/exams' do
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

  conn = Faraday.new(url: 'http://backend:3001') do |builder|
    builder.response :raise_error
  end

  if params[:token]
    response = conn.get("tests/#{params[:token]}")
  else
    response = conn.get('tests')
  end

  response.body
end

# This route is used to upload the CSV file to the backend
post '/upload' do
  content_type :json

  unless params[:csvFile] && params[:csvFile] != 'undefined' &&
    (tmpfile = params[:csvFile][:tempfile]) &&
    (name = params[:csvFile][:filename])

    status 400
    return { success: false, message: 'No file was uploaded' }.to_json
  end

  unless name.match?(/\.csv\z/)
    status 400
    return { success: false, message: 'Invalid file format' }.to_json
  end

  begin
    conn = Faraday.new(url: 'http://backend:3001') do |builder|
      builder.request :multipart
      builder.request :url_encoded
      builder.adapter :net_http
    end

    payload = { file: Faraday::Multipart::FilePart.new(tmpfile, 'text/csv') }

    response = conn.post('import', payload)

    if response.status == 200
        status 200
        { success: true, message: 'Data imported successfully' }.to_json
    end
  rescue => e
    puts e.message

    status 500
    { error: true,  message: 'An error occurred while importing data. Try again' }.to_json
  end
end

unless ENV['RACK_ENV'] == 'test'
  Rack::Handler::Puma.run(
    Sinatra::Application,
    Port: 3000,
    Host: '0.0.0.0'
  )
end
