# LabsLabs
Uma app web para listagem de exames médicos feita com Sinatra e PostgreSQL

## Requisitos
- Docker

## Como rodar
### Clone o repositório e entre na pasta
```bash
git clone git@github.com:hreis1/rebase_labs.git
cd rebase_labs
```

### Crie a rede
A rede é criada para que o servidor e o banco de dados possam se comunicar
```bash
docker network create -d bridge relabs
```

### Crie o banco de dados
O banco de dados é criado e inicializado com o script `init.sql` para criar a tabela `tests`
```bash
docker run \
  --rm \
  --network relabs \
  --name postgres \
  -v ./init.sql:/docker-entrypoint-initdb.d/init.sql \
  -p 5432:5432 \
  -e POSTGRES_PASSWORD=postgres \
  -d postgres
```

### Criar o servidor
```bash
docker run \
  --rm \
  --network relabs \
  --name server \
  -w /app \
  -v .:/app \
  -p 3000:3000 \
  -e DB_HOST=postgres \
  -d ruby \
  bash -c "bundle && ruby server.rb"
```
O servidor é criado e pode ser acessado em http://localhost:3000

### Executar os testes
Com o servidor criado, execute os testes com o comando abaixo:
```bash
docker exec \
  -it \
  server \
  bash -c "rspec"
```

### Importar os dados
Com o servidor criado, execute o script para importar os dados do CSV para o banco de dados:
```bash
docker exec -it -e DB_HOST=postgres server bash -c "ruby import_from_csv.rb"
```
ou o comando abaixo se tiver o Ruby instalado na máquina:
```bash
ruby import_from_csv.rb
```

