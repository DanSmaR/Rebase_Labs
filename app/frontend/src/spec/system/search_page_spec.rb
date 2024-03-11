require 'spec_helper.rb'
require 'faraday'
require 'json'

RSpec.describe 'User visits search page', type: :feature, js: true do
  it 'and search for a exam by token successfully' do
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
    allow(conn).to receive(:get).with('tests').and_return(double(body: db_result.to_json))

    using_wait_time(10) do
      visit '/search'
      save_and_open_page

      expect(page).to have_current_path('/search')
      expect(page).to have_content('Busca de Exames por Token')

      fill_in 'token', with: 'IQCZ17'
      click_button 'Pesquisar'

      expect(page).to have_content 'CPF'
    end
  end
end
