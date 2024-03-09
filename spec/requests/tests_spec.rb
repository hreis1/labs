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
      expect(json_response.first['email']).to eq('gerald.crona@ebert-quigley.com')
      expect(json_response.first['birthdate']).to eq('2001-03-11')
      expect(json_response.first['doctor']['crm']).to eq('B000BJ20J4')
      expect(json_response.first['doctor']['crm_state']).to eq('PI')
      expect(json_response.first['doctor']['name']).to eq('Maria Luiza Pires')
      expect(json_response.first['tests'].size).to eq(1)
      expect(json_response.first['tests'].first['type']).to eq('hemácias')
      expect(json_response.first['tests'].first['limits']).to eq('45-52')
      expect(json_response.first['tests'].first['result']).to eq '97'
    end
  end
end

describe 'GET /api/tests/:token' do
  it 'retorna um exame' do
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
                              result_token: 'T9O6AI',
                              result_date: '2021-11-21')

    Test.create(exam_id: other_exam['id'],
                type: 'hemácias',
                limits: '45-52',
                result: 48)

    get '/api/tests/T9O6AI'

    expect(last_response).to be_ok
    expect(last_response.content_type).to eq('application/json')
    json_response = JSON.parse(last_response.body)
    expect(json_response['result_token']).to eq('T9O6AI')
    expect(json_response['result_date']).to eq('2021-11-21')
    expect(json_response['cpf']).to eq('048.973.170-88')
    expect(json_response['patient_name']).to eq('Emilly Batista Neto')
    expect(json_response['email']).to eq('gerald.crona@ebert-quigley.com')
    expect(json_response['birthdate']).to eq('2001-03-11')
    expect(json_response['doctor']['crm']).to eq('B000BJ20J4')
    expect(json_response['doctor']['crm_state']).to eq('PI')
    expect(json_response['doctor']['name']).to eq('Maria Luiza Pires')
    expect(json_response['tests'].first['type']).to eq('hemácias')
    expect(json_response['tests'].first['limits']).to eq('45-52')
    expect(json_response['tests'].first['result']).to eq '48'
  end

  it 'e não encontra o exame' do
    get '/api/tests/123'

    expect(last_response).to be_not_found
    expect(last_response.content_type).to eq('application/json')
    expect(JSON.parse(last_response.body)).to eq('error' => 'Exam not found')
  end
end
