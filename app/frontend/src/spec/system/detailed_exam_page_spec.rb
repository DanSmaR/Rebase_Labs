require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'
require 'faraday'
require 'json'

RSpec.describe 'User sees detailed exam page', type: :feature, js: true do
  it 'when clicking on a specific token from list' do
    conn = instance_double(Faraday::Connection)
    allow(Faraday).to receive(:new).and_return(conn)
    allow(conn).to receive(:get).with('tests').and_return(double(body: [api_response[0]].to_json))
    allow(conn).to receive(:get).with('tests/IQCZ17').and_return(double(body: [api_response[0]].to_json))

    visit '/exams'

    click_link 'IQCZ17'

    expect(page).to have_current_path('/exams/IQCZ17')

    within 'header' do
      expect(page).to have_link 'Início', href: '/'
      expect(page).to have_link 'Exames', href: '/exams'
      expect(page).to have_link 'Busca por Token', href: '/search'

      expect(page).to have_field 'csvFile', type: 'file'
      expect(page).to have_button 'Enviar CSV'
    end

    expect(page).to have_content 'Detalhe Exame Médico IQCZ17 feito em 05/08/2021'

    expect(page).to have_content('CPF')
    expect(page).to have_content('Nome')
    expect(page).to have_content('E-mail')
    expect(page).to have_content('Data de Nascimento')
    expect(page).to have_content('Endereço')
    expect(page).to have_content('Estado')
    expect(page).to have_content('Médico')
    expect(page).to have_content('E-mail do Médico')
    expect(page).to have_content('CRM do Médico')
    expect(page).to have_content('CRM Estado')
    expect(page).to have_content('Tipo de Exame')
    expect(page).to have_content('Limites')
    expect(page).to have_content('Resultado')

    expect(page).to have_content('048.973.170-88')
    expect(page).to have_content('Emilly Batista Neto')
    expect(page).to have_content('gerald.crona@ebert-quigley.com')
    expect(page).to have_content('2001-03-11')
    expect(page).to have_content('165 Rua Rafaela')
    expect(page).to have_content('Alagoas')
    expect(page).to have_content('Maria Luiza Pires')
    expect(page).to have_content('denna@wisozk.biz')
    expect(page).to have_content('B000BJ20J4')
    expect(page).to have_content('PI')
    expect(page).to have_content('hemácias', count: 1)
    expect(page).to have_content('45-52')
    expect(page).to have_content('97')
    expect(page).to have_content('leucócitos', count: 1)
    expect(page).to have_content('9-61')
    expect(page).to have_content('89')

    expect(page).to_not have_content('0W9I67')
    expect(page).to_not have_content('2021-07-09')
    expect(page).to_not have_content('048.108.026-04')
    expect(page).to_not have_content('Juliana dos Reis Filho')
    expect(page).to_not have_content('mariana_crist@kutch-torp.com')
    expect(page).to_not have_content('1995-07-03')
    expect(page).to_not have_content('527 Rodovia Júlio')
    expect(page).to_not have_content('Lagoa da Canoa')
    expect(page).to_not have_content('Paraíba')
    expect(page).to_not have_content('Maria Helena Ramalho')
    expect(page).to_not have_content('rayford@kemmer-kunze.info')
    expect(page).to_not have_content('B0002IQM66')
    expect(page).to_not have_content('SC')
  end
end
