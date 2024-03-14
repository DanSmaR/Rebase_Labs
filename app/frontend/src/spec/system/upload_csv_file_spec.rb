require_relative '../spec_helper.rb'

RSpec.describe 'User sends csv file', type: :feature, js: true do
  it 'and sees a successful message' do
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
      conn = instance_double(Faraday::Connection)
      allow(Faraday).to receive(:new).and_return(conn)
      allow(conn).to receive(:post).with('import', anything).and_raise(Faraday::ServerError)

      visit '/'

      within 'header' do
        attach_file('csvFile', File.expand_path('../support/data.csv', __dir__))
        click_button 'Enviar CSV'
      end

      expect(page).to have_content 'Erro ao enviar arquivo! Tente novamente.'
    end
  end


end
