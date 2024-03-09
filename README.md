# LabsLabs
Uma app web para listagem de exames médicos feita com Sinatra e PostgreSQL.

## Requisitos
- Docker

## Como rodar
### Clone o repositório e entre na pasta
```bash
git clone git@github.com:hreis1/rebase_labs.git
cd rebase_labs
```

### Criar o servidor
```bash
docker-compose up -d
```

### Importar os dados
Com o servidor criado, execute o script para importar os dados do CSV para o banco de dados:
```bash
docker exec api ruby import_from_csv.rb
```

### Rodar os testes
Com o servidor criado, execute o comando para rodar os testes:
```bash
docker exec api bash -c "rspec"
```

## Endpoints
### Listar exames
```
GET /api/tests
```

<details>
<summary>Exemplos de resposta</summary>

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

</details>

### Obter exame
```
GET /api/tests/:token
```

<details>
<summary>Exemplos de resposta</summary>

### Com exame no banco de dados:

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

### Sem exame no banco de dados:

```json
{
  "error": "Exam not found"
}
```

HTTP Status: 404

</details>

### Importar exames
```
POST /api/import
```
