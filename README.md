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
