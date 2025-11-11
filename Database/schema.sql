-- Database: Sprouty

-- DROP DATABASE IF EXISTS "Sprouty";

CREATE DATABASE "Sprouty"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Mexico.1252'
    LC_CTYPE = 'Spanish_Mexico.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
    
-- Crear enumeraciones
CREATE TYPE tipo_notificacion AS ENUM ('alerta', 'recordatorio', 'informacion');
CREATE TYPE metodo_login AS ENUM ('local', 'google', 'facebook');

-- Tabla: usuario
CREATE TABLE usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255),
    foto_perfil VARCHAR(255),
    metodo_login metodo_login NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: maceta
CREATE TABLE maceta (
    id_maceta SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    nombre_maceta VARCHAR(100) NOT NULL,
    ssid_wifi VARCHAR(100),
    estado_conexion BOOLEAN DEFAULT FALSE,
    fecha_configuracion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE
);

-- Tabla: planta
CREATE TABLE planta (
    id_planta SERIAL PRIMARY KEY,
    nombre_comun VARCHAR(100) NOT NULL,
    nombre_cientifico VARCHAR(150) NOT NULL,
    descripcion TEXT,
    humedad_min DECIMAL(5,2),
    humedad_max DECIMAL(5,2),
    luz_min DECIMAL(5,2),
    luz_max DECIMAL(5,2),
    temperatura_min DECIMAL(5,2),
    temperatura_max DECIMAL(5,2),
    recomendaciones TEXT
);

-- Tabla: configuracionmaceta
CREATE TABLE configuracionmaceta (
    id_config SERIAL PRIMARY KEY,
    id_maceta INTEGER NOT NULL,
    humedad_objetivo DECIMAL(5,2),
    luz_objetivo DECIMAL(5,2),
    temperatura_objetivo DECIMAL(5,2),
    notificar_alertas BOOLEAN DEFAULT TRUE,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_maceta) REFERENCES maceta(id_maceta) ON DELETE CASCADE
);

-- Tabla: lecturasensor
CREATE TABLE lecturasensor (
    id_lectura SERIAL PRIMARY KEY,
    id_maceta INTEGER NOT NULL,
    humedad DECIMAL(5,2),
    luz DECIMAL(5,2),
    temperatura DECIMAL(5,2),
    fecha_lectura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_maceta) REFERENCES maceta(id_maceta) ON DELETE CASCADE
);

-- Tabla: jardinvirtual
CREATE TABLE jardinvirtual (
    id_jardin SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_maceta INTEGER NOT NULL,
    id_planta INTEGER NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    alias VARCHAR(100),
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_maceta) REFERENCES maceta(id_maceta) ON DELETE CASCADE,
    FOREIGN KEY (id_planta) REFERENCES planta(id_planta) ON DELETE CASCADE
);

-- Tabla: notification
CREATE TABLE notification (
    id_notificacion SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_maceta INTEGER NOT NULL,
    titulo VARCHAR(100) NOT NULL,
    mensaje TEXT,
    tipo tipo_notificacion NOT NULL,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    leida BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_maceta) REFERENCES maceta(id_maceta) ON DELETE CASCADE
);