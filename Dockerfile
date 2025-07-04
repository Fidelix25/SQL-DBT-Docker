# Usando uma imagem base com Python
FROM python:3.11-slim

# Definindo o mantenedor
LABEL maintainer="DBT"

# Atualizando a lista de pacotes e instalando dependências
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    vim \
    nano \
    sqlite3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Criando um diretório de trabalho
WORKDIR /sql-dbt

# Instalando DBT e adaptador para o sqlite
RUN pip install dbt-core==1.5.11
RUN pip install dbt-sqlite==1.5.0

# Expor a porta 8080
EXPOSE 8080

# Definir o comando padrão para execução quando o container for iniciado
CMD ["/bin/bash"]
