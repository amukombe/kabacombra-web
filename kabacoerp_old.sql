-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: chc_db
-- ------------------------------------------------------
-- Server version	8.0.41-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `addresses`
--

DROP TABLE IF EXISTS `addresses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `addresses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `city_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_addresses_on_city_id` (`city_id`),
  CONSTRAINT `fk_rails_ab048f757c` FOREIGN KEY (`city_id`) REFERENCES `cities` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `addresses`
--

LOCK TABLES `addresses` WRITE;
/*!40000 ALTER TABLE `addresses` DISABLE KEYS */;
INSERT INTO `addresses` VALUES (1,'Bajjo',1,'2025-01-06 15:32:31.835629','2025-01-06 15:32:31.835629'),(2,'Nyenje',1,'2025-01-06 16:29:57.837642','2025-01-06 16:29:57.837642'),(3,'Lower Kauga',1,'2025-02-06 13:35:52.938015','2025-02-06 13:35:52.938015'),(4,'Upper Kauga',1,'2025-02-06 13:36:09.872945','2025-02-06 13:36:09.872945'),(5,'Batvalley PS',4,'2025-02-07 10:06:57.359960','2025-02-07 10:06:57.359960');
/*!40000 ALTER TABLE `addresses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ar_internal_metadata`
--

DROP TABLE IF EXISTS `ar_internal_metadata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ar_internal_metadata` (
  `key` varchar(255) NOT NULL,
  `value` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ar_internal_metadata`
--

LOCK TABLES `ar_internal_metadata` WRITE;
/*!40000 ALTER TABLE `ar_internal_metadata` DISABLE KEYS */;
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2025-01-04 03:20:31.043395','2025-01-04 03:20:31.043399');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cell_attendances`
--

DROP TABLE IF EXISTS `cell_attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cell_attendances` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `cell_id` bigint NOT NULL,
  `souls_attended` int DEFAULT NULL,
  `new_members` int DEFAULT NULL,
  `new_converts` int DEFAULT NULL,
  `cells_birthed` int DEFAULT NULL,
  `amount_given` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `attendance_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cell_attendances_on_cell_id` (`cell_id`),
  CONSTRAINT `fk_rails_a8995dbbb6` FOREIGN KEY (`cell_id`) REFERENCES `cells` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cell_attendances`
--

LOCK TABLES `cell_attendances` WRITE;
/*!40000 ALTER TABLE `cell_attendances` DISABLE KEYS */;
INSERT INTO `cell_attendances` VALUES (3,2,7,1,1,0,35000,'2025-01-09 09:32:57.066677','2025-01-09 09:32:57.066677','2025-01-09'),(4,1,10,2,2,1,50000,'2025-01-09 11:31:27.915982','2025-01-09 11:31:27.915982','2025-01-09'),(5,1,6,2,3,0,52000,'2025-02-02 17:07:57.859963','2025-02-02 17:07:57.859963','2025-02-02'),(6,3,6,2,1,0,75000,'2025-02-06 13:43:48.730337','2025-02-06 13:43:48.730337','2025-02-06');
/*!40000 ALTER TABLE `cell_attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cell_days`
--

DROP TABLE IF EXISTS `cell_days`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cell_days` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `cell_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `topic` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cell_days`
--

LOCK TABLES `cell_days` WRITE;
/*!40000 ALTER TABLE `cell_days` DISABLE KEYS */;
INSERT INTO `cell_days` VALUES (1,'2024-01-06','2025-01-06',NULL,'2025-01-06 16:18:46.460653','2025-01-06 16:18:46.460653','God\'s Beloved','Talk about the love of God');
/*!40000 ALTER TABLE `cell_days` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cell_members`
--

DROP TABLE IF EXISTS `cell_members`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cell_members` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fullname` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `address_id` bigint NOT NULL,
  `occupation_id` bigint NOT NULL,
  `cell_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cell_members_on_address_id` (`address_id`),
  KEY `index_cell_members_on_occupation_id` (`occupation_id`),
  KEY `index_cell_members_on_cell_id` (`cell_id`),
  CONSTRAINT `fk_rails_5b66e3eb2e` FOREIGN KEY (`cell_id`) REFERENCES `cells` (`id`),
  CONSTRAINT `fk_rails_87a1635c8d` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`),
  CONSTRAINT `fk_rails_fd42152353` FOREIGN KEY (`occupation_id`) REFERENCES `occupations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cell_members`
--

LOCK TABLES `cell_members` WRITE;
/*!40000 ALTER TABLE `cell_members` DISABLE KEYS */;
INSERT INTO `cell_members` VALUES (1,'Mukombe David','0706671888','amukombe56@gmail.com',1,1,1,'2025-01-08 02:05:01.157203','2025-01-08 02:05:01.157203'),(2,'Etty','12345678','ettyi00@gmail.com',2,1,2,'2025-02-05 12:33:06.762936','2025-02-05 12:33:06.762936'),(3,'Timothy','123456789','timothy@test.com',3,6,3,'2025-02-06 13:41:38.813127','2025-02-06 13:41:38.813127');
/*!40000 ALTER TABLE `cell_members` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cells`
--

DROP TABLE IF EXISTS `cells`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cells` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `cell_host` varchar(255) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `church_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cells_on_address_id` (`address_id`),
  KEY `index_cells_on_user_id` (`user_id`),
  KEY `index_cells_on_church_id` (`church_id`),
  CONSTRAINT `fk_rails_11c631f861` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`),
  CONSTRAINT `fk_rails_9ca01fcd02` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_f97c8b07da` FOREIGN KEY (`church_id`) REFERENCES `churches` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cells`
--

LOCK TABLES `cells` WRITE;
/*!40000 ALTER TABLE `cells` DISABLE KEYS */;
INSERT INTO `cells` VALUES (1,'Bajjo 2',1,'2025-01-06 16:03:41.028293','2025-01-06 21:42:50.080286','Mukombe',2,1),(2,'Nyenje One',2,'2025-01-06 16:33:59.025707','2025-02-05 12:30:32.226416','Thomas',8,2),(3,'Lower Kauga Cell 1',3,'2025-02-06 13:40:42.266207','2025-02-07 06:21:00.001284','Dr Hadoto',2,1),(4,'Batvalley Cell',5,'2025-02-07 10:33:53.733019','2025-02-07 10:33:53.733019','Blue Streams',23,3),(5,'Batvalley Cell2',5,'2025-02-07 11:03:31.431362','2025-02-07 11:03:31.431362','Fran',25,3);
/*!40000 ALTER TABLE `cells` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `church_regions`
--

DROP TABLE IF EXISTS `church_regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `church_regions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `regional_pastor` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_church_regions_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_3d635edcff` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `church_regions`
--

LOCK TABLES `church_regions` WRITE;
/*!40000 ALTER TABLE `church_regions` DISABLE KEYS */;
INSERT INTO `church_regions` VALUES (1,'Head Quarter','2025-01-06 19:25:00.075875','2025-02-07 08:38:02.891759',24,7),(2,'Central','2025-01-06 20:22:54.943193','2025-02-05 09:42:10.029516',3,6),(3,'Eastern','2025-01-06 20:23:05.479645','2025-01-06 20:23:05.479645',NULL,NULL),(4,'Western','2025-01-06 20:23:14.849238','2025-01-06 20:23:14.849238',NULL,NULL),(5,'Bunyoro','2025-01-06 20:23:23.942217','2025-01-06 20:23:23.942217',NULL,NULL),(6,'Northern','2025-01-06 20:23:38.620932','2025-01-06 20:23:38.620932',NULL,NULL),(7,'Diaspora','2025-01-06 20:23:46.567795','2025-01-06 20:23:46.567795',NULL,NULL);
/*!40000 ALTER TABLE `church_regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `churches`
--

DROP TABLE IF EXISTS `churches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `churches` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `district_id` bigint NOT NULL,
  `user_id` bigint DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `church_region_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_churches_on_district_id` (`district_id`),
  KEY `index_churches_on_user_id` (`user_id`),
  KEY `index_churches_on_church_region_id` (`church_region_id`),
  CONSTRAINT `fk_rails_3ee2d59188` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`),
  CONSTRAINT `fk_rails_71cf97d278` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_e850183bd6` FOREIGN KEY (`church_region_id`) REFERENCES `church_regions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `churches`
--

LOCK TABLES `churches` WRITE;
/*!40000 ALTER TABLE `churches` DISABLE KEYS */;
INSERT INTO `churches` VALUES (1,'Christ\'s Heart Mukono','chcmukono@christsheart.org','12345','Lower Kauga',2,NULL,'2025-01-06 21:35:40.212005','2025-01-06 21:35:40.212005',1),(2,'CHC Lugazi','lugazi@christsheart.org','','',2,4,'2025-02-03 10:57:57.226774','2025-02-03 10:57:57.226774',1),(3,'Kampala','','','',1,6,'2025-02-07 09:13:32.183567','2025-02-07 09:13:32.183567',2);
/*!40000 ALTER TABLE `churches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cities`
--

DROP TABLE IF EXISTS `cities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cities` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `district_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_cities_on_district_id` (`district_id`),
  CONSTRAINT `fk_rails_25e397b588` FOREIGN KEY (`district_id`) REFERENCES `districts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cities`
--

LOCK TABLES `cities` WRITE;
/*!40000 ALTER TABLE `cities` DISABLE KEYS */;
INSERT INTO `cities` VALUES (1,'Sseta',2,'2025-01-06 15:20:55.003721','2025-01-06 15:20:55.003721'),(2,'Kalerwe',1,'2025-01-06 16:28:39.743543','2025-01-06 16:28:39.743543'),(3,'Mukono',2,'2025-02-06 13:35:36.456098','2025-02-06 13:35:36.456098'),(4,' Batvalley',1,'2025-02-07 08:35:52.521765','2025-02-07 08:35:52.521765');
/*!40000 ALTER TABLE `cities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `clusters`
--

DROP TABLE IF EXISTS `clusters`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `clusters` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `location_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_clusters_on_location_id` (`location_id`),
  CONSTRAINT `fk_rails_47a0ef3c96` FOREIGN KEY (`location_id`) REFERENCES `locations` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `clusters`
--

LOCK TABLES `clusters` WRITE;
/*!40000 ALTER TABLE `clusters` DISABLE KEYS */;
/*!40000 ALTER TABLE `clusters` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `communities`
--

DROP TABLE IF EXISTS `communities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `communities` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `cluster_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_communities_on_cluster_id` (`cluster_id`),
  CONSTRAINT `fk_rails_f03aadc4f2` FOREIGN KEY (`cluster_id`) REFERENCES `clusters` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `communities`
--

LOCK TABLES `communities` WRITE;
/*!40000 ALTER TABLE `communities` DISABLE KEYS */;
/*!40000 ALTER TABLE `communities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `department_modules`
--

DROP TABLE IF EXISTS `department_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `department_modules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `module_url` varchar(255) DEFAULT NULL,
  `department_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_department_modules_on_department_id` (`department_id`),
  CONSTRAINT `fk_rails_72ccba4252` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `department_modules`
--

LOCK TABLES `department_modules` WRITE;
/*!40000 ALTER TABLE `department_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `department_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `departments`
--

DROP TABLE IF EXISTS `departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `departments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `icon` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `districts`
--

DROP TABLE IF EXISTS `districts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `districts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `districts`
--

LOCK TABLES `districts` WRITE;
/*!40000 ALTER TABLE `districts` DISABLE KEYS */;
INSERT INTO `districts` VALUES (1,'Kampala','2025-01-06 14:14:53.371367','2025-01-06 14:14:53.371367'),(2,'Mukono','2025-01-06 15:20:26.560512','2025-01-06 15:20:26.560512');
/*!40000 ALTER TABLE `districts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_departments`
--

DROP TABLE IF EXISTS `employee_departments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_departments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NOT NULL,
  `department_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_employee_departments_on_employee_id` (`employee_id`),
  KEY `index_employee_departments_on_department_id` (`department_id`),
  CONSTRAINT `fk_rails_79ab551483` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`),
  CONSTRAINT `fk_rails_995ba61e5b` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_departments`
--

LOCK TABLES `employee_departments` WRITE;
/*!40000 ALTER TABLE `employee_departments` DISABLE KEYS */;
/*!40000 ALTER TABLE `employee_departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employees`
--

DROP TABLE IF EXISTS `employees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employees` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) DEFAULT NULL,
  `middlename` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `nssf` varchar(255) DEFAULT NULL,
  `tin` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `locations`
--

DROP TABLE IF EXISTS `locations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `locations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `region_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_locations_on_region_id` (`region_id`),
  CONSTRAINT `fk_rails_356e037a05` FOREIGN KEY (`region_id`) REFERENCES `regions` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `locations`
--

LOCK TABLES `locations` WRITE;
/*!40000 ALTER TABLE `locations` DISABLE KEYS */;
/*!40000 ALTER TABLE `locations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `occupations`
--

DROP TABLE IF EXISTS `occupations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `occupations` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `occupations`
--

LOCK TABLES `occupations` WRITE;
/*!40000 ALTER TABLE `occupations` DISABLE KEYS */;
INSERT INTO `occupations` VALUES (1,'Software Engineer','2025-01-04 21:34:52.136182','2025-01-04 21:34:52.136182'),(2,'Doctor','2025-01-04 21:35:09.360788','2025-01-04 21:35:09.360788'),(3,'Student','2025-01-04 21:35:23.460455','2025-01-04 21:35:23.460455'),(4,'Teacher','2025-01-04 21:35:32.860755','2025-01-04 21:35:32.860755'),(5,'Lawyer','2025-01-04 21:35:41.981539','2025-01-04 21:35:41.981539'),(6,'Banker','2025-01-04 21:35:49.640749','2025-01-04 21:35:49.640749');
/*!40000 ALTER TABLE `occupations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `region_churches`
--

DROP TABLE IF EXISTS `region_churches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `region_churches` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `church_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `church_region_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_region_churches_on_church_id` (`church_id`),
  KEY `index_region_churches_on_church_region_id` (`church_region_id`),
  CONSTRAINT `fk_rails_28801184e1` FOREIGN KEY (`church_id`) REFERENCES `churches` (`id`),
  CONSTRAINT `fk_rails_dfa7e05a46` FOREIGN KEY (`church_region_id`) REFERENCES `church_regions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `region_churches`
--

LOCK TABLES `region_churches` WRITE;
/*!40000 ALTER TABLE `region_churches` DISABLE KEYS */;
INSERT INTO `region_churches` VALUES (3,1,'2025-01-10 03:25:47.295643','2025-01-10 03:25:47.295643',1);
/*!40000 ALTER TABLE `region_churches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `regions`
--

DROP TABLE IF EXISTS `regions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `regions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `regions`
--

LOCK TABLES `regions` WRITE;
/*!40000 ALTER TABLE `regions` DISABLE KEYS */;
/*!40000 ALTER TABLE `regions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schema_migrations`
--

DROP TABLE IF EXISTS `schema_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schema_migrations` (
  `version` varchar(255) NOT NULL,
  PRIMARY KEY (`version`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schema_migrations`
--

LOCK TABLES `schema_migrations` WRITE;
/*!40000 ALTER TABLE `schema_migrations` DISABLE KEYS */;
INSERT INTO `schema_migrations` VALUES ('20241112061814'),('20241113014554'),('20241113022003'),('20241113051227'),('20241114125723'),('20241122062843'),('20241123214759'),('20241124171857'),('20241124190555'),('20241125060039'),('20241125120434'),('20241127074506'),('20250104194918'),('20250104194954'),('20250104204955'),('20250104205823'),('20250104210248'),('20250104210311'),('20250104210444'),('20250104210629'),('20250104212110'),('20250104212200'),('20250104212233'),('20250104212311'),('20250104212505'),('20250106154509'),('20250106154929'),('20250106155555'),('20250106160929'),('20250106161046'),('20250106170455'),('20250106170611'),('20250106170647'),('20250106205908'),('20250106211237'),('20250106212733'),('20250106214013'),('20250108021423'),('20250108021656'),('20250109124059'),('20250109125619'),('20250205091334');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `territories`
--

DROP TABLE IF EXISTS `territories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `territories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `telephone` varchar(255) DEFAULT NULL,
  `department_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_territories_on_department_id` (`department_id`),
  CONSTRAINT `fk_rails_4cbbbb1ae0` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `territories`
--

LOCK TABLES `territories` WRITE;
/*!40000 ALTER TABLE `territories` DISABLE KEYS */;
/*!40000 ALTER TABLE `territories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL DEFAULT '',
  `encrypted_password` varchar(255) NOT NULL DEFAULT '',
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_sent_at` datetime(6) DEFAULT NULL,
  `remember_created_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `role` int DEFAULT NULL,
  `is_super` tinyint(1) DEFAULT NULL,
  `fullname` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'dbmukombe@gmail.com','$2a$12$vWog5mCdrMmxs76efh1R0ergRTQCXcd1ecABEop7Qxt2mRACDf1ii',NULL,NULL,NULL,'2025-01-04 21:48:10.675086','2025-01-06 15:57:01.053899',7,1,'David'),(2,'nanyanzicaroline10@gmail.com','$2a$12$oT4FT1V0zf8xwXLDmKax/egObHqLL9kR/IIvh2yh5rviOvgOcXzrS',NULL,NULL,NULL,'2025-01-06 16:03:08.119409','2025-01-06 16:03:08.119409',0,NULL,'Nanyanzi Karol'),(3,'wasron@gmail.com','$2a$12$BBciOLTDaGR2o7u5rKGvHOGnR2nNlpfCmBKgMGfa.7Z8YndED9g8.',NULL,NULL,NULL,'2025-01-06 16:33:33.591522','2025-02-05 09:29:23.426189',3,NULL,'Pr Waswa'),(4,'amukombe56@gmail.com','$2a$12$k4T6Fz8wIdsDWkysSQZ0I.O3JWx/TV2iQQoBtf4kGhkyN0BkO5/vC',NULL,NULL,NULL,'2025-01-06 20:46:17.719534','2025-01-06 20:46:17.719534',4,NULL,'David Beckhar Mukombe'),(6,'iwaiswa@christsheart.org','$2a$12$PE6NxLdeGGJ8erdrAm6fMuGtumrn6r4OYA.7ZHhf4QHoVxzLzMGey',NULL,NULL,NULL,'2025-01-10 03:28:28.967265','2025-02-05 10:10:35.552836',5,NULL,'Pr Isaac Waiswa'),(7,'rmabirizi@gmail.com','$2a$12$YUYsxOH7PcpU8q3OZTjmbu4Zc4tkMfiI6L6LWxTORnjz4uew7YLOe',NULL,NULL,NULL,'2025-02-05 09:35:00.979371','2025-02-05 09:51:39.890326',5,1,'Pr Robert Mabirizi'),(8,'ettyisaac@christsheart.org','$2a$12$BDWdZ81nKtu7iX8YI5j04ufgQPNzQULcOQw1Mx8jFIzBVTq8GQjsG',NULL,NULL,NULL,'2025-02-05 12:30:16.324394','2025-02-05 12:30:16.324394',0,NULL,'Etyang Isaac'),(23,'blussoffice@gmail.com','$2a$12$O9D9X/f1cJENHacdMcaJx.3x00G8RIW1tD2J5itNMQNSTqzF7crjW',NULL,NULL,NULL,'2025-02-07 08:23:49.638148','2025-02-07 08:23:49.638148',0,NULL,'Bluss'),(24,'support@christsheart.org','$2a$12$broA2UowSVZb3xzfpA87Au56zGfjO0glBHMwwW2b29z4onvYnV/Mi',NULL,NULL,NULL,'2025-02-07 08:37:42.404580','2025-02-07 08:37:42.404580',3,NULL,'Stephen Obeli'),(25,'chckampala@gmail.com','$2a$12$ERDnnnBWgsUh5aqYpqM7p.HKJhcVup9dL8tFuIgE6BTuElwS2OUgO',NULL,NULL,NULL,'2025-02-07 11:02:54.950982','2025-02-07 11:02:54.950982',0,NULL,'Franch'),(26,'info@bluestreamssolution.com','$2a$12$YTV2yX1HypndSm.wLcIzduLuIIFdSZGMgWzhFsEOa7WZeuHkKxGxm',NULL,NULL,NULL,'2025-02-08 08:51:55.898124','2025-02-08 08:51:55.898124',4,NULL,'Mabirizi');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-02-12 18:37:14
