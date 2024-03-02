ENV['RACK_ENV'] = 'test'

require_relative '../app/server.rb'

RSpec.describe 'Server' do

  def app
    Sinatra::Application
  end

  describe 'GET /tests' do
    it 'returns the csv data' do
      allow(CSV).to receive(:read).with("data/data.csv", col_sep: ';').and_return([
        ['cpf', 'name'], ['1234567890', 'John Doe'], ['0987654321', 'Jane Smith']
      ])

      response = get '/tests'

      data = JSON.parse(response.body)

      expect(data).to be_instance_of Array
      expect(data).to eq([
        { 'cpf' => '1234567890', 'name' => 'John Doe' },
        { 'cpf' => '0987654321', 'name' => 'Jane Smith' }
      ])
    end
  end
end
