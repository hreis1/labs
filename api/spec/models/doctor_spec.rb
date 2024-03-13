require 'spec_helper'

RSpec.describe Doctor do
  describe '.create' do
    it 'e retorna um médico' do
      doctor = Doctor.create(crm: 'B000BJ20J4',
                             crm_state: 'PI',
                             name: 'Maria Luiza Pires',
                             email: 'denna@wisozk.biz')

      expect(doctor['id']).not_to be_nil
      expect(doctor['crm']).to eq('B000BJ20J4')
      expect(doctor['crm_state']).to eq('PI')
      expect(doctor['name']).to eq('Maria Luiza Pires')
      expect(doctor['email']).to eq('denna@wisozk.biz')
    end

    context 'campo obrigatório não preenchido' do
      it 'não informa o CRM' do
        doctor = Doctor.create(crm: '',
                               crm_state: 'PI',
                               name: 'Maria Luiza Pires',
                               email: 'denna@wisozk.biz',)
        
        expect(doctor).to be_nil
        expect(Database.connection.exec('SELECT * FROM doctors').count).to eq(0)
      end

      it 'não informa o estado do CRM' do
        doctor = Doctor.create(crm: 'B000BJ20J4',
                               crm_state: '',
                               name: 'Maria Luiza Pires',
                               email: 'denna@wisozk.biz')
        
        expect(doctor).to be_nil
        expect(Database.connection.exec('SELECT * FROM doctors').count).to eq(0)
      end

      it 'não informa o nome' do
        doctor = Doctor.create(crm: 'B000BJ20J4',
                               crm_state: 'PI',
                               name: '',
                               email: 'denna@wisozk.biz')

        expect(doctor).to be_nil
        expect(Database.connection.exec('SELECT * FROM doctors').count).to eq(0)
      end

      it 'não informa o email' do
        doctor = Doctor.create(crm: 'B000BJ20J4',
                               crm_state: 'PI',
                               name: 'Maria Luiza Pires',
                               email: '')

        expect(doctor).to be_nil
        expect(Database.connection.exec('SELECT * FROM doctors').count).to eq(0)
      end
    end
  end

  describe '.find_by_crm' do
    it 'encontra um médico' do
      Doctor.create(crm: 'B000BJ20J4',
                    crm_state: 'PI',
                    name: 'Maria Luiza Pires',
                    email: 'denna@wisozk.biz')
      Doctor.create(crm: 'B000B7CDX4',
                    crm_state: 'SP',
                    name: 'Calebe Louzada',
                    email: 'kendra@nolan-sawayn.co')

      doctor = Doctor.find_by_crm(crm: 'B000B7CDX4', crm_state: 'SP')

      expect(doctor['id']).not_to be_nil
      expect(doctor['crm']).to eq('B000B7CDX4')
      expect(doctor['crm_state']).to eq('SP')
      expect(doctor['name']).to eq('Calebe Louzada')
      expect(doctor['email']).to eq('kendra@nolan-sawayn.co')
    end
  end
end
