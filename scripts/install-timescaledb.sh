#!/usr/bin/env bash
set -e

echo "Installing TimescaleDB for PostgreSQL 16..."

# Agregar repo oficial de Timescale
wget --quiet -O - https://packagecloud.io/timescale/timescaledb/gpgkey \
  | gpg --dearmor > /usr/share/keyrings/timescaledb.gpg

echo "deb [signed-by=/usr/share/keyrings/timescaledb.gpg] \
https://packagecloud.io/timescale/timescaledb/debian/ \
$(lsb_release -cs) main" \
| tee /etc/apt/sources.list.d/timescaledb.list

apt-get update

apt-get install -y timescaledb-2-postgresql-16

echo "TimescaleDB installed successfully."
