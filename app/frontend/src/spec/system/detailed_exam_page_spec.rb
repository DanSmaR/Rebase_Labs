require_relative '../spec_helper.rb'
require_relative '../support/test_data.rb'

describe 'User sees detailed exam page', type: :feature, js: true do
  let(:api_service) { instance_double(ApiService) }
  let(:exam_service) { ExamService.new(api_service) }
  let(:token) { 'ST7APU' }

  before do
    allow(ApiService).to receive(:new).and_return(api_service)
    allow(ExamService).to receive(:new).and_return(exam_service)
  end

  it 'when clicking on a specific token from list' do
    allow(api_service).to receive(:get_exams).with(page: 1, limit: 20).and_return(api_response_page_1.to_json)
    allow(api_service).to receive(:get_exam_by_token).with(token).and_return(api_response_by_token.to_json)

    visit '/exams'

    click_link token

    expect(page).to have_current_path("/exams/#{token}")

    within 'header' do
      expect(page).to have_link 'Início', href: '/'
      expect(page).to have_link 'Exames', href: '/exams'
      expect(page).to have_link 'Busca por Token', href: '/search'

      expect(page).to have_field 'csvFile', type: 'file'
      expect(page).to have_button 'Enviar CSV'
    end

    expect(page).to have_content 'Detalhe Exame Médico'
    expect(page).to have_content "Exame #{token} feito em 24/03/2022"

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

    expect(page).to have_content('089.034.562-70')
    expect(page).to have_content('Patricia Gentil')
    expect(page).to have_content('herta_wehner@krajcik.name')
    expect(page).to have_content('1998-02-25')
    expect(page).to have_content('5334 Rodovia Thiago Bittencourt')
    expect(page).to have_content('Paraná')
    expect(page).to have_content('Félix Garcês')
    expect(page).to have_content('letty_greenfelder@herzog.name')
    expect(page).to have_content('B00067668W')
    expect(page).to have_content('RS')
    expect(page).to have_content('hemácias', count: 1)
    expect(page).to have_content('45-52')
    expect(page).to have_content('81')
    expect(page).to have_content('leucócitos', count: 1)
    expect(page).to have_content('9-61')
    expect(page).to have_content('66')
    expect(page).to have_content('plaquetas', count: 1)
    expect(page).to have_content('11-93')
    expect(page).to have_content('68')
    expect(page).to have_content('hdl', count: 1)
    expect(page).to have_content('19-75')
    expect(page).to have_content('49')
    expect(page).to have_content('ldl', count: 2)
    expect(page).to have_content('45-54')
    expect(page).to have_content('24')
    expect(page).to have_content('vldl', count: 1)
    expect(page).to have_content('48-72')
    expect(page).to have_content('36')
    expect(page).to have_content('glicemia', count: 1)
    expect(page).to have_content('25-83')
    expect(page).to have_content('86')
    expect(page).to have_content('tgo', count: 1)
    expect(page).to have_content('50-84')
    expect(page).to have_content('35')
    expect(page).to have_content('tgp', count: 1)
    expect(page).to have_content('38-63')
    expect(page).to have_content('99')
    expect(page).to have_content('eletrólitos', count: 1)
    expect(page).to have_content('2-68')
    expect(page).to have_content('19')
    expect(page).to have_content('tsh', count: 1)
    expect(page).to have_content('25-80')
    expect(page).to have_content('95')
    expect(page).to have_content('t4-livre', count: 1)
    expect(page).to have_content('34-60')
    expect(page).to have_content('39')
    expect(page).to have_content('ácido úrico', count: 1)
    expect(page).to have_content('15-61')
    expect(page).to have_content('62')

    expect(page).to_not have_content('NIG0TP')
    expect(page).to_not have_content('052.041.078-51')
    expect(page).to_not have_content('Sra. Meire da Terra')
    expect(page).to_not have_content('lavinia@bartoletti.co')
    expect(page).to_not have_content('1968-06-21')
    expect(page).to_not have_content('230 Rua Eduarda')
    expect(page).to_not have_content('Rio Fortuna')
    expect(page).to_not have_content('Maranhão')
    expect(page).to_not have_content('Maria Helena Ramalho')
    expect(page).to_not have_content('rayford@kemmer-kunze.info')
    expect(page).to_not have_content('B0002IQM66')
    expect(page).to_not have_content('SC')
  end

  context "when occurs a server error" do
    it "sees an error message" do
      allow(api_service).to receive(:get_exam_by_token).with(token).and_raise(ApiServerError, 'Server Error')

      visit "/exams/#{token}"

      expect(page).to have_current_path("/exams/#{token}")

      expect(page).to have_content 'Não foi possível completar sua ação. Tente novamente'
    end
  end
end
