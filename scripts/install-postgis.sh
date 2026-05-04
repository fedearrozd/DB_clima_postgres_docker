#!/usr/bin/env bash
set -e

echo "Installing PostGIS for PostgreSQL 16..."

apt-get update

apt-get install -y \
  postgis \
  postgresql-16-postgis-3 \
  postgresql-16-postgis-3-scripts

echo "PostGIS installed successfully."
