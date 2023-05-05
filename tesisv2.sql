CREATE DATABASE tesisv1;

USE tesisv1;

CREATE TABLE TiposRegistros(
	`idTipoRegistro` int not null auto_increment,
    `descripcion` varchar(20),
    PRIMARY KEY (`idTipoRegistro`)
)ENGINE=INNODB;

# CREACION Y MODIFICACION TABLA ESTADOS
CREATE TABLE Estados(
	`idEstado` int not null auto_increment,
    `descripcion` varchar(30),
    `idTipoRegistro` int not null,
    PRIMARY KEY (`idEstado`)
)ENGINE=INNODB;
ALTER TABLE Estados 
	ADD CONSTRAINT `estados_tiposregistros_fk` 
	FOREIGN KEY (`idTipoRegistro`) 
	REFERENCES `TiposRegistros` (idTipoRegistro)
    ON DELETE CASCADE ON UPDATE CASCADE;

# CREACION Y MODIFICACION TABLA PROVINCIAS
CREATE TABLE Provincias(
	`idProvincia` int not null auto_increment,
    `nombre` varchar(30),
    `idTipoRegistro` int not null,
    PRIMARY KEY (`idProvincia`)
)ENGINE=INNODB;
ALTER TABLE Provincias
	ADD CONSTRAINT `provincias_tiposregistros_fk` FOREIGN KEY (`idTipoRegistro`) REFERENCES `TiposRegistros` (idTipoRegistro) ON DELETE CASCADE ON UPDATE CASCADE;

# CREACION Y MODIFICACION TABLA LOCALIDADES
CREATE TABLE Localidades(
	`idLocalidad` int not null auto_increment,
    `nombre` varchar(30), 
    `idProvincia` int not null,
    `idTipoRegistro` int not null,
    PRIMARY KEY (`idLocalidad`)
)ENGINE=INNODB;
ALTER TABLE Localidades
	ADD CONSTRAINT `localidades_provincias_fk` FOREIGN KEY (`idProvincia`) REFERENCES `Provincias` (idProvincia) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `localidades_tiposregistros_fk` FOREIGN KEY (`idTipoRegistro`) REFERENCES `TiposRegistros` (idTipoRegistro) ON DELETE CASCADE ON UPDATE CASCADE;
    
#CREACION Y MODIFICACION TABLA TRANSPORTES
CREATE TABLE Transportes(
	`idTransporte` int not null auto_increment,
    `patente` varchar(7),
    `marca` varchar(30),
    `modelo` tinyint,
    `nombre` varchar(30),
    `capacidad` int,
    `idEstado` int not null,
	`idTipoRegistro` int not null,
    PRIMARY KEY (`idTransporte`)
)ENGINE=INNODB;
ALTER TABLE Transportes
	ADD CONSTRAINT `transportes_estados_fk` FOREIGN KEY (`idEstado`) REFERENCES `Estados` (idEstado) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `transportes_tiposregistros` FOREIGN KEY (`idTipoRegistro`) REFERENCES `TiposRegistros` (idTipoRegistro) ON DELETE CASCADE ON UPDATE CASCADE;
    
#CREACION Y MODIFICACION TABLA CLIENTES
CREATE TABLE Clientes(
	`idCliente` int not null auto_increment,
    `dniCliente` int not null,
    `apellidos` varchar(30),
    `nombres` varchar(30),
    `fechaNac` date,
    `telefono` varchar(10),
    `domicilio` varchar(40),
    `correo` varchar(30),
    `clave` varchar(250),
    `idEstado` int not null,
    `idLocalidad` int not null,
    `idTipoRegistro` int not null,
    PRIMARY KEY (`idCliente`)
)ENGINE=INNODB;
ALTER TABLE Clientes
	ADD CONSTRAINT `clientes_estados_fk` FOREIGN KEY (`idEstado`) REFERENCES `Estados` (idEstado) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `clientes_localidades_fk` FOREIGN KEY (`idLocalidad`) REFERENCES `Localidades` (idLocalidad) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `clientes_tiposregistros_fk` FOREIGN KEY (`idTipoRegistro`) REFERENCES `TiposRegistros` (idTipoRegistro) ON DELETE CASCADE;

# CREACION Y MODIFICACION TABLA SOLICITUDES
CREATE TABLE Solicitudes(
	`idSolicitud` int not null,
    `idCliente` int not null,
    `coordDesde` varchar(50),
    `coordHasta` varchar(50),
    `fechaSolicitud` date,
    `fechaTrabajo` date,
    `pagoFaltante` decimal(6,2),
    `idEstado` int not null,
    `objetosATransportar` varchar(250),
    `detalles` varchar(250),
    `idLocalidadDesde` int not null,
    `idLocalidadHasta` int not null,
    `idTipoRegistro` int not null,
    PRIMARY KEY (`idSolicitud`)
)ENGINE=INNODB;
ALTER TABLE Solicitudes
	ADD CONSTRAINT `solicitudes_clientes_fk` FOREIGN KEY (`idCliente`) REFERENCES `Clientes` (idCliente) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `solicitudes_estados_fk` FOREIGN KEY (`idEstado`) REFERENCES `Estados` (idEstado) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `solicitudes_desde_fk` FOREIGN KEY (`idLocalidadDesde`) REFERENCES `Localidades` (idLocalidad) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `solicitudes_hasta_fk` FOREIGN KEY (`idLocalidadHasta`) REFERENCES `Localidades` (idLocalidad) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `solicitudes_tiposregistros_fk` FOREIGN KEY (`idTipoRegistro`) REFERENCES `TiposRegistros` (idTipoRegistro) ON DELETE CASCADE ON UPDATE CASCADE;
    
# CREACION Y MODIFICACION TABLA EMPLEADOS
CREATE TABLE Empleados(
	`idEmpleado` int not null,
    `dniEmpleado` int not null,
    `apellidos` varchar(30),
    `nombres` varchar(30),
    `fechaNac` date,
    `porcComision` int,
    `correo` varchar(30),
    `clave` varchar(250),
    `idEstado` int not null,
    `idTipoRegistro` int not null,
    PRIMARY KEY (`idEmpleado`)
)ENGINE=INNODB;
ALTER TABLE Empleados
	ADD CONSTRAINT `empleados_estados_fk` FOREIGN KEY (`idEstado`) REFERENCES `Estados` (idEstado) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `empleados_tiposregistros_fk` FOREIGN KEY (`idTipoRegistro`) REFERENCES `TiposRegistros` (idTipoRegistro) ON DELETE CASCADE ON UPDATE CASCADE;
    
# CREACION Y MODIFICACION SOLICITUDESEMPLEADOS
CREATE TABLE SolicitudesEmpleados(
	`idSE` int not null,
    `idSolicitud` int not null,
    `idEmpleado` int not null,
    PRIMARY KEY (`idSE`)
)ENGINE=INNODB;
ALTER TABLE SolicitudesEmpleados
	ADD CONSTRAINT `se_solicitudes_fk` FOREIGN KEY (`idSolicitud`) REFERENCES `Solicitudes` (idSolicitud) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `se_empleados_fk` FOREIGN KEY (`idEmpleado`) REFERENCES `Empleados` (idEmpleado) ON DELETE CASCADE ON UPDATE CASCADE;
    
# CREACION Y MODIFICACION SOLICITUDESTRANSPORTES
CREATE TABLE SolicitudesTransportes(
	`idST` int not null,
    `idSolicitud` int not null,
    `idTransporte` int not null,
    PRIMARY KEY (`idST`)
)ENGINE=INNODB;
ALTER TABLE SolicitudesTransportes
	ADD CONSTRAINT `st_solicitudes_fk` FOREIGN KEY (`idSolicitud`) REFERENCES `Solicitudes` (idSolicitud) ON DELETE CASCADE ON UPDATE CASCADE,
    ADD CONSTRAINT `st_transportes_fk` FOREIGN KEY (`idTransporte`) REFERENCES `Transportes` (idTransporte) ON DELETE CASCADE ON UPDATE CASCADE;
    
SELECT * FROM Solicitudes;
ALTER TABLE solicitudes DROP COLUMN objetosATransportar;
ALTER TABLE solicitudes DROP COLUMN detalles;