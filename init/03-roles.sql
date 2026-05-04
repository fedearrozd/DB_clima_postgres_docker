-- =====================================================
-- Roles y permisos base - ENTORNO DEV
-- PostgreSQL 16
-- =====================================================

-- 1. Configurar search_path para facilitar desarrollo
ALTER ROLE sc_user
SET search_path = core, spatial, metrics, public;

-- -----------------------------------------------------

-- 2. Seguridad básica: revocar accesos públicos
REVOKE ALL ON DATABASE amtec_sc FROM PUBLIC;

-- -----------------------------------------------------

-- 3. Permitir uso de esquemas
GRANT USAGE ON SCHEMA core TO sc_user;
GRANT USAGE ON SCHEMA spatial TO sc_user;
GRANT USAGE ON SCHEMA metrics TO sc_user;

-- -----------------------------------------------------

-- 4. Permitir creación de objetos (DEV necesita flexibilidad)
GRANT CREATE ON SCHEMA core TO sc_user;
GRANT CREATE ON SCHEMA spatial TO sc_user;
GRANT CREATE ON SCHEMA metrics TO sc_user;

-- -----------------------------------------------------

-- 5. Permisos sobre tablas existentes (si las hay)
GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA core TO sc_user;

GRANT SELECT, INSERT, UPDATE, DELETE
ON ALL TABLES IN SCHEMA metrics TO sc_user;

-- -----------------------------------------------------

-- 6. Permisos sobre secuencias existentes
GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA core TO sc_user;

GRANT USAGE, SELECT
ON ALL SEQUENCES IN SCHEMA metrics TO sc_user;

-- -----------------------------------------------------

-- 7. Permisos sobre funciones existentes
GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA core TO sc_user;

GRANT EXECUTE
ON ALL FUNCTIONS IN SCHEMA metrics TO sc_user;

-- -----------------------------------------------------

-- 8. Privilegios por defecto (objetos FUTUROS)
-- Tablas
ALTER DEFAULT PRIVILEGES IN SCHEMA core
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO sc_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA metrics
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO sc_user;

-- Secuencias
ALTER DEFAULT PRIVILEGES IN SCHEMA core
GRANT USAGE, SELECT ON SEQUENCES TO sc_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA metrics
GRANT USAGE, SELECT ON SEQUENCES TO sc_user;

-- Funciones
ALTER DEFAULT PRIVILEGES IN SCHEMA core
GRANT EXECUTE ON FUNCTIONS TO sc_user;

ALTER DEFAULT PRIVILEGES IN SCHEMA metrics
GRANT EXECUTE ON FUNCTIONS TO sc_user;

-- -----------------------------------------------------

-- 9. Asegurar ownership de esquemas
ALTER SCHEMA core OWNER TO sc_user;
ALTER SCHEMA spatial OWNER TO sc_user;
ALTER SCHEMA metrics OWNER TO sc_user;

-- =====================================================
-- FIN - ENTORNO DEV
-- =====================================================
