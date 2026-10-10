.PHONY: all up db-init run-app down

all: up db-init run-app

up:
	@echo "Subindo o container do SQL Server..."
	docker-compose up -d
	@echo "Aguardando o SQL Server ficar 100% pronto (35s)..."
	sleep 35

db-init:
	@echo "Criando o banco de dados e as tabelas..."
	docker cp consultas.sql sqlserver_db:/consultas.sql
	docker exec sqlserver_db /opt/mssql-tools18/bin/sqlcmd -S 127.0.0.1 -U sa -P SuaSenhaForte123 -C -Q "CREATE DATABASE SpotifyDB;"
	docker exec sqlserver_db /opt/mssql-tools18/bin/sqlcmd -S 127.0.0.1 -U sa -P SuaSenhaForte123 -C -i /consultas.sql

run-app:
	@echo "Fazendo o build da imagem do Python..."
	docker build -t spotify-etl .
	@echo "Executando o script de carga no banco..."
	@# Usamos a inspeção para rodar o Python na mesma rede que o Docker Compose criou
	docker run --rm --network $$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}' sqlserver_db) spotify-etl

down:
	@echo "Derrubando os containers..."
	docker-compose down