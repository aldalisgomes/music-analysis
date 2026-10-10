.PHONY: all up db-init run-app down

all: up db-init run-app

up:
	@echo "A subir o contentor do SQL Server 2019..."
	docker-compose up -d

db-init:
	@echo "Aguardando o motor do banco ligar..."
	@for i in 1 2 3 4 5 6 7 8 9 10 11 12; do \
		if [ "$$(docker inspect -f '{{.State.Running}}' sqlserver_db)" = "false" ]; then \
			echo "ERRO FATAL: O banco de dados desligou sozinho. Pode ser falta de memoria no WSL."; exit 1; \
		fi; \
		docker exec sqlserver_db /opt/mssql-tools18/bin/sqlcmd -S 127.0.0.1 -U sa -P SuaSenhaForte123 -C -Q "SELECT 1" > /dev/null 2>&1 && echo "Banco Online!" && break || (echo "Ainda acordando... tentativa $$i/12" && sleep 10); \
	done
	@echo "Criando o banco e tabelas..."
	docker cp setup.sql sqlserver_db:/setup.sql
	docker exec sqlserver_db /opt/mssql-tools18/bin/sqlcmd -S 127.0.0.1 -U sa -P SuaSenhaForte123 -C -Q "CREATE DATABASE SpotifyDB;" || true
	docker exec sqlserver_db /opt/mssql-tools18/bin/sqlcmd -S 127.0.0.1 -U sa -P SuaSenhaForte123 -C -i /setup.sql

run-app:
	@echo "Fazendo o build da imagem do Python..."
	docker build -t spotify-etl .
	@echo "Executando o script de carga no banco..."
	docker run --rm --network $$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.NetworkID}}{{end}}' sqlserver_db) spotify-etl

down:
	@echo "Derrubando os containers e limpando volumes..."
	docker-compose down -v