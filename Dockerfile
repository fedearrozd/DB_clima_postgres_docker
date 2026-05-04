FROM postgres:16

ENV DEBIAN_FRONTEND=noninteractive

# --------------------------------------------------
# Instalar dependencias base
# --------------------------------------------------
RUN apt-get update && apt-get install -y \
    gnupg \
    lsb-release \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# --------------------------------------------------
# Copiar scripts de instalación
# --------------------------------------------------
COPY scripts/install-postgis.sh /tmp/install-postgis.sh
COPY scripts/install-timescaledb.sh /tmp/install-timescaledb.sh

RUN chmod +x /tmp/install-postgis.sh /tmp/install-timescaledb.sh

# --------------------------------------------------
# Ejecutar instalaciones
# --------------------------------------------------
RUN /tmp/install-postgis.sh
RUN /tmp/install-timescaledb.sh

# --------------------------------------------------
# Limpieza
# --------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
