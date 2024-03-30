require_relative '../spec_helper.rb'

describe 'User sends csv file', type: :feature, js: true do
  let(:mock_payload) { { file: double('Multipart::Post::UploadIO') } }
  let(:api_service) { instance_double(ApiService) }
  let(:exam_service) { ExamService.new(api_service) }

  before do
    allow(ApiService).to receive(:new).and_return(api_service)
    allow(ExamService).to receive(:new).and_return(exam_service)
    allow(UploadCSVService).to receive(:create_payload).and_return(mock_payload)
  end

  it 'and sees a successful message' do
    allow(api_service).to receive(:send_file).with(mock_payload)

    visit '/'

    within 'header' do
      attach_file('csvFile', File.expand_path('../support/data.csv', __dir__))
      click_button 'Enviar CSV'
    end

    expect(page).to have_content 'Arquivo enviado com sucesso!'
  end

  context "no file attached" do
    it 'and sees an error message' do
      visit '/'

      within 'header' do
        click_button 'Enviar CSV'
      end

      expect(page).to have_content 'Arquivo não selecionado ou inválido!'
    end
  end

  context "incorrect file type" do
    it 'and sees an error message' do
      visit '/'

      within 'header' do
        attach_file('csvFile', File.expand_path('../support/test_data.rb', __dir__))
        click_button 'Enviar CSV'
      end

      expect(page).to have_content 'Arquivo não selecionado ou inválido!'
    end
  end

  context "when an error occurs in the server" do
    it 'and sees an error message' do
      allow(api_service).to receive(:send_file).and_raise(ApiServerError, 'Server Error')

      visit '/'

      within 'header' do
        attach_file('csvFile', File.expand_path('../support/data.csv', __dir__))
        click_button 'Enviar CSV'
      end

      expect(page).to have_content 'Erro ao enviar arquivo! Tente novamente.'
    end
  end
end
