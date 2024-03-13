require_relative '../spec_helper.rb'
require 'json'
require 'faraday'

RSpec.describe 'Server' do
  def app
    Sinatra::Application
  end

  describe 'GET /data' do
    it 'returns the exams data' do
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
          token: "PQCZ18",
          exam_date: "2021-08-05",
          exam_type: "leucócitos",
          exam_limits: "9-61",
          exam_result: "89"
        }
      ]

      conn = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new).and_return(conn)
      allow(conn).to receive(:get).with('tests').and_return(double(body: db_result.to_json))

      response = get '/data'

      data = JSON.parse(response.body)

      expect(response.status).to eq 200
      expect(data).to be_instance_of Array
      expect(data).to eq(JSON.parse(db_result.to_json))
    end

    context 'with token params' do
      it 'returns the specific exams data' do
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
          }
        ]
        conn = instance_double(Faraday::Connection)
        allow(Faraday).to receive(:new).and_return(conn)
        allow(conn).to receive(:get).with("tests/IQCZ17").and_return(double(body: db_result.to_json))

        response = get '/data?token=IQCZ17'

        data = JSON.parse(response.body)

        expect(response.status).to eq 200
        expect(data).to be_instance_of Array
        expect(data).to eq(JSON.parse(db_result.to_json))
      end
    end
  end
end
