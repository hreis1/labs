require 'spec_helper'

RSpec.describe Patient do
  describe '.create' do
    it 'e retorna um paciente' do
      patient = Patient.create(cpf: '048.973.170-88',
                               name: 'Emilly Batista Neto',
                               email: 'gerald.crona@ebert-quigley.com',
                               birthdate: '2001-03-11',
                               address: '165 Rua Rafaela',
                               city: 'Ituverava',
                               state: 'Alagoas')

      expect(patient['id']).not_to be_nil
      expect(patient['cpf']).to eq('048.973.170-88')
      expect(patient['name']).to eq('Emilly Batista Neto')
      expect(patient['email']).to eq('gerald.crona@ebert-quigley.com')
      expect(patient['birthdate']).to eq('2001-03-11')
      expect(patient['address']).to eq('165 Rua Rafaela')
      expect(patient['city']).to eq('Ituverava')
      expect(patient['state']).to eq('Alagoas')
    end

    context 'campo obrigatório não preenchido' do
      it 'não informa o CPF' do
        patient = Patient.create(cpf: '',
                                 name: 'Emilly Batista Neto',
                                 email: 'denna@wisozk.biz',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        expect(patient).to be_nil
        expect(Database.connection.exec('SELECT * FROM patients').count).to eq(0)
      end

      it 'não informa o nome' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: '',
                                 email: 'denna@wisozk.biz',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        expect(patient).to be_nil
        expect(Database.connection.exec('SELECT * FROM patients').count).to eq(0)
      end

      it 'não informa o email' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: '',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        expect(patient).to be_nil
        expect(Database.connection.exec('SELECT * FROM patients').count).to eq(0)
      end

      it 'não informa a data de nascimento' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'denna@wisozk.biz',
                                 birthdate: '',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        expect(patient).to be_nil
        expect(Database.connection.exec('SELECT * FROM patients').count).to eq(0)
      end

      it 'não informa o endereço' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'denna@wisozk.biz',
                                 birthdate: '2001-03-11',
                                 address: '',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        expect(patient).to be_nil
        expect(Database.connection.exec('SELECT * FROM patients').count).to eq(0)
      end

      it 'não informa a cidade' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'denna@wisozk.biz',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: '',
                                 state: 'Alagoas')

        expect(patient).to be_nil
        expect(Database.connection.exec('SELECT * FROM patients').count).to eq(0)
      end

      it 'não informa o estado' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'denna@wisozk.biz',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: '')

        expect(patient).to be_nil
        expect(Database.connection.exec('SELECT * FROM patients').count).to eq(0)
      end
    end
  end

  describe '.find_by_cpf' do
    it 'encontra um paciente' do
      Patient.create(cpf: '048.973.170-88',
                     name: 'Emilly Batista Neto',
                     email: 'gerald.crona@ebert-quigley.com',
                     birthdate: '2001-03-11',
                     address: '165 Rua Rafaela',
                     city: 'Ituverava',
                     state: 'Alagoas')
      Patient.create(cpf: '066.126.400-90',
                     name: 'Matheus Barroso',
                     email: 'maricela@streich.com',
                     birthdate: '1972-03-09',
                     address: '9378 Rua Stella Braga',
                     city: 'Senador Elói de Souza',
                     state: 'Pernambuco')

      patient = Patient.find_by_cpf(cpf: '066.126.400-90')

      expect(patient['cpf']).to eq('066.126.400-90')
      expect(patient['name']).to eq('Matheus Barroso')
      expect(patient['email']).to eq('maricela@streich.com')
      expect(patient['birthdate']).to eq('1972-03-09')
      expect(patient['address']).to eq('9378 Rua Stella Braga')
      expect(patient['city']).to eq('Senador Elói de Souza')
      expect(patient['state']).to eq('Pernambuco')
    end

    it 'retorna nil se não encontrar o paciente' do
      patient = Patient.find_by_cpf(cpf: '066.126.400-90')

      expect(patient).to be_nil
    end
  end
end
