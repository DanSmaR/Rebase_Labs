require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'

describe 'User visits exams page', type: :feature, js: true do
  let(:api_service) { instance_double(ApiService) }
  let(:exam_service) { ExamService.new(api_service) }

  before do
    allow(ApiService).to receive(:new).and_return(api_service)
    allow(ExamService).to receive(:new).and_return(exam_service)
  end

  context "when there are registered exams" do
    it 'and see the first page of exams successfully' do
      allow(api_service).to receive(:get_exams).with(page: 1, limit: 20).and_return(api_response_page_1.to_json)

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

      within 'nav.pagination-top' do
        expect(page).to have_button 'Anterior', disabled: true
        (1..3).each { |i| expect(page).to have_button "#{i}" }
        expect(page).to have_button 'Próximo', disabled: false
      end

      within 'nav.pagination-bottom' do
        expect(page).to have_button 'Anterior', disabled: true
        (1..3).each { |i| expect(page).to have_button "#{i}" }
        expect(page).to have_button 'Próximo', disabled: false
      end

      within 'tbody' do
        expect(page).to have_selector 'tr', count: 2
        expect(page).to have_selector 'tr > td', count: 16
      end

      expect(page).to have_content('Token', count: 2)
      expect(page).to have_content('Data do Exame')
      expect(page).to have_content('CPF')
      expect(page).to have_content('Nome')
      expect(page).to have_content('Cidade')
      expect(page).to have_content('Estado')
      expect(page).to have_content('Nome do Médico')
      expect(page).to have_content('CRM do Médico')

      expect(page).to have_link('ST7APU', href: '/exams/ST7APU')
      expect(page).to have_content('2022-03-24')
      expect(page).to have_content('089.034.562-70')
      expect(page).to have_content('Patricia Gentil')
      expect(page).to have_content('Jequitibá')
      expect(page).to have_content('Paraná')
      expect(page).to have_content('Félix Garcês')
      expect(page).to have_content('B00067668W')

      expect(page).to have_link('NIG0TP', href: '/exams/NIG0TP')
      expect(page).to have_content('2022-01-08')
      expect(page).to have_content('052.041.078-51')
      expect(page).to have_content('Sra. Meire da Terra')
      expect(page).to have_content('Rio Fortuna')
      expect(page).to have_content('Maranhão')
      expect(page).to have_content('Maria Helena Ramalho')
      expect(page).to have_content('B0002IQM66')
    end
    it 'and see the second page of exams successfully' do
      # First requisition
      allow(api_service)
        .to receive(:get_exams)
        .with(page: 1, limit: 20)
        .and_return(api_response_page_1.to_json)

      # Second requisition
      allow(api_service)
        .to receive(:get_exams)
        .with(page: 2, limit: 20)
        .and_return(api_response_page_2.to_json)

      visit '/'
      click_link 'Exames'
      within 'nav.pagination-top' do
        click_button '2'
      end

      within 'header' do
        expect(page).to have_link 'Início', href: '/'
        expect(page).to have_link 'Exames', href: '/exams'
        expect(page).to have_link 'Busca por Token', href: '/search'

        expect(page).to have_field 'csvFile', type: 'file'
        expect(page).to have_button 'Enviar CSV'
      end

      expect(page).to have_current_path('/exams')

      expect(page).to have_content('Exames Médicos')

      within 'nav.pagination-top' do
        expect(page).to have_button 'Anterior', disabled: false
        (1..3).each { |i| expect(page).to have_button "#{i}" }
        expect(page).to have_button 'Próximo', disabled: false
      end

      within 'nav.pagination-bottom' do
        expect(page).to have_button 'Anterior', disabled: false
        (1..3).each { |i| expect(page).to have_button "#{i}" }
        expect(page).to have_button 'Próximo', disabled: false
      end

      expect(page).to have_content('Token', count: 2)
      expect(page).to have_content('Data do Exame')
      expect(page).to have_content('CPF')
      expect(page).to have_content('Nome')
      expect(page).to have_content('Cidade')
      expect(page).to have_content('Estado')
      expect(page).to have_content('Nome do Médico')
      expect(page).to have_content('CRM do Médico')

      expect(page).to have_link('SHURZ5', href: '/exams/SHURZ5')
      expect(page).to have_content('2022-01-05')
      expect(page).to have_content('083.892.729-70')
      expect(page).to have_content('João Samuel Garcês')
      expect(page).to have_content('Taubaté')
      expect(page).to have_content('Pará')
      expect(page).to have_content('Dra. Isabelly Rêgo')
      expect(page).to have_content('B0002W2RBG')

      expect(page).to have_link('G7FX8V', href: '/exams/G7FX8V')
      expect(page).to have_content('2021-12-05')
      expect(page).to have_content('092.375.756-29')
      expect(page).to have_content('Henry Pinheira Filho')
      expect(page).to have_content('Brejetuba')
      expect(page).to have_content('Distrito Federal')
      expect(page).to have_content('Dra. Isabelly Rêgo')
      expect(page).to have_content('B0002W2RBG')
    end
    it 'and see the third and final page of exams successfully' do
      allow(api_service)
        .to receive(:get_exams)
        .with(page: 1, limit: 20)
        .and_return(api_response_page_1.to_json)

      allow(api_service)
        .to receive(:get_exams)
        .with(page: 3, limit: 20)
        .and_return(api_response_page_3.to_json)

      visit '/'
      click_link 'Exames'
      within 'nav.pagination-top' do
        click_button '3'
      end

      within 'header' do
        expect(page).to have_link 'Início', href: '/'
        expect(page).to have_link 'Exames', href: '/exams'
        expect(page).to have_link 'Busca por Token', href: '/search'

        expect(page).to have_field 'csvFile', type: 'file'
        expect(page).to have_button 'Enviar CSV'
      end

      expect(page).to have_current_path('/exams')

      expect(page).to have_content('Exames Médicos')

      within 'nav.pagination-top' do
        expect(page).to have_button 'Anterior', disabled: false
        (1..3).each { |i| expect(page).to have_button "#{i}" }
        expect(page).to have_button 'Próximo', disabled: true
      end

      within 'nav.pagination-bottom' do
        expect(page).to have_button 'Anterior', disabled: false
        (1..3).each { |i| expect(page).to have_button "#{i}" }
        expect(page).to have_button 'Próximo', disabled: true
      end

      within 'tbody' do
        expect(page).to have_selector 'tr', count: 2
        expect(page).to have_selector 'tr > td', count: 16
      end

      expect(page).to have_content('Token', count: 2)
      expect(page).to have_content('Data do Exame')
      expect(page).to have_content('CPF')
      expect(page).to have_content('Nome')
      expect(page).to have_content('Cidade')
      expect(page).to have_content('Estado')
      expect(page).to have_content('Nome do Médico')
      expect(page).to have_content('CRM do Médico')

      expect(page).to have_link('TERLWH', href: '/exams/TERLWH')
      expect(page).to have_content('2021-12-01')
      expect(page).to have_content('048.108.026-04')
      expect(page).to have_content('Juliana dos Reis Filho')
      expect(page).to have_content('Lagoa da Canoa')
      expect(page).to have_content('Paraíba')
      expect(page).to have_content('Ana Sophia Aparício Neto')
      expect(page).to have_content('B000BJ8TIA')

      expect(page).to have_link('VIFJIN', href: '/exams/VIFJIN')
      expect(page).to have_content('2021-11-27')
      expect(page).to have_content('072.328.987-54')
      expect(page).to have_content('João Guilherme Marques')
      expect(page).to have_content('Vermelho Novo')
      expect(page).to have_content('Minas Gerais')
      expect(page).to have_content('Núbia Godins')
      expect(page).to have_content('B000HB2O2O')
    end
  end

  context "when there is no exam registered" do
    it "shows a alert message" do
      api_response = { total_pages: 0, previous: nil, next: nil, results: []}.to_json

      allow(api_service).to receive(:get_exams).and_raise(ApiNotFoundError.new('Resource Not Found', api_response))

      visit '/exams'

      expect(page).to have_content 'Não há exames cadastrados.'

      expect(page).to_not have_content('Exames Médicos')

      expect(page).to have_content('Token', count: 1)
      expect(page).to_not have_content('Data do Exame')
      expect(page).to_not have_content('CPF')
      expect(page).to_not have_content('Nome')
      expect(page).to_not have_content('Cidade')
      expect(page).to_not have_content('Estado')
      expect(page).to_not have_content('Nome do Médico')
      expect(page).to_not have_content('CRM do Médico')
    end
  end

  context "when server error occurs" do
    it "sees an error message" do
      allow(api_service).to receive(:get_exams).and_raise(ApiServerError, 'Server Error')

      visit '/'
      click_link 'Exames'

      expect(page).to have_content 'Não foi possível completar sua ação. Tente novamente'
    end

  end

end
