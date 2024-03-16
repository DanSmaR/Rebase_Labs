require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'
require 'faraday'
require 'json'

RSpec.describe 'User visits exams page', type: :feature, js: true do
  it 'and see all exams successfully' do
    mock_conn = instance_double(Faraday::Connection)
    mock_response = instance_double(Faraday::Response)

    allow(ApiService).to receive(:connection).and_return(mock_conn)
    allow(ApiService).to receive(:get_exams).with(mock_conn).and_return(mock_response)
    allow(mock_response).to receive(:body).and_return(api_response.to_json)

    visit '/'
    click_link 'Exames'

    within 'header' do
      expect(page).to have_link 'Início', href: '/'
      expect(page).to have_link 'Exames', href: '/exams'
      expect(page).to have_link 'Busca por Token', href: '/search'

      expect(page).to have_field 'csvFile', type: 'file'
      expect(page).to have_button 'Enviar CSV'
    end

    expect(page).to have_current_path('/exams')

    expect(page).to have_content('Exames Médicos')

    expect(page).to have_content('Token')
    expect(page).to have_content('Data do Exame')
    expect(page).to have_content('CPF')
    expect(page).to have_content('Nome')
    expect(page).to have_content('Cidade')
    expect(page).to have_content('Estado')
    expect(page).to have_content('Nome do Médico')
    expect(page).to have_content('CRM do Médico')

    expect(page).to have_link('IQCZ17', href: '/exams/IQCZ17')
    expect(page).to have_content('2021-08-05')
    expect(page).to have_content('048.973.170-88')
    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('Ituverava')
    expect(page).to have_content('Alagoas')
    expect(page).to have_content('Maria Luiza Pires')
    expect(page).to have_content('B000BJ20J4')

    expect(page).to have_link('0W9I67', href: '/exams/0W9I67')
    expect(page).to have_content('2021-07-09')
    expect(page).to have_content('048.108.026-04')
    expect(page).to have_content('Juliana dos Reis Filho')
    expect(page).to have_content('Lagoa da Canoa')
    expect(page).to have_content('Paraíba')
    expect(page).to have_content('Maria Helena Ramalho')
    expect(page).to have_content('B0002IQM66')
  end

  context "when server error occurs" do
    it "sees a message error" do
      mock_conn = instance_double(Faraday::Connection)

      allow(ApiService).to receive(:connection).and_return(mock_conn)
      allow(ApiService).to receive(:get_exams).with(mock_conn).and_raise(Faraday::ConnectionFailed)

      visit '/'
      click_link 'Exames'

      expect(page).to have_content 'Não foi possível completar sua ação. Tente novamente'

    end

  end

end
