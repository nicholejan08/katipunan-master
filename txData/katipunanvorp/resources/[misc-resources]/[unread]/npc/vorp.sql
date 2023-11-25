-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               10.4.13-MariaDB - mariadb.org binary distribution
-- Server OS:                    Win64
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for vorp
CREATE DATABASE IF NOT EXISTS `vorp` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `vorp`;

-- Dumping structure for table vorp.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `group` varchar(10) COLLATE utf8mb4_bin DEFAULT 'user',
  `money` double(11,2) DEFAULT 0.00,
  `gold` double(11,2) DEFAULT 0.00,
  `rol` double(11,2) NOT NULL DEFAULT 0.00,
  `xp` int(11) DEFAULT 0,
  `inventory` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `job` varchar(50) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `status` varchar(140) COLLATE utf8mb4_bin DEFAULT '{}',
  `firstname` varchar(50) COLLATE utf8mb4_bin DEFAULT ' ',
  `lastname` varchar(50) COLLATE utf8mb4_bin DEFAULT ' ',
  `skinPlayer` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `compPlayer` longtext COLLATE utf8mb4_bin DEFAULT NULL,
  `jobgrade` int(11) DEFAULT 0,
  `coords` varchar(75) COLLATE utf8mb4_bin DEFAULT '{}',
  `isdead` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin ROW_FORMAT=DYNAMIC;

-- Data exporting was unselected.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
