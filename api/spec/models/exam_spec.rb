require 'spec_helper'

RSpec.describe Exam do
  describe '.create' do
    it 'e retorna um exame' do
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

      expect(exam['id']).not_to be_nil
      expect(exam['patient_id']).to eq(patient['id'])
      expect(exam['doctor_id']).to eq(doctor['id'])
      expect(exam['result_token']).to eq('IQCZ17')
      expect(exam['result_date']).to eq('2021-08-05')
    end

    it 'e retorna nil se o paciente não existir' do
      doctor = Doctor.create(crm: 'B000BJ20J4',
                             crm_state: 'PI',
                             name: 'Maria Luiza Pires',
                             email: 'denna@wisozk.biz')

      exam = Exam.create(patient_id: 1,
                         doctor_id: doctor['id'],
                         result_token: 'IQCZ17',
                         result_date: '2021-08-05')

      expect(exam).to be_nil
      expect(Database.connection.exec('SELECT * FROM exams').count).to eq(0)
    end

    it 'e retorna nil se o médico não existir' do
      patient = Patient.create(cpf: '048.973.170-88',
                               name: 'Emilly Batista Neto',
                               email: 'denna@wisozk.biz',
                               birthdate: '2001-03-11',
                               address: '165 Rua Rafaela',
                               city: 'Ituverava',
                               state: 'Alagoas')

      exam = Exam.create(patient_id: patient['id'],
                         doctor_id: 1,
                         result_token: 'IQCZ17',
                         result_date: '2021-08-05')

      expect(exam).to be_nil
      expect(Database.connection.exec('SELECT * FROM exams').count).to eq(0)
    end

    it 'e retorna nil se o token do exame já existir' do
      patient = Patient.create(cpf: '048.973.170-88',
                               name: 'Emilly Batista Neto',
                               email: 'denna@wisozk.biz',
                               birthdate: '2001-03-11',
                               address: '165 Rua Rafaela',
                               city: 'Ituverava',
                               state: 'Alagoas')

      doctor = Doctor.create(crm: 'B000BJ20J4',
                             crm_state: 'PI',
                             name: 'Maria Luiza Pires',
                             email: 'gerald.crona@ebert-quigley.com')

      Exam.create(patient_id: patient['id'],
                  doctor_id: doctor['id'],
                  result_token: 'IQCZ17',
                  result_date: '2021-08-05')

      exam = Exam.create(patient_id: patient['id'],
                         doctor_id: doctor['id'],
                         result_token: 'IQCZ17',
                         result_date: '2021-08-05')

      expect(exam).to be_nil
      expect(Database.connection.exec('SELECT * FROM exams').count).to eq(1)
    end

    context 'campo obrigatório não preenchido' do
      it 'não informa o paciente' do
        doctor = Doctor.create(crm: 'B000BJ20J4',
                               crm_state: 'PI',
                               name: 'Maria Luiza Pires',
                               email: 'denna@wisozk.biz')

        exam = Exam.create(patient_id: nil,
                           doctor_id: doctor['id'],
                           result_token: 'IQCZ17',
                           result_date: '2021-08-05')

        expect(exam).to be_nil
        expect(Database.connection.exec('SELECT * FROM exams').count).to eq(0)
      end

      it 'não informa o médico' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'denna@wisozk.biz',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        exam = Exam.create(patient_id: patient['id'],
                           doctor_id: nil,
                           result_token: 'IQCZ17',
                           result_date: '2021-08-05')

        expect(exam).to be_nil
        expect(Database.connection.exec('SELECT * FROM exams').count).to eq(0)
      end

      it 'não informa o token do exame' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'denna@wisozk.biz',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        doctor = Doctor.create(crm: 'B000BJ20J4',
                               crm_state: 'PI',
                               name: 'Maria Luiza Pires',
                               email: 'gerald.crona@ebert-quigley.com')

        exam = Exam.create(patient_id: patient['id'],
                           doctor_id: doctor['id'],
                           result_token: '',
                           result_date: '2021-08-05')

        expect(exam).to be_nil
        expect(Database.connection.exec('SELECT * FROM exams').count).to eq(0)
      end

      it 'não informa a data do exame' do
        patient = Patient.create(cpf: '048.973.170-88',
                                 name: 'Emilly Batista Neto',
                                 email: 'denna@wisozk.biz',
                                 birthdate: '2001-03-11',
                                 address: '165 Rua Rafaela',
                                 city: 'Ituverava',
                                 state: 'Alagoas')

        doctor = Doctor.create(crm: 'B000BJ20J4',
                               crm_state: 'PI',
                               name: 'Maria Luiza Pires',
                               email: 'gerald.crona@ebert-quigley.com')

        exam = Exam.create(patient_id: patient['id'],
                           doctor_id: doctor['id'],
                           result_token: 'IQCZ17',
                           result_date: '')

        expect(exam).to be_nil
        expect(Database.connection.exec('SELECT * FROM exams').count).to eq(0)
      end
    end
  end

  describe '.find_by_result_token' do
    it 'e retorna um exame' do
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

      Test.create(exam_id: exam['id'],
                  type: 'hemácias',
                  limits: '45-52',
                  result: 97)

      other_exam = Exam.create(patient_id: patient['id'],
                               doctor_id: doctor['id'],
                               result_token: 'IQCZ18',
                               result_date: '2021-08-05')

      Test.create(exam_id: other_exam['id'],
                  type: 'eletrólitos',
                  limits: '2-68',
                  result: 61)

      Test.create(exam_id: other_exam['id'],
                  type: 'hemoglobina',
                  limits: '12-16',
                  result: 14)

      exam = Exam.find_by_result_token(result_token: 'IQCZ18')

      expect(exam['id']).not_to be_nil
      expect(exam['result_token']).to eq('IQCZ18')
      expect(exam['result_date']).to eq('2021-08-05')
      expect(exam['patient_name']).to eq(patient['name'])
      expect(exam['email']).to eq(patient['email'])
      expect(exam['birthdate']).to eq(patient['birthdate'])
      expect(exam['doctor']['crm']).to eq(doctor['crm'])
      expect(exam['doctor']['crm_state']).to eq(doctor['crm_state'])
      expect(exam['doctor']['name']).to eq(doctor['name'])
      expect(exam['tests']).to eq [
        { 'type' => 'eletrólitos', 'limits' => '2-68', 'result' => '61' },
        { 'type' => 'hemoglobina', 'limits' => '12-16', 'result' => '14' }
      ]
    end

    it 'e retorna nil se não encontrar o exame' do
      exam = Exam.find_by_result_token(result_token: 'IQCZ19')

      expect(exam).to be_nil
    end
  end

  describe '.paginate' do
    it 'e retorna os exames paginados' do
      patient = Patient.create( cpf: '048.973.170-88', name: 'Emilly Batista Neto', email: 'gerald.crona@ebert-quigley.com', birthdate: '2001-03-11', address: '165 Rua Rafaela', city: 'Ituverava', state: 'Alagoas')
  
      doctor = Doctor.create( crm: 'B000BJ20J4', crm_state: 'PI', name: 'Maria Luiza Pires', email: 'denna@wisozk.biz')
  
      exam = Exam.create( patient_id: patient['id'], doctor_id: doctor['id'], result_token: 'IQCZ17', result_date: '2021-08-05')
  
      Test.create(exam_id: exam['id'], type: 'hemácias', limits: '45-52', result: 97)
  
      other_exam = Exam.create( patient_id: patient['id'], doctor_id: doctor['id'], result_token: 'IQCZ18', result_date: '2021-08-06')
  
      Test.create(exam_id: other_exam['id'], type: 'leucócitos', limits: '9-61', result: 89)
  
      another_exam = Exam.create( patient_id: patient['id'], doctor_id: doctor['id'], result_token: 'IQCZ19', result_date: '2021-08-07')
  
      Test.create(exam_id: another_exam['id'], type: 'plaquetas', limits: '11-93', result: 97)
  
      more_exam = Exam.create(patient_id: patient['id'], doctor_id: doctor['id'], result_token: 'IQCZ20', result_date: '2021-08-08')
  
      Test.create(exam_id: more_exam['id'], type: 'hdl', limits: '19-75', result: 0)
  
      more_other_exam = Exam.create(patient_id: patient['id'], doctor_id: doctor['id'], result_token: 'IQCZ21', result_date: '2021-08-09')
  
      Test.create(exam_id: more_other_exam['id'], type: 'ldl', limits: '45-54', result: 80)
  
      more_another_exam = Exam.create(patient_id: patient['id'], doctor_id: doctor['id'], result_token: 'IQCZ22', result_date: '2021-08-10')
  
      Test.create(exam_id: more_another_exam['id'], type: 'vldl', limits: '48-72', result: 82)
  
      get '/api/tests'

      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
    end

    it 'e retorna um array vazio se não houver exames' do
      exams = Exam.paginate(page: 1, per_page: 10)

      expect(exams).to eq([])
    end
  end
end
