# 🐘 PostgreSQL Stack: PostGIS + TimescaleDB

Este repositorio proporciona una infraestructura robusta basada en Docker para una instancia de **PostgreSQL 16**, diseñada específicamente para proyectos que requieren capacidades geoespaciales avanzadas y manejo eficiente de series de tiempo.

---

## 🚀 Características Principales

| Componente | Detalle |
|---|---|
| Motor | PostgreSQL 16 |
| Geoespacial | PostGIS |
| Series de Tiempo | TimescaleDB |
| Backups | Automatizados (diarios) con rotación de 7 días |
| Monitoreo | Healthcheck integrado para asegurar disponibilidad |
| Seguridad | Gestión de credenciales mediante variables de entorno |

---

## 📦 Estructura del Proyecto

```
.
├── docker-compose.yml   # Definición de servicios (DB + Backup)
├── Dockerfile           # Imagen personalizada de Postgres 16 + Extensiones
├── scripts/             # Scripts de instalación de extensiones
├── init/                # SQL de inicialización (esquemas y datos base)
├── schema/              # Definición del core (usuarios, roles, proyectos)
└── backups/             # Directorio local para copias de seguridad
```

---

## 🛠️ Configuración Inicial

Antes de levantar los contenedores, configura las variables de entorno:

**1. Clonar el archivo de ejemplo:**

```bash
cp .env.example .env
```

**2. Configurar credenciales:**

Abre el archivo `.env` y modifica los valores de conexión:

```env
POSTGRES_USER=tu_usuario
POSTGRES_PASSWORD=tu_contraseña_segura
POSTGRES_DB=nombre_db
```

---

## 🏗️ Despliegue

### 1. Construir y Levantar

Para iniciar el servicio por primera vez o después de realizar cambios en el `Dockerfile`:

```bash
docker compose up -d --build
```

### 2. Verificar Estado

El contenedor realiza un chequeo de salud cada 10 segundos:

```bash
docker compose ps
```

> El estado debe aparecer como `(healthy)`.

### 3. Monitoreo de Logs

Para revisar la inicialización de los scripts o el estado de las extensiones:

```bash
docker compose logs -f db
```

---

## 💾 Backups y Recuperación

### ¿Cómo funciona el Backup?

El servicio usa la imagen `prodrigestivill/postgres-backup-local`, que ejecuta `pg_dump` internamente para exportar toda la base de datos a un archivo `.sql.gz`.

```
[Contenedor db] → (cada medianoche) → pg_dump → archivo .sql.gz → [./backups/]
```

| Variable | Valor | Qué hace |
|---|---|---|
| `SCHEDULE` | `@daily` | Ejecuta el backup a medianoche |
| `BACKUP_KEEP_DAYS` | `7` | Borra backups con más de 7 días |
| `POSTGRES_EXTRA_OPTS` | `-Z9` | Compresión máxima del archivo |

Los archivos se guardan con el formato:
```
nombre_db-2026-05-05T000000Z.sql.gz
```

### Backup Manual

Si no quieres esperar al horario automático:

```bash
docker exec amtec-db-sc pg_dump -U tu_usuario -d tu_base_datos | gzip -9 > ./backups/manual-$(date +%Y%m%d).sql.gz
```

### Recuperación (Restore)

**1. Ver los backups disponibles:**

```bash
ls -lh ./backups/
```

**2. Descomprimir el archivo:**

```bash
gunzip ./backups/nombre_db-2026-05-05T000000Z.sql.gz
```

**3. Restaurar en la base de datos:**

```bash
docker exec -i amtec-db-sc psql -U tu_usuario -d tu_base_datos < ./backups/nombre_db-2026-05-05T000000Z.sql
```

> Si quieres un restore limpio sin datos previos, primero recrea la base de datos:
> ```bash
> docker exec -it amtec-db-sc psql -U tu_usuario -c "DROP DATABASE tu_base_datos;"
> docker exec -it amtec-db-sc psql -U tu_usuario -c "CREATE DATABASE tu_base_datos;"
> ```

El backup incluye **esquema + datos**, por lo que la restauración recrea tablas, índices, extensiones (PostGIS, TimescaleDB) y todos los registros tal como estaban al momento del backup.

---

## 🔒 Notas de Seguridad y Persistencia

- **Puertos:** La base de datos es accesible externamente a través del puerto `51432` (mapeado al `5432` interno).
- **Git:** La carpeta `data/` y el archivo `.env` están excluidos del control de versiones.
- **Volúmenes:** Se utiliza el volumen local `./data` para la persistencia — puedes reiniciar o borrar los contenedores sin perder datos.

---

## ⌨️ Comandos Útiles

**Acceder a la terminal de PostgreSQL:**

```bash
docker exec -it amtec-db-sc psql -U tu_usuario -d tu_base_datos
```

**Detener los servicios:**

```bash
docker compose stop
```

**Limpieza total (borra contenedores y redes):**

```bash
docker compose down
```
