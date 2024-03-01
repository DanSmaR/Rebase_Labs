require_relative '../app/server.rb'

RSpec.describe 'Server' do

  def app
    Sinatra::Application
  end

  it 'gets the csv data by the endpoint /tests' do
    response = get '/tests'
    data = JSON.parse(response.body)
    expect(data).to be_instance_of Array
  end
end
