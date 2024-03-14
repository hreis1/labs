# LabsLabs
Uma app web para listagem e importação de exames médicos feita com Ruby, Sinatra, PostgreSQL, Redis e Sidekiq.

## Requisitos
- Git
- Docker


## Informações sobre o projeto

### Diagrama de Entidade-Relacionamento
As tabelas do banco de dados foram modeladas de acordo com o diagrama de entidade-relacionamento a seguir:

![Diagrama de Entidade-Relacionamento](./diagrama_er.png)

## Instalação
### Clone o repositório e entre na pasta
```bash
git clone git@github.com:hreis1/rebase_labs.git
cd rebase_labs
```

### Initialize os serviços
Execute o comando para subir as aplicações:
```bash
docker compose up -d
```
Com isso, será criado:
  - Um container com o banco de dados PostgreSQL, inicializado com as configurações do arquivo `./api/config/init.sql`, criando o database `postgres` e o database `postgres_test` com as tabelas necessárias.
  - Um container com a api rodando Sinatra na porta 3000.
  - Um container com o frontend rodando Sinatra na porta 3001.
  - Um container com o Sidekiq, que é utilizado para processar os jobs de importação de exames.
  - Um container com o Redis, que é utilizado pelo Sidekiq para armazenar os jobs.

## Testes
### Backend
Com o servidor criado, execute o comando para rodar os testes do backend:
```bash
docker compose exec api rspec
```

### Popular o banco de dados
Com o servidor criado, execute o script para importar os dados do CSV localizado em `./api/data/data.csv` para o banco de dados:
```bash
docker compose exec api ruby import_from_csv.rb
```


## Endpoints da API
### Listar todos os exames no banco de dados.
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

### Obter exame a partir do token
```
GET /api/tests/:token
```

<details>
<summary>Exemplos de resposta</summary>

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

</details>

### Importar exames a partir de um arquivo CSV
```
POST /api/import
```

<details>
<summary>Exemplos de requisição</summary>

```http
POST /api/import HTTP/1.1
Content-Type: text/csv

cpf;nome paciente;email paciente;data nascimento paciente;endereço/rua paciente;cidade paciente;estado paciente;crm médico;crm médico estado;nome médico;email médico;token resultado exame;data exame;tipo exame;limites tipo exame;resultado tipo exame
048.973.170-88;Emilly Batista Neto;gerald.crona@ebert-quigley.com;2001-03-11;165 Rua Rafaela;Ituverava;Alagoas;B000BJ20J4;PI;Maria Luiza Pires;denna@wisozk.biz;IQCZ17;2021-08-05;hemácias;45-52;97
```

</details>

<details>
<summary>Exemplos de resposta</summary>

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

</details>

## Frontend

### Acesse a aplicação web
Com o servidor criado, acesse a aplicação web em `http://localhost:3001`.
