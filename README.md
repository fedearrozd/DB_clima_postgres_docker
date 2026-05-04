🐘 PostgreSQL Stack: PostGIS + TimescaleDB
Este repositorio contiene la configuración de infraestructura basada en Docker para una instancia de PostgreSQL 16 optimizada, que incluye soporte para datos geoespaciales y series de tiempo.

🚀 Características
Motor: PostgreSQL 16.

Extensiones: PostGIS (Geoespacial) y TimescaleDB (Series de tiempo).

Backups: Automatizados (diarios) con rotación de 7 días.

Seguridad: Configurado para acceso restringido y gestión de credenciales vía .env.

Salud: Monitoreo mediante healthcheck para asegurar disponibilidad.

## 📦 Contents

The repository includes everything required to **run the database locally using Docker**:

```text
.
├── docker-compose.yml        # Database service definition
├── Dockerfile                # PostgreSQL 16 image with extensions
├── scripts/                  # Scripts to install PostGIS, TimescaleDB, etc.
├── init/                     # SQL initialization scripts (schema, enums, base data)
├── schema                    # Core database schema (users, roles, memberships, profiles, projects)
└── README.md

🏗️ Despliegue
1. Construir y levantar
Para iniciar el servicio por primera vez o después de cambios en el Dockerfile:

Bash
docker compose up -d --build
2. Verificar estado
El contenedor realiza un chequeo de salud cada 10 segundos:

Bash
docker compose ps
Debe mostrar estado (healthy).

3. Ver Logs
Para monitorear la inicialización y ejecución de scripts:

Bash
docker compose logs -f db

💾 Plan de Backups
El servicio backup realiza una copia completa de la base de datos cada medianoche (Schedule: @daily).

Ubicación: Carpeta ./backups.

Compresión: Formato .sql.gz (Z9 - Máxima compresión).

Retención: Se conservan automáticamente los últimos 7 días.

🔒 Notas de Seguridad
Acceso: El puerto expuesto es el 51432 (mapeado internamente al 5432).

Git: Nunca subas la carpeta data/ ni el archivo .env al repositorio.

Persistencia: Los datos se guardan en el volumen local ./data, lo que permite destruir los contenedores sin perder la información.

⌨️ Comandos Útiles
Entrar a consola SQL:

Bash
docker exec -it amtec-db-sc psql -U tu_usuario -d tu_base_datos
Detener servicios:

Bash
docker compose stop
Limpieza total (Borra contenedores y redes):

Bash
docker compose down