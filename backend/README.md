# LabsLabs
Uma app web para listagem de exames médicos feita com Rack e PostgreSQL

## Requisitos
- Docker

## Como rodar
### Clone o repositório e entre na pasta
```bash
git clone git@github.com:hreis1/rebase_labs.git
cd rebase_labs
```

### Inicializar o servidor
```bash
docker-compose up -d
```

### Importar os dados
Com o servidor criado, execute o script para importar os dados do CSV para o banco de dados:
```bash
docker exec server bash -c "rake db:import"
```
