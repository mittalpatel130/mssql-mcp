FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app

# Install system dependencies for pyodbc and MS SQL ODBC driver
RUN apt-get update && \
    apt-get install -y curl gnupg2 ca-certificates apt-transport-https && \
    mkdir -p /etc/apt/trusted.gpg.d && \
    curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg && \
    curl -sSL https://packages.microsoft.com/config/debian/11/prod.list -o /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y gcc g++ msodbcsql17 unixodbc-dev && \
    rm -rf /var/lib/apt/lists/*

# Upgrade pip and install Python dependencies
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install -r requirements.txt

# Install mcpo if not listed in requirements.txt
RUN python3 -m pip install mcpo

# Default command
CMD ["mcpo", "--config", "config.json"]
