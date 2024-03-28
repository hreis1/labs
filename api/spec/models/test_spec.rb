require 'spec_helper'

RSpec.describe Test do
  describe '.create' do
    it 'e retorna um teste' do
      patient = Patient.create(cpf: '048.973.170-88',
                               name: 'Emilly Batista Neto',
                               email: 'gerald.crona@ebert-quigley.com',
                               birthdate: '2001-03-11',
                               address: '165 Rua Rafaela',
                               city: 'Ituverava',
                               state: 'Alagoas')

      doctor = Doctor.create(crm: 'B000BJ20J4',
                             crm_state: 'PI',
                             name: 'Maria Luiza Pires',
                             email: 'denna@wisozk.biz')

      exam = Exam.create(patient_id: patient['id'],
                         doctor_id: doctor['id'],
                         result_token: 'IQCZ17',
                         result_date: '2021-08-05')

      test = Test.create(exam_id: exam['id'],
                         type: 'hemácias',
                         limits: '45-52',
                         result: 97)

      expect(test['id']).not_to be_nil
      expect(test['exam_id']).to eq(exam['id'])
      expect(test['type']).to eq('hemácias')
      expect(test['limits']).to eq('45-52')
      expect(test['result']).to eq '97'
    end

    context 'campos obrigatórios não preenchidos' do
      it 'não informa o tipo' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'gerald.crona@ebert-quigley.com',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        doctor = Doctor.create(crm: 'B000BJ20J4',
                               crm_state: 'PI',
                               name: 'Maria Luiza Pires',
                               email: 'denna@wisozk.biz')

        exam = Exam.create(patient_id: patient['id'],
                           doctor_id: doctor['id'],
                           result_token: 'IQCZ17',
                           result_date: '2021-08-05')

        test = Test.create(exam_id: exam['id'],
                           type: '',
                           limits: '45-52',
                           result: 97)

        expect(test).to be_nil
        expect(Database.connection.exec('SELECT * FROM tests').count).to eq(0)
      end

      it 'não informa os limites' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'gerald.crona@ebert-quigley.com',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        doctor = Doctor.create(crm: 'B000BJ20J4',
                               crm_state: 'PI',
                               name: 'Maria Luiza Pires',
                               email: 'denna@wisozk.biz')

        exam = Exam.create(patient_id: patient['id'],
                           doctor_id: doctor['id'],
                           result_token: 'IQCZ17',
                           result_date: '2021-08-05')

        test = Test.create(exam_id: exam['id'],
                           type: 'hemácias',
                           limits: '',
                           result: 97)

        expect(test).to be_nil
        expect(Database.connection.exec('SELECT * FROM tests').count).to eq(0)
      end

      it 'não informa o resultado' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'gerald.crona@ebert-quigley.com',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        doctor = Doctor.create(crm: 'B000BJ20J4',
                               crm_state: 'PI',
                               name: 'Maria Luiza Pires',
                               email: 'denna@wisozk.biz')

        exam = Exam.create(patient_id: patient['id'],
                           doctor_id: doctor['id'],
                           result_token: 'IQCZ17',
                           result_date: '2021-08-05')

        test = Test.create(exam_id: exam['id'],
                           type: 'hemácias',
                           limits: '45-52',
                           result: nil)

        expect(test).to be_nil
        expect(Database.connection.exec('SELECT * FROM tests').count).to eq(0)
      end
    end
  end
end
