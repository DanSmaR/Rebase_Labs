ENV['RACK_ENV'] = 'test'

require_relative '../app/server.rb'
require 'json'

RSpec.describe 'Server' do
  def app
    Sinatra::Application
  end

  describe 'GET /tests' do
    it 'returns the exams data' do
      # Mock the database connection and query result
      db_result = [
        {
          cpf: "048.973.170-88",
          name: "Maria Luiza Pires",
          email: "denna@wisozk.biz",
          birth_date: "2001-03-11",
          address: "165 Rua Rafaela",
          city: "Ituverava",
          state: "Alagoas",
          crm: "B000BJ20J4",
          crm_state: "PI",
          id: "1",
          patient_cpf: "048.973.170-88",
          doctor_crm: "B000BJ20J4",
          token: "IQCZ17",
          exam_date: "2021-08-05",
          exam_type: "hemácias",
          exam_limits: "45-52",
          exam_result: "97"
        },
        {
          cpf: "048.973.170-88",
          name: "Maria Luiza Pires",
          email: "denna@wisozk.biz",
          birth_date: "2001-03-11",
          address: "165 Rua Rafaela",
          city: "Ituverava",
          state: "Alagoas",
          crm: "B000BJ20J4",
          crm_state: "PI",
          id: "2",
          patient_cpf: "048.973.170-88",
          doctor_crm: "B000BJ20J4",
          token: "IQCZ17",
          exam_date: "2021-08-05",
          exam_type: "leucócitos",
          exam_limits: "9-61",
          exam_result: "89"
        }
      ]

      allow(DBManager.conn).to receive(:exec).with("
      SELECT p.*, d.*, e.*
      FROM exams e
      JOIN patients p ON p.cpf = e.patient_cpf
      JOIN doctors d ON d.crm = e.doctor_crm
    ").and_return(db_result)

      response = get '/tests'

      data = JSON.parse(response.body)

      expect(data).to be_instance_of Array
      expect(data).to eq(JSON.parse(db_result.to_json))
    end
  end
end
