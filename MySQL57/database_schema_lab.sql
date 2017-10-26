-- Create little schema to benchmark test

-- Reglas de mi schema:

-- 0- The branch_offices table is the father.
-- 1- The sections owns to a sucursal.
-- 2- The employees belong to a branch.
-- 3- The employees must belong to a section at least.
-- 4- The employees musn't be deleted, they have a status flag.
-- 5- The pieces belong to a branch.
-- 6- The pieces belong to a sections

-- 2- Las piezas pertenecen a un empleado, o fue procesado por tal.
-- 3- Las piezas suman o restan al stock pero no se borran, tienen un flag de estado.
-- 8- El inventario pertenece a una seccion.

-- Table sucursals
CREATE TABLE `branch_offices` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT, 
	`name` VARCHAR(32) NOT NULL,
	`manager_id` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`),
	INDEX brchName_idx (`name`)
) ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table sections
CREATE TABLE `sections` (
	`id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT, 
	`name` VARCHAR(32) NOT NULL,
	`branch_id` INT(11) UNSIGNED NOT NULL,
	`supervisor_id` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`),
	INDEX brchId_idx (`branch_id`),
	FOREIGN KEY (`branch_id`) REFERENCES `branch_offices`(`id`) ON DELETE RESTRICT
) ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table employees
CREATE TABLE employees (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(32) NOT NULL,
	`surname` VARCHAR(16) NOT NULL,
	`contract_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`section_id` INT UNSIGNED NOT NULL,
	`branch_id` INT UNSIGNED NOT NULL,
	`supervisor` TINYINT(1) UNSIGNED DEFAULT 0,
	`manager` TINYINT(1) UNSIGNED DEFAULT 0,
	`is_active` TINYINT(1) UNSIGNED DEFAULT 0,
	`decoupling` DATETIME DEFAULT NULL,
	PRIMARY KEY (`id`),
	INDEX brchId_idx (`branch_id`),
	INDEX secId_idx (`section_id`),
	FOREIGN KEY (`branch_id`) REFERENCES `branch_offices`(`id`) ON DELETE RESTRICT,
	FOREIGN KEY (`section_id`) REFERENCES `sections`(`id`) ON DELETE RESTRICT
) ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table inventary pieces
CREATE TABLE inventary (
	`piece_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`stock` INT UNSIGNED DEFAULT 0 NOT NULL, 
	`section_id` INT UNSIGNED NOT NULL,
	`branch_id` INT UNSIGNED NOT NULL,
	`modified` DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
	PRIMARY KEY (`piece_id`),
	FOREIGN KEY (`section_id`) REFERENCES `sections`(`id`) ON DELETE RESTRICT,
	FOREIGN KEY (`branch_id`) REFERENCES `branch_offices`(`id`) ON DELETE RESTRICT
) ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table destinity of pieces
CREATE TABLE destinnations (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(64) NOT NULL,
	`Postal_code` INT UNSIGNED NOT NULL,
	PRIMARY KEY (`id`)
) ENGINE=Innodb DEFAULT CHARSET=utf8;

-- Table pieces
CREATE TABLE pieces (
	`id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`piece_id` INT UNSIGNED NOT NULL,
	`name` VARCHAR(32) NOT NULL,
	`created` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	`modified` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`section_id` INT UNSIGNED NOT NULL,
	`employee_id` INT UNSIGNED NOT NULL,
	`inventary_id` INT NOT NULL,
	`destination_id` INT UNSIGNED NOT NULL, 
	`branch_id` INT UNSIGNED NOT NULL,
	`status` VARCHAR(12) NOT NULL,
	PRIMARY KEY (`id`, `piece_id`),
	FOREIGN KEY (`branch_id`) REFERENCES `branch_offices`(`id`) ON DELETE RESTRICT,
	FOREIGN KEY (`section_id`) REFERENCES `sections`(`id`) ON DELETE RESTRICT,
	FOREIGN KEY (`employee_id`) REFERENCES `employees`(`id`) ON DELETE RESTRICT,
	FOREIGN KEY (`piece_id`) REFERENCES `inventary`(`piece_id`) ON DELETE RESTRICT,
	FOREIGN KEY (`destination_id`) REFERENCES `destinnations`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=Innodb DEFAULT CHARSET=utf8;

-- End

