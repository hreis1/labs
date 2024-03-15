# Listar exames
```
GET /api/tests
```
## Exemplos de resposta
### Com exames no banco de dados:
```json
[
  {
    "result_token": "IQCZ17",
    "result_date": "2021-08-05",
    "patient_name": "Emilly Batista Neto",
    "email": "emilly@email.com",
    "birthdate": "2001-03-11",
    "doctor": {
      "crm": "B000BJ20J4",
      "crm_state": "PI",
      "name": "Maria Luiza Pires"
    },
    "tests": [
      {
        "type": "hemácias",
        "limits": "45-52",
        "result": 97
      }
    ]
  },
  {
    "result_token": "0W9I67",
    "result_date": "2021-07-09",
    "patient_name": "Luan Oliveira",
    "email": "luan@email.com",
    "birthdate": "1990-01-01",
    "doctor": {
      "crm": "B000BJ20J4",
      "crm_state": "PI",
      "name": "Maria Luiza Pires"
    },
    "tests": [
      {
        "type": "eletrólitos",
        "limits": "2-68",
        "result": 61
      }
    ]
  }
]
```
HTTP Status: 200

### Sem exames no banco de dados:
```json
[]
```
HTTP Status: 200

# Obter exame por Token
```
GET /api/tests/:token
```
## Exemplos de resposta
### Retornando exame com o token fornecido:
```json
{
  "result_token": "IQCZ17",
  "result_date": "2021-08-05",
  "patient_name": "Emilly Batista Neto",
  "email": "emilly@email.com",
  "birthdate": "2001-03-11",
  "doctor": {
    "crm": "B000BJ20J4",
    "crm_state": "PI",
    "name": "Maria Luiza Pires"
  },
  "tests": [
    {
      "type": "hemácias",
      "limits": "45-52",
      "result": 97
    }
  ]
}
```
HTTP Status: 200

### Sem exame com o token fornecido:
```json
{
  "error": "Exam not found"
}
```
HTTP Status: 404


# Importar exames
```
POST /api/import
```

## Exemplo de requisição
```http
POST /api/import HTTP/1.1
Content-Type: text/csv

cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado paciente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
048.973.170-88;Emilly Batista Neto;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000BJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;IQCZ17;2021-08-05;hemácias;45-52;97
```

## Exemplo de resposta

### Com sucesso:

```json
{
  "message": "Exams imported"
}
```
HTTP Status: 201

### Sem sucesso:
O arquivo fornecido é validado antes de ser importado. A validação é feita verificando se o arquivo possui os cabeçalhos corretos e colunas suficientes. Caso o arquivo seja inválido, a resposta será:

```json
{
  "error": "Invalid file"
}
```
HTTP Status: 400
