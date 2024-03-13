require 'json'
require_relative './spec_helper.rb'
require_relative './support/test_data.rb'

RSpec.describe 'Server' do
  def app
    Sinatra::Application
  end

  describe 'GET /tests' do
    it 'returns the exams data' do
      query = <<~SQL.gsub("\n", " ")
        SELECT p.*, d.*, e.*
        FROM exams e
        JOIN patients p ON p.cpf = e.patient_cpf
        JOIN doctors d ON d.crm = e.doctor_crm
      SQL

      allow(DBManager.conn).to receive(:exec_params).with("#{query};", []).and_return(db_result)

      response = get '/tests'

      data = JSON.parse(response.body)

      expect(data).to be_instance_of Array
      expect(data).to eq(api_response)
    end

    context 'with token params' do
      it 'returns the specific exams data' do
        query = <<~SQL.gsub("\n", " ")
          SELECT p.*, d.*, e.*
          FROM exams e
          JOIN patients p ON p.cpf = e.patient_cpf
          JOIN doctors d ON d.crm = e.doctor_crm
        SQL

        allow(DBManager.conn).to receive(:exec_params).with("#{query} WHERE e.token = $1;", ["IQCZ17"]).and_return(db_result[0..1])

        response = get '/tests/IQCZ17'

        data = JSON.parse(response.body)

        expect(data).to be_instance_of Array
        expect(data).to eq([api_response[0]])
      end
    end
  end
end
