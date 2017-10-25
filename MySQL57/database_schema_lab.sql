-- Create little schema to benchmark test

-- Reglas de mi schema:

-- 1- Las piezas pertenecen a una seccion.
-- 2- Las piezas pertenecen a un empleado, o fue procesado por tal.
-- 3- Las piezas suman o restan al stock pero no se borran, tienen un flag de estado.
-- 4- Las piezas pertenecen a una sucursal.
-- 5- Los empleados pertenecen a una sucursal.
-- 6- Los empleados no se deben borrar, tienen un flag de estado.
-- 7- Las secciones pertenecen a una sucursal.
-- 8- El inventario pertenece a una seccion.

-- Table pieces
CREATE TABLE pieces (
		`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` VARCHAR(32) NOT NULL,
		`created` DATETIME DEFAULT CURRENT_TIMESTAMP,
		`modified` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		`section_id` INT NOT NULL,
		`employee_id` INT NOT NULL,
		`inventary_id` INT NOT NULL,
		`destination_id` INT NOT NULL, 
		`sucursal_id` INT NOT NULL
)
ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table sections
CREATE TABLE sections (
		`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
		`name` VARCHAR NOT NULL,
		`sucursal_id` INT NOT NULL,
		`supervisor_id` INT NOT NULL
)
ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table sucursals
CREATE TABLE sucursals (
		`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
		`name` VARCHAR NOT NULL,
		`manager_id` INT NOT NULL	
)
ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table employees
CREATE TABLE employees (
		`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`name` VARCHAR NOT NULL,
		`surname` VARCHAR NOT NULL,
		`contract_at` DATETIME, # verificar
		`supervisor_id` INT DEFAULT NULL,
		`section_id` INT NOT NULL,
		`sucursal_id` INT NOT NULL,
		`supervisor` TINYINT(1) DEFAULT NULL,
		`manager` TINYINT(1) DEFAULT NULL
)
ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table inventary pieces
CREATE TABLE inventary (
		`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
		`pieces_id` INT NOT NULL,
		`stock` INT, ## Resta agregar el calculo para tener el stock
		`in` INT NOT NULL,
		`out` INT NOT NULL,
		`section_id` INT NOT NULL,
		`sucursal_id` INT NOT NULL,
		`modified` DATETIME ## Verificar el defaiult NOW()
)
ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table destinity of pieces
CREATE TABLE destinnation (
	`id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	`name` VARCHAR NOT NULL,
	`Postal_code` INT NOT NULL,
)
ENGINE=Innodb DEFAULT CHARSET=utf8;


