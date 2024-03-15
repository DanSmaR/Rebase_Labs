require_relative '../spec_helper.rb'

RSpec.describe 'User visits home page', type: :feature, js: true do
  it 'and sees a navbar and the content successfully' do
    visit '/'

    expect(page).to have_current_path('/')

    within 'header' do
      expect(page).to have_link 'Início', href: '/'
      expect(page).to have_link 'Exames', href: '/exams'
      expect(page).to have_link 'Busca por Token', href: '/search'

      expect(page).to have_field 'csvFile', type: 'file'
      expect(page).to have_button 'Enviar CSV'
    end

    expect(page).to have_content 'Exames Médicos'
    expect(page).to have_content 'Navegue pela nosso site pelos menus acima'
    expect(page).to have_content 'Acesse todos os exames cadastrados'
    expect(page).to have_content 'Busque por um exame específico passando um token no campo de busca'

    expect(page).to have_link 'exames', href: '/exams'
    expect(page).to have_link 'Busque por um exame específico', href: '/search'

  end
end
