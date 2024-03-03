require 'rack/test'
require 'rspec'
require_relative '../server'

RSpec.describe 'Server' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it '/' do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello world!')
  end

  context '/tests' do
    it 'e não tem exames' do
      allow(Test).to receive(:all).and_return([])

      get '/tests'
      expect(last_response).to be_ok
      expect(last_response.body).to eq('[]')
    end
    it 'e tem exames' do
      exames = [
        { id: 1, cpf: '048.973.170-88', nome: 'Emilly Batista Neto', email: 'gerald.crona@ebert-quigley.com',
          data_nascimento: '2001-03-11', endereco_rua: '165 Rua Rafaela', cidade: 'Ituverava', estado: 'Alagoas',
          crm_medico: 'B000BJ20J4', crm_medico_estado: 'PI', nome_medico: 'Maria Luiza Pires',
          email_medico: 'denna@wisozk.biz', token_resultado_exame: 'IQCZ17', data_exame: '2021-08-05',
          tipo_exame: 'hemácias', limites_tipo_exame: '45-52', resultado_tipo_exame: '97' },
        { id: 2, cpf: '048.973.170-88', nome: 'Emilly Batista Neto', email: 'gerald.crona@ebert-quigley.com',
          data_nascimento: '2001-03-11', endereco_rua: '165 Rua Rafaela', cidade: 'Ituverava', estado: 'Alagoas',
          crm_medico: 'B000BJ20J4', crm_medico_estado: 'PI', nome_medico: 'Maria Luiza Pires',
          email_medico: 'denna@wisozk.biz', token_resultado_exame: 'IQCZ17', data_exame: '2021-08-05',
          tipo_exame: 'leucócitos', limites_tipo_exame: '9-61', resultado_tipo_exame: '89' }
      ]

      allow(Test).to receive(:all).and_return(exames)

      get '/tests'
      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      expect(last_response.body).to eq(exames.to_json)
      json = JSON.parse(last_response.body)
      expect(json.size).to eq(2)
      expect(json[0]['id']).to eq(1)
      expect(json[0]['cpf']).to eq '048.973.170-88'
      expect(json[0]['nome']).to eq 'Emilly Batista Neto'
      expect(json[0]['email']).to eq 'gerald.crona@ebert-quigley.com'
      expect(json[0]['data_nascimento']).to eq '2001-03-11'
      expect(json[0]['endereco_rua']).to eq '165 Rua Rafaela'
      expect(json[0]['cidade']).to eq 'Ituverava'
      expect(json[0]['estado']).to eq 'Alagoas'
      expect(json[0]['crm_medico']).to eq 'B000BJ20J4'
      expect(json[0]['crm_medico_estado']).to eq 'PI'
      expect(json[0]['nome_medico']).to eq 'Maria Luiza Pires'
      expect(json[0]['email_medico']).to eq 'denna@wisozk.biz'
      expect(json[0]['token_resultado_exame']).to eq 'IQCZ17'
      expect(json[0]['data_exame']).to eq '2021-08-05'
      expect(json[0]['tipo_exame']).to eq 'hemácias'
      expect(json[0]['limites_tipo_exame']).to eq '45-52'
      expect(json[0]['resultado_tipo_exame']).to eq '97'
      expect(json[1]['id']).to eq(2)
      expect(json[1]['cpf']).to eq '048.973.170-88'
      expect(json[1]['nome']).to eq 'Emilly Batista Neto'
      expect(json[1]['email']).to eq 'gerald.crona@ebert-quigley.com'
      expect(json[1]['data_nascimento']).to eq '2001-03-11'
      expect(json[1]['endereco_rua']).to eq '165 Rua Rafaela'
      expect(json[1]['cidade']).to eq 'Ituverava'
      expect(json[1]['estado']).to eq 'Alagoas'
      expect(json[1]['crm_medico']).to eq 'B000BJ20J4'
      expect(json[1]['crm_medico_estado']).to eq 'PI'
      expect(json[1]['nome_medico']).to eq 'Maria Luiza Pires'
      expect(json[1]['email_medico']).to eq 'denna@wisozk.biz'
      expect(json[1]['token_resultado_exame']).to eq 'IQCZ17'
      expect(json[1]['data_exame']).to eq '2021-08-05'
      expect(json[1]['tipo_exame']).to eq 'leucócitos'
      expect(json[1]['limites_tipo_exame']).to eq '9-61'
      expect(json[1]['resultado_tipo_exame']).to eq '89'
    end
  end
end
