# Usa uma imagem leve do Python
FROM python:3.11-slim

# Variáveis de ambiente para otimizar o Python no Docker
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Define o diretório de trabalho dentro do contêiner
WORKDIR /app

# Instala dependências do sistema e o ODBC Driver 17 for SQL Server
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    unixodbc-dev \
    g++ \
    && curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg \
    && curl -fsSL https://packages.microsoft.com/config/debian/11/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instala as bibliotecas Python necessárias para os scripts
RUN pip install --no-cache-dir pandas sqlalchemy pyodbc openpyxl

# Copia todos os arquivos do projeto para o diretório de trabalho do contêiner
COPY . /app/

# Comando padrão ao iniciar o contêiner
CMD ["python", "load_to_sql.py"]