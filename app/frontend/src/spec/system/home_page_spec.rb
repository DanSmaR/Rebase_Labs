require_relative '../spec_helper.rb'
require 'faraday'
require 'json'

RSpec.describe 'User visits home page', type: :feature, js: true do
  it 'and sees a navbar and the content successfully' do
    visit '/'

    expect(page).to have_current_path('/')

    within 'header' do
      expect(page).to have_link 'Início', href: '/'
      expect(page).to have_link 'Exames', href: '/exams'
      expect(page).to have_link 'Busca por Token', href: '/search'
    end

    expect(page).to have_content 'Exames Médicos'
    expect(page).to have_content 'Acesse os exames cadastrados em nossa base de dados pelo menu acima'
  end
end
