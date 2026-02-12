-- Combined MySQL script generated from scripts/mariadb
-- Includes: database creation, table creation and population

-- 1) Create database if not exists and switch to it
CREATE DATABASE IF NOT EXISTS instituto;
USE instituto;

-- 2) Tables: profesor, tiposbasicos, cicloformativo
-- Create 'profesor'
CREATE TABLE IF NOT EXISTS profesor (
   Id INT AUTO_INCREMENT NOT NULL,
   nombre VARCHAR(255) NOT NULL,
   ape1 VARCHAR(255) NOT NULL,
   ape2 VARCHAR(255) NOT NULL,
   tipoFuncionario VARCHAR(100) DEFAULT NULL,
   PRIMARY KEY (Id)
);

-- Create 'tiposbasicos'
CREATE TABLE IF NOT EXISTS tiposbasicos (
   inte INT NOT NULL,
   bigint1 BIGINT DEFAULT NULL,
   smallint1 SMALLINT DEFAULT NULL,
   float1 FLOAT DEFAULT NULL,
   character1 CHAR(1) DEFAULT NULL,
   byte1 TINYINT DEFAULT NULL,
   bit1 BOOLEAN DEFAULT NULL,
   stri VARCHAR(255) DEFAULT NULL,
   dateDate DATE DEFAULT NULL,
   timeTime TIME(0) DEFAULT NULL,
   dateTime2 DATETIME(0) DEFAULT NULL,
   texto TEXT,
   binario VARBINARY(255),
   bigDecimal DECIMAL(19,2) DEFAULT NULL,
   PRIMARY KEY (inte)
);

-- Create 'cicloformativo'
CREATE TABLE IF NOT EXISTS cicloformativo (
   idCiclo INT AUTO_INCREMENT NOT NULL,
   nombreCiclo VARCHAR(100) DEFAULT NULL,
   horas INT DEFAULT NULL,
   PRIMARY KEY (idCiclo)
);

-- 3) Additional tables (fase 2): comunidadAutonoma, provincia, direccion, modulo, profesormodulo
CREATE TABLE IF NOT EXISTS comunidadAutonoma (
    idCA INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    PRIMARY KEY (idCA)
);

CREATE TABLE IF NOT EXISTS provincia (
    idProvincia INT NOT NULL,
    nombre VARCHAR(100) DEFAULT NULL,
    idCA INT NOT NULL,
    PRIMARY KEY (idProvincia),
    FOREIGN KEY (idCA) REFERENCES comunidadAutonoma(idCA)
);

CREATE TABLE IF NOT EXISTS direccion (
    id INT AUTO_INCREMENT NOT NULL,
    calle VARCHAR(255) DEFAULT NULL,
    numero INT DEFAULT NULL,
    poblacion VARCHAR(255) DEFAULT NULL,
    idProvincia INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (idProvincia) REFERENCES provincia(idProvincia)
);

CREATE TABLE IF NOT EXISTS modulo (
    idModulo INT AUTO_INCREMENT NOT NULL,
    nombre VARCHAR(255) NOT NULL,
    PRIMARY KEY (idModulo)
);

CREATE TABLE IF NOT EXISTS profesormodulo (
    idProfesor INT NOT NULL,
    idModulo INT NOT NULL,
    PRIMARY KEY (idModulo, idProfesor),
    FOREIGN KEY (idModulo) REFERENCES modulo(idModulo),
    FOREIGN KEY (idProfesor) REFERENCES profesor(Id)
);

-- 4) contactInfo: drop and recreate (uses InnoDB for FKs)
DROP TABLE IF EXISTS contactInfo;
CREATE TABLE contactInfo (
    id INT AUTO_INCREMENT NOT NULL,
    profesorId INT NOT NULL,
    email VARCHAR(255) NOT NULL,
    tlf_movil VARCHAR(15),
    PRIMARY KEY (id),
    UNIQUE KEY UC_contactInfo_UNIQUE_profesorID (profesorId),
    UNIQUE KEY UC_contactInfo_UNIQUE_email (email),
    CONSTRAINT FK_contactInfo_profesor FOREIGN KEY (profesorId) REFERENCES profesor(Id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5) Populate: profesor
INSERT INTO profesor (nombre, ape1, ape2, tipoFuncionario)
SELECT nombre, ape1, ape2, tipoFuncionario
FROM (
    SELECT 'Juan' AS nombre, 'Perez' AS ape1, 'García' AS ape2, NULL AS tipoFuncionario UNION ALL
    SELECT 'Carlos', 'González', 'Oltra', NULL UNION ALL
    SELECT 'Sergio', 'Mateo', 'Ramis', NULL UNION ALL
    SELECT 'Paco', 'Moreno', 'Díaz', NULL UNION ALL
    SELECT 'Ana', 'Morales', 'Ortega', NULL UNION ALL
    SELECT 'Marcos', 'Tortosa', 'Martínez', NULL UNION ALL
    SELECT 'Sara', 'Barrrera', 'Salas', NULL UNION ALL
    SELECT 'Raquel', 'Peqrez', 'Izquierdo', NULL UNION ALL
    SELECT 'Rosa', 'Díaz', 'Del Toro', NULL UNION ALL
    SELECT 'Laura', 'Vivó', 'López', NULL UNION ALL
    SELECT 'Emilio', 'Perez', 'García', NULL UNION ALL
    SELECT 'Alfredo', 'González', 'Oltra', NULL UNION ALL
    SELECT 'Eduardo', 'Grau', 'Aroca', NULL UNION ALL
    SELECT 'Pau', 'Ayala', 'Fuentes', NULL UNION ALL
    SELECT 'Gabriel', 'Sáez', 'Izquierdo', NULL UNION ALL
    SELECT 'Javier', 'Ramírez', 'Olmo', NULL UNION ALL
    SELECT 'Elias', 'Rubio', 'Sánchez', '0' UNION ALL
    SELECT 'Juan Manuel', 'Campos', 'Alierta', '1' UNION ALL
    SELECT 'Anabel', 'Marco', 'Izquierdo', '2' UNION ALL
    SELECT 'Ricardo', 'Acosta', 'Soler', '0' UNION ALL
    SELECT 'Laura', 'Vallés', 'Muñoz', '1' UNION ALL
    SELECT 'Elisa', 'Amador', 'Serra', '2'
) AS temp
WHERE NOT EXISTS (SELECT 1 FROM profesor);

-- 6) Populate: cicloformativo
INSERT INTO cicloformativo (nombreCiclo, horas)
SELECT nombreCiclo, horas
FROM (
    SELECT 'DAM' AS nombreCiclo, 1890 AS horas UNION ALL
    SELECT 'DAW', 1900
) AS temp
WHERE NOT EXISTS (SELECT 1 FROM cicloformativo);

-- 7) Populate: tiposbasicos (se insertan varias filas si no existen)
INSERT INTO tiposbasicos (inte, bigint1, smallint1, float1, character1, byte1, bit1, stri, dateDate, timeTime, dateTime2, texto, binario, bigDecimal)
SELECT 1, 12, 13, 14.1, 'W', 16, 1, 'Hola mundo', '2022-01-23', '18:36:07', '2022-01-23 18:36:07', 
       'texto muyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy largo',
       0x45f53a67ff, 5345345324532.00
WHERE NOT EXISTS (SELECT 1 FROM tiposbasicos WHERE inte = 1 AND bigint1 = 12);

INSERT INTO tiposbasicos (inte, bigint1, smallint1, float1, character1, byte1, bit1, stri, dateDate, timeTime, dateTime2, texto, binario, bigDecimal)
SELECT 2, 12, 13, 14.1, 'W', 16, 0, 'Hola mundo', '2022-01-23', '18:36:07', '2022-01-23 18:36:07', 
       'texto muyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy largo',
       0x45f53a67ff, 5345345324532.00
WHERE NOT EXISTS (SELECT 1 FROM tiposbasicos WHERE inte = 2 AND bigint1 = 12);

INSERT INTO tiposbasicos (inte, bigint1, smallint1, float1, character1, byte1, bit1, stri, dateDate, timeTime, dateTime2, texto, binario, bigDecimal)
SELECT 3, 12, 13, 15.2, 'W', 16, 1, 'Hola mundo', '2022-01-23', '18:40:06', '2022-01-23 18:40:06', 
       'texto muyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy largo',
       0x45f53a67ff, 5345345324532.00
WHERE NOT EXISTS (SELECT 1 FROM tiposbasicos WHERE inte = 3 AND bigint1 = 12);

INSERT INTO tiposbasicos (inte, bigint1, smallint1, float1, character1, byte1, bit1, stri, dateDate, timeTime, dateTime2, texto, binario, bigDecimal)
SELECT 4, 12, 13, 15.2, 'W', 16, 0, 'Hola mundo', '2022-01-23', '18:40:06', '2022-01-23 18:40:06',
       'texto muyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy largo',
       0x45f53a67ff, 5345345324532.00
WHERE NOT EXISTS (SELECT 1 FROM tiposbasicos WHERE inte = 4 AND bigint1 = 12);

-- 8) Populate fase 2: comunidadAutonoma, provincia, direccion, modulo, profesormodulo
INSERT IGNORE INTO comunidadAutonoma (idCA, nombre) VALUES 
(1, 'Andalucía'),
(2, 'Aragón'),
(3, 'Asturias, Principado de'),
(4, 'Illes Balears'),
(5, 'Canarias'),
(6, 'Cantabria'),
(7, 'Castilla y León'),
(8, 'Castilla - La Mancha'),
(9, 'Cataluña'),
(10, 'Comunitat Valenciana'),
(11, 'Extremadura'),
(12, 'Galicia'),
(13, 'Comunidad de Madrid'),
(14, 'Región de Murcia'),
(15, 'Comunidad Foral de Navarra'),
(16, 'País Vasco'),
(17, 'Rioja, La'),
(18, 'Ceuta'),
(19, 'Melilla');

INSERT IGNORE INTO provincia (idProvincia, nombre, idCA) VALUES
(1, 'Araba', 16),
(2, 'Albacete', 8),
(3, 'Alacant', 10),
(4, 'Almería', 1),
(5, 'Ávila', 7),
(6, 'Badajoz', 11),
(7, 'Illes Balears', 4),
(8, 'Barcelona', 9),
(9, 'Burgos', 7),
(10, 'Cáceres', 11),
(11, 'Cádiz', 1),
(12, 'Castelló', 10),
(13, 'Ciudad Real', 8),
(14, 'Córdoba', 1),
(15, 'A Coruña', 12),
(16, 'Cuenca', 8),
(17, 'Girona', 9),
(18, 'Granada', 1),
(19, 'Guadalajara', 8),
(20, 'Gipuzcoa', 16),
(21, 'Huelva', 1),
(22, 'Huesca', 2),
(23, 'Jaén', 1),
(24, 'León', 7),
(25, 'Lleida', 9),
(26, 'La Rioja', 17),
(27, 'Lugo', 12),
(28, 'Madrid', 13),
(29, 'Málaga', 1),
(30, 'Murcia', 14),
(31, 'Navarra', 15),
(32, 'Ourense', 12),
(33, 'Asturias', 3),
(34, 'Palencia', 7),
(35, 'Las Palmas', 5),
(36, 'Pontevedra', 12),
(37, 'Salamanca', 7),
(38, 'Santa Cruz de Tenerife', 5),
(39, 'Cantabria', 6),
(40, 'Segovia', 7),
(41, 'Sevilla', 1),
(42, 'Soria', 7),
(43, 'Tarragona', 9),
(44, 'Teruel', 2),
(45, 'Toledo', 8),
(46, 'València', 10),
(47, 'Valladolid', 7),
(48, 'Bizkaia', 16),
(49, 'Zamora', 7),
(50, 'Zaragoza', 2),
(51, 'Ceuta', 18),
(52, 'Melilla', 19);

INSERT IGNORE INTO direccion (id, calle, numero, poblacion, idProvincia) VALUES
(1, 'Calle Río Miño', 23, 'Redondela', 36),
(2, 'Avenida de Galicia', 10, 'Vigo', 36),
(3, 'Avenida de Lugo', 10, 'Santiago de Compostela', 15),
(4, 'Avenida de Gran Vía', 10, 'Madrid', 28);

INSERT IGNORE INTO modulo (idModulo, nombre) VALUES
(1, 'Sistemas Operativos en Red'),
(2, 'Entornos de desarrollo'),
(3, 'Sistemas Informáticos'),
(4, 'Sistemas gestores de bases de datos'),
(5, 'Programación'),
(6, 'Lenguaje de marcas');

INSERT IGNORE INTO profesormodulo (idProfesor, idModulo) VALUES
(11, 1),
(11, 2),
(12, 3),
(13, 4),
(13, 5),
(14, 6);

-- 9) Populate contactInfo if empty using window function for row numbers (MySQL 8+)
INSERT INTO contactInfo (profesorId, email, tlf_movil)
SELECT Id,
       CONCAT('profesor', 100 + ROW_NUMBER() OVER (ORDER BY Id), '@edu.gal'),
       CONCAT('+34 600 123 ', 100 + ROW_NUMBER() OVER (ORDER BY Id))
FROM profesor
WHERE NOT EXISTS (SELECT 1 FROM contactInfo);

-- End of combined script