require 'rspec'
require_relative '../test'

RSpec.describe 'Test' do
  describe '#all' do
    it 'e não tem testes' do
      expect(Test.all).to eq([])
    end

    xit 'e retorna todos os testes'
  end
  describe '#create' do
    xit 'e cria um teste'
    context 'dados inválidos' do
      xit 'sem cpf do paciente'
      xit 'sem cpf do paciente válido'
      xit 'sem nome do paciente'
      xit 'sem email do paciente'
      xit 'sem data de nascimento do paciente'
      xit 'sem endereço do paciente'
      xit 'sem cidade do paciente'
      xit 'sem estado do paciente'
      xit 'sem crm do médico'
      xit 'sem estado do crm do médico'
      xit 'sem nome do médico'
      xit 'sem email do médico'
      xit 'sem token do resultado do exame'
      xit 'sem data do exame'
      xit 'sem tipo do exame'
      xit 'sem limites do exame'
      xit 'sem resultado do exame'
    end
  end
end
