require 'spec_helper'

describe 'GET /api/tests' do
  context 'retorna uma lista de exames' do
    it 'e não tem nenhum exame' do
      get '/api/tests'

      expect(last_response).to be_ok
      expect(JSON.parse(last_response.body)).to eq([])
    end

    it 'com um exame' do
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

      get '/api/tests'

      expect(last_response).to be_ok
      expect(last_response.content_type).to eq('application/json')
      json_response = JSON.parse(last_response.body)
      expect(json_response.size).to eq(1)
      expect(json_response.first['result_token']).to eq('IQCZ17')
      expect(json_response.first['result_date']).to eq('2021-08-05')
      expect(json_response.first['cpf']).to eq('048.973.170-88')
      expect(json_response.first['patient_name']).to eq('Emilly Batista Neto')
      expect(json_response.first['doctor']['name']).to eq('Maria Luiza Pires')
    end
 
    it 'com paginação' do
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

      get '/api/tests', page: 1, per_page: 4

      expect(last_response).to be_ok

      json_response = JSON.parse(last_response.body)
      expect(json_response.size).to eq(4)
    end
  end
end
