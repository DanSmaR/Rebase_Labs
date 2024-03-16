require_relative '../spec_helper.rb'
require 'faraday'
require 'faraday/multipart'

RSpec.describe 'User sends csv file', type: :feature, js: true do
  let(:mock_conn) { double('Faraday::Connection') }
  let(:mock_file_part) { double('Faraday::Multipart::FilePart') }

  before do
    allow(Faraday).to receive(:new).with(url: 'http://backend:3001').and_return(mock_conn)
    allow(Faraday::Multipart::FilePart).to receive(:new).with(any_args).and_return(mock_file_part)
  end
  it 'and sees a successful message' do
    allow(mock_conn).to receive(:post).with('import', { :file => mock_file_part }).and_return(double('response', status: 200))
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
      mock_conn = instance_double(Faraday::Connection)
      allow(ApiService).to receive(:connection).and_return(mock_conn)
      allow(ApiService).to receive(:send_file).and_raise(Faraday::ConnectionFailed)

      visit '/'

      within 'header' do
        attach_file('csvFile', File.expand_path('../support/data.csv', __dir__))
        click_button 'Enviar CSV'
      end

      expect(page).to have_content 'Erro ao enviar arquivo! Tente novamente.'
    end
  end


end
