require 'spec_helper.rb'
require 'faraday'
require 'json'

RSpec.describe 'User visits home page', type: :feature, js: true do
  it 'and see all exams successfully' do
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
    conn = Faraday.new do |builder|
      builder.adapter :test, Faraday::Adapter::Test::Stubs.new do |stub|
        stub.get('/tests') { [200, {}, db_result.to_json] }
      end
    end

    allow(Faraday).to receive(:new).and_return(conn)

    visit '/'
    expect(page).to have_content('Exames Médicos')
  end
end
