CREATE TABLE `synced_objects_scenes` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`name` varchar(50) NOT NULL,
	PRIMARY KEY (`id`) USING BTREE
)
COLLATE='utf8mb4_general_ci' ENGINE=InnoDB AUTO_INCREMENT=1;

CREATE TABLE `synced_objects` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`model` varchar(50) NOT NULL,
	`x` varchar(50) NOT NULL,
    `y` varchar(50) NOT NULL,
    `z` varchar(50) NOT NULL,
    `rx` varchar(50) NOT NULL,
    `ry` varchar(50) NOT NULL,
    `rz` varchar(50) NOT NULL,
    `heading` int(11) NOT NULL,
    `sceneid` int(11) NOT NULL,
	PRIMARY KEY (`id`) USING BTREE,
    KEY `FK_objects_scene` (`sceneid`) USING BTREE,
    CONSTRAINT `FK_objects_scene` FOREIGN KEY (`sceneid`) REFERENCES `synced_objects_scenes` (`id`) ON UPDATE CASCADE ON DELETE CASCADE
)
COLLATE='utf8mb4_general_ci' ENGINE=InnoDB AUTO_INCREMENT=1;