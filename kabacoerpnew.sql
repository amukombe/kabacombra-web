-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: kabacoerp
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
INSERT INTO `ar_internal_metadata` VALUES ('environment','development','2024-12-29 18:37:18.552751','2024-12-29 18:37:18.552755');
/*!40000 ALTER TABLE `ar_internal_metadata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank_accounts`
--

DROP TABLE IF EXISTS `bank_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_accounts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `bank_id` bigint NOT NULL,
  `territory_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `account_name` varchar(255) DEFAULT NULL,
  `account_number` varchar(255) DEFAULT NULL,
  `branch_name` varchar(255) DEFAULT NULL,
  `branch_code` varchar(255) DEFAULT NULL,
  `swiftcode` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_bank_accounts_on_bank_id` (`bank_id`),
  KEY `index_bank_accounts_on_territory_id` (`territory_id`),
  KEY `index_bank_accounts_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_39d701cbed` FOREIGN KEY (`bank_id`) REFERENCES `banks` (`id`),
  CONSTRAINT `fk_rails_7c952ab741` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`),
  CONSTRAINT `fk_rails_92daa8a387` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_accounts`
--

LOCK TABLES `bank_accounts` WRITE;
/*!40000 ALTER TABLE `bank_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank_deposits`
--

DROP TABLE IF EXISTS `bank_deposits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_deposits` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `bank_account_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `territory_id` bigint NOT NULL,
  `deposit_date` date DEFAULT NULL,
  `amount` decimal(10,0) DEFAULT NULL,
  `deposit_location` varchar(255) DEFAULT NULL,
  `source_of_income` varchar(255) DEFAULT NULL,
  `deposited_by` varchar(255) DEFAULT NULL,
  `transaction_reference` varchar(255) DEFAULT NULL,
  `additional_info` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_bank_deposits_on_bank_account_id` (`bank_account_id`),
  KEY `index_bank_deposits_on_user_id` (`user_id`),
  KEY `index_bank_deposits_on_territory_id` (`territory_id`),
  CONSTRAINT `fk_rails_46d8d4004b` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_c1b8bf5cd9` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`),
  CONSTRAINT `fk_rails_dd5c174a70` FOREIGN KEY (`bank_account_id`) REFERENCES `bank_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_deposits`
--

LOCK TABLES `bank_deposits` WRITE;
/*!40000 ALTER TABLE `bank_deposits` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_deposits` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `bank_withdraws`
--

DROP TABLE IF EXISTS `bank_withdraws`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bank_withdraws` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `bank_account_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `territory_id` bigint NOT NULL,
  `withdraw_date` date DEFAULT NULL,
  `amount` decimal(10,0) DEFAULT NULL,
  `withdraw_location` varchar(255) DEFAULT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `withdrawn_by` varchar(255) DEFAULT NULL,
  `transaction_reference` varchar(255) DEFAULT NULL,
  `additional_info` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_bank_withdraws_on_bank_account_id` (`bank_account_id`),
  KEY `index_bank_withdraws_on_user_id` (`user_id`),
  KEY `index_bank_withdraws_on_territory_id` (`territory_id`),
  CONSTRAINT `fk_rails_32f384df7e` FOREIGN KEY (`bank_account_id`) REFERENCES `bank_accounts` (`id`),
  CONSTRAINT `fk_rails_5090868f92` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_e4f938f31c` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bank_withdraws`
--

LOCK TABLES `bank_withdraws` WRITE;
/*!40000 ALTER TABLE `bank_withdraws` DISABLE KEYS */;
/*!40000 ALTER TABLE `bank_withdraws` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `banks`
--

DROP TABLE IF EXISTS `banks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `banks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `banks`
--

LOCK TABLES `banks` WRITE;
/*!40000 ALTER TABLE `banks` DISABLE KEYS */;
/*!40000 ALTER TABLE `banks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `beer_dispatches`
--

DROP TABLE IF EXISTS `beer_dispatches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `beer_dispatches` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `fdn_number` varchar(255) DEFAULT NULL,
  `truck_numberplate` varchar(255) DEFAULT NULL,
  `trailer_plate` varchar(255) DEFAULT NULL,
  `second_trailer` varchar(255) DEFAULT NULL,
  `delivery_plant` varchar(255) DEFAULT NULL,
  `shipping_point` varchar(255) DEFAULT NULL,
  `loading_time` datetime(6) DEFAULT NULL,
  `order_id` bigint NOT NULL,
  `dispatch_no` varchar(255) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `territory_id` bigint NOT NULL,
  `driver_name` varchar(255) DEFAULT NULL,
  `driver_mobile` varchar(255) DEFAULT NULL,
  `invoice_no` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_beer_dispatches_on_order_id` (`order_id`),
  KEY `index_beer_dispatches_on_user_id` (`user_id`),
  KEY `index_beer_dispatches_on_territory_id` (`territory_id`),
  CONSTRAINT `fk_rails_1ec96720b2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_43db8cee64` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_rails_e290eae06e` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `beer_dispatches`
--

LOCK TABLES `beer_dispatches` WRITE;
/*!40000 ALTER TABLE `beer_dispatches` DISABLE KEYS */;
/*!40000 ALTER TABLE `beer_dispatches` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `car_makes`
--

DROP TABLE IF EXISTS `car_makes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `car_makes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `car_makes`
--

LOCK TABLES `car_makes` WRITE;
/*!40000 ALTER TABLE `car_makes` DISABLE KEYS */;
/*!40000 ALTER TABLE `car_makes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comments`
--

DROP TABLE IF EXISTS `comments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `status_id` bigint NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `comment_type` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_comments_on_user_id` (`user_id`),
  KEY `index_comments_on_status_id` (`status_id`),
  CONSTRAINT `fk_rails_03de2dc08c` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_3a06992619` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comments`
--

LOCK TABLES `comments` WRITE;
/*!40000 ALTER TABLE `comments` DISABLE KEYS */;
/*!40000 ALTER TABLE `comments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `mobile` varchar(255) DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `territory_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_customers_on_territory_id` (`territory_id`),
  CONSTRAINT `fk_rails_a4c017144a` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customers`
--

LOCK TABLES `customers` WRITE;
/*!40000 ALTER TABLE `customers` DISABLE KEYS */;
/*!40000 ALTER TABLE `customers` ENABLE KEYS */;
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
  `icon` text,
  `app_icon` text,
  `app_url` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `departments`
--

LOCK TABLES `departments` WRITE;
/*!40000 ALTER TABLE `departments` DISABLE KEYS */;
INSERT INTO `departments` VALUES (1,'Cement','2025-02-12 15:01:09.456731','2025-02-12 15:01:09.456731','<svg class=\"flex-shrink-0 w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\" aria-hidden=\"true\"><path clip-rule=\"evenodd\" fill-rule=\"evenodd\" d=\"M6.672 1.911a1 1 0 10-1.932.518l.259.966a1 1 0 001.932-.518l-.26-.966zM2.429 4.74a1 1 0 10-.517 1.932l.966.259a1 1 0 00.517-1.932l-.966-.26zm8.814-.569a1 1 0 00-1.415-1.414l-.707.707a1 1 0 101.415 1.415l.707-.708zm-7.071 7.072l.707-.707A1 1 0 003.465 9.12l-.708.707a1 1 0 001.415 1.415zm3.2-5.171a1 1 0 00-1.3 1.3l4 10a1 1 0 001.823.075l1.38-2.759 3.018 3.02a1 1 0 001.414-1.415l-3.019-3.02 2.76-1.379a1 1 0 00-.076-1.822l-10-4z\"></path></svg>','<svg class=\"mx-auto mb-1 text-gray-500 w-7 h-7 dark:text-gray-400\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\" aria-hidden=\"true\"><path clip-rule=\"evenodd\" fill-rule=\"evenodd\" d=\"M.99 5.24A2.25 2.25 0 013.25 3h13.5A2.25 2.25 0 0119 5.25l.01 9.5A2.25 2.25 0 0116.76 17H3.26A2.267 2.267 0 011 14.74l-.01-9.5zm8.26 9.52v-.625a.75.75 0 00-.75-.75H3.25a.75.75 0 00-.75.75v.615c0 .414.336.75.75.75h5.373a.75.75 0 00.627-.74zm1.5 0a.75.75 0 00.627.74h5.373a.75.75 0 00.75-.75v-.615a.75.75 0 00-.75-.75H11.5a.75.75 0 00-.75.75v.625zm6.75-3.63v-.625a.75.75 0 00-.75-.75H11.5a.75.75 0 00-.75.75v.625c0 .414.336.75.75.75h5.25a.75.75 0 00.75-.75zm-8.25 0v-.625a.75.75 0 00-.75-.75H3.25a.75.75 0 00-.75.75v.625c0 .414.336.75.75.75H8.5a.75.75 0 00.75-.75zM17.5 7.5v-.625a.75.75 0 00-.75-.75H11.5a.75.75 0 00-.75.75V7.5c0 .414.336.75.75.75h5.25a.75.75 0 00.75-.75zm-8.25 0v-.625a.75.75 0 00-.75-.75H3.25a.75.75 0 00-.75.75V7.5c0 .414.336.75.75.75H8.5a.75.75 0 00.75-.75z\"></path></svg>','/cement'),(2,'Total Energies','2025-02-12 15:01:48.141433','2025-02-12 15:01:48.141433','<svg class=\"flex-shrink-0 w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\" aria-hidden=\"true\"><path clip-rule=\"evenodd\" fill-rule=\"evenodd\" d=\"M.99 5.24A2.25 2.25 0 013.25 3h13.5A2.25 2.25 0 0119 5.25l.01 9.5A2.25 2.25 0 0116.76 17H3.26A2.267 2.267 0 011 14.74l-.01-9.5zm8.26 9.52v-.625a.75.75 0 00-.75-.75H3.25a.75.75 0 00-.75.75v.615c0 .414.336.75.75.75h5.373a.75.75 0 00.627-.74zm1.5 0a.75.75 0 00.627.74h5.373a.75.75 0 00.75-.75v-.615a.75.75 0 00-.75-.75H11.5a.75.75 0 00-.75.75v.625zm6.75-3.63v-.625a.75.75 0 00-.75-.75H11.5a.75.75 0 00-.75.75v.625c0 .414.336.75.75.75h5.25a.75.75 0 00.75-.75zm-8.25 0v-.625a.75.75 0 00-.75-.75H3.25a.75.75 0 00-.75.75v.625c0 .414.336.75.75.75H8.5a.75.75 0 00.75-.75zM17.5 7.5v-.625a.75.75 0 00-.75-.75H11.5a.75.75 0 00-.75.75V7.5c0 .414.336.75.75.75h5.25a.75.75 0 00.75-.75zm-8.25 0v-.625a.75.75 0 00-.75-.75H3.25a.75.75 0 00-.75.75V7.5c0 .414.336.75.75.75H8.5a.75.75 0 00.75-.75z\"></path></svg>','<svg class=\"mx-auto mb-1 text-gray-500 w-7 h-7 dark:text-gray-400\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\" aria-hidden=\"true\"><path clip-rule=\"evenodd\" fill-rule=\"evenodd\" d=\"M.99 5.24A2.25 2.25 0 013.25 3h13.5A2.25 2.25 0 0119 5.25l.01 9.5A2.25 2.25 0 0116.76 17H3.26A2.267 2.267 0 011 14.74l-.01-9.5zm8.26 9.52v-.625a.75.75 0 00-.75-.75H3.25a.75.75 0 00-.75.75v.615c0 .414.336.75.75.75h5.373a.75.75 0 00.627-.74zm1.5 0a.75.75 0 00.627.74h5.373a.75.75 0 00.75-.75v-.615a.75.75 0 00-.75-.75H11.5a.75.75 0 00-.75.75v.625zm6.75-3.63v-.625a.75.75 0 00-.75-.75H11.5a.75.75 0 00-.75.75v.625c0 .414.336.75.75.75h5.25a.75.75 0 00.75-.75zm-8.25 0v-.625a.75.75 0 00-.75-.75H3.25a.75.75 0 00-.75.75v.625c0 .414.336.75.75.75H8.5a.75.75 0 00.75-.75zM17.5 7.5v-.625a.75.75 0 00-.75-.75H11.5a.75.75 0 00-.75.75V7.5c0 .414.336.75.75.75h5.25a.75.75 0 00.75-.75zm-8.25 0v-.625a.75.75 0 00-.75-.75H3.25a.75.75 0 00-.75.75V7.5c0 .414.336.75.75.75H8.5a.75.75 0 00.75-.75z\"></path></svg>','/energy'),(3,'Transportation','2025-02-12 15:02:28.745816','2025-02-12 15:02:28.745816','<svg class=\"flex-shrink-0 w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\"><path fill-rule=\"evenodd\" d=\"M6 2a2 2 0 00-2 2v12a2 2 0 002 2h8a2 2 0 002-2V7.414A2 2 0 0015.414 6L12 2.586A2 2 0 0010.586 2H6zm2 10a1 1 0 10-2 0v3a1 1 0 102 0v-3zm2-3a1 1 0 011 1v5a1 1 0 11-2 0v-5a1 1 0 011-1zm4-1a1 1 0 10-2 0v7a1 1 0 102 0V8z\" clip-rule=\"evenodd\"></path></svg>','<svg class=\"mx-auto mb-1 text-gray-500 w-7 h-7 dark:text-gray-400\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\"><path fill-rule=\"evenodd\" d=\"M6 2a2 2 0 00-2 2v12a2 2 0 002 2h8a2 2 0 002-2V7.414A2 2 0 0015.414 6L12 2.586A2 2 0 0010.586 2H6zm2 10a1 1 0 10-2 0v3a1 1 0 102 0v-3zm2-3a1 1 0 011 1v5a1 1 0 11-2 0v-5a1 1 0 011-1zm4-1a1 1 0 10-2 0v7a1 1 0 102 0V8z\" clip-rule=\"evenodd\"></path></svg>','/transport'),(4,'Rentals','2025-02-12 15:03:00.213022','2025-02-12 15:03:00.213022','<svg class=\"flex-shrink-0 w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\"><path fill-rule=\"evenodd\" d=\"M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z\" clip-rule=\"evenodd\"></path></svg>','<svg class=\"mx-auto mb-1 text-gray-500 w-7 h-7 dark:text-gray-400\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\"><path fill-rule=\"evenodd\" d=\"M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z\" clip-rule=\"evenodd\"></path></svg>','/rentals'),(5,'Beer','2025-02-12 15:03:30.604202','2025-02-12 15:03:30.604202','<svg class=\"flex-shrink-0 w-6 h-6 text-gray-500 transition duration-75 group-hover:text-gray-900 dark:text-gray-400 dark:group-hover:text-white\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\" aria-hidden=\"true\"><path d=\"M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z\"></path></svg>','<svg class=\"mx-auto mb-1 text-gray-500 w-7 h-7 dark:text-gray-400\" fill=\"currentColor\" viewBox=\"0 0 20 20\" xmlns=\"http://www.w3.org/2000/svg\" aria-hidden=\"true\"><path d=\"M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z\"></path></svg>','/beers');
/*!40000 ALTER TABLE `departments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `dispatch_items`
--

DROP TABLE IF EXISTS `dispatch_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `dispatch_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `quantity_dispatched` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `beer_dispatch_id` bigint NOT NULL,
  `quantity_ordered` decimal(10,0) DEFAULT NULL,
  `order_item_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_dispatch_items_on_beer_dispatch_id` (`beer_dispatch_id`),
  KEY `index_dispatch_items_on_order_item_id` (`order_item_id`),
  CONSTRAINT `fk_rails_60728f1baa` FOREIGN KEY (`order_item_id`) REFERENCES `order_items` (`id`),
  CONSTRAINT `fk_rails_976e736e57` FOREIGN KEY (`beer_dispatch_id`) REFERENCES `beer_dispatches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `dispatch_items`
--

LOCK TABLES `dispatch_items` WRITE;
/*!40000 ALTER TABLE `dispatch_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `dispatch_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `drivers`
--

DROP TABLE IF EXISTS `drivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drivers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `employee_id` bigint NOT NULL,
  `license_number` varchar(255) DEFAULT NULL,
  `issued_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `license_class` varchar(255) DEFAULT NULL,
  `issued_by` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `is_available` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_drivers_on_employee_id` (`employee_id`),
  CONSTRAINT `fk_rails_c6aceb3180` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `drivers`
--

LOCK TABLES `drivers` WRITE;
/*!40000 ALTER TABLE `drivers` DISABLE KEYS */;
/*!40000 ALTER TABLE `drivers` ENABLE KEYS */;
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
-- Table structure for table `employee_territories`
--

DROP TABLE IF EXISTS `employee_territories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_territories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `territory_id` bigint NOT NULL,
  `employee_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_employee_territories_on_territory_id` (`territory_id`),
  KEY `index_employee_territories_on_employee_id` (`employee_id`),
  CONSTRAINT `fk_rails_9fa8da9524` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`),
  CONSTRAINT `fk_rails_baf79dffbe` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_territories`
--

LOCK TABLES `employee_territories` WRITE;
/*!40000 ALTER TABLE `employee_territories` DISABLE KEYS */;
INSERT INTO `employee_territories` VALUES (1,1,1,'2025-02-12 15:14:38.340838','2025-02-12 15:14:38.340838');
/*!40000 ALTER TABLE `employee_territories` ENABLE KEYS */;
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
  `position_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_employees_on_position_id` (`position_id`),
  CONSTRAINT `fk_rails_8425ebe6a1` FOREIGN KEY (`position_id`) REFERENCES `positions` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employees`
--

LOCK TABLES `employees` WRITE;
/*!40000 ALTER TABLE `employees` DISABLE KEYS */;
INSERT INTO `employees` VALUES (1,'David','','Beckhar','dbmukombe@gmail.com','','2025-02-01','','','','2025-02-12 15:09:14.801922','2025-02-12 15:09:14.801922',1),(2,'Patience','','Atuhaire','atuhairepatience.finance@kabacoug.com','0751919035','2025-02-17','','','','2025-02-17 07:04:21.131968','2025-02-17 07:04:21.131968',3);
/*!40000 ALTER TABLE `employees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empty_types`
--

DROP TABLE IF EXISTS `empty_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empty_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `price` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empty_types`
--

LOCK TABLES `empty_types` WRITE;
/*!40000 ALTER TABLE `empty_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `empty_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expense_categories`
--

DROP TABLE IF EXISTS `expense_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_categories`
--

LOCK TABLES `expense_categories` WRITE;
/*!40000 ALTER TABLE `expense_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `expense_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expense_types`
--

DROP TABLE IF EXISTS `expense_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expense_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `expense_category_id` bigint NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_expense_types_on_expense_category_id` (`expense_category_id`),
  CONSTRAINT `fk_rails_429abeb0d7` FOREIGN KEY (`expense_category_id`) REFERENCES `expense_categories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expense_types`
--

LOCK TABLES `expense_types` WRITE;
/*!40000 ALTER TABLE `expense_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `expense_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `expenses`
--

DROP TABLE IF EXISTS `expenses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `expenses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `expense_type_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `territory_id` bigint NOT NULL,
  `status_id` bigint NOT NULL,
  `expense_title` varchar(255) DEFAULT NULL,
  `received_by` int DEFAULT NULL,
  `authorized_by` int DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `expense_date` date DEFAULT NULL,
  `amount` decimal(10,0) DEFAULT NULL,
  `source_of_income` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_expenses_on_expense_type_id` (`expense_type_id`),
  KEY `index_expenses_on_user_id` (`user_id`),
  KEY `index_expenses_on_territory_id` (`territory_id`),
  KEY `index_expenses_on_status_id` (`status_id`),
  CONSTRAINT `fk_rails_244a1b7a3e` FOREIGN KEY (`expense_type_id`) REFERENCES `expense_types` (`id`),
  CONSTRAINT `fk_rails_740839b9ca` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`),
  CONSTRAINT `fk_rails_a07aaad691` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`),
  CONSTRAINT `fk_rails_c3ee69df61` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `expenses`
--

LOCK TABLES `expenses` WRITE;
/*!40000 ALTER TABLE `expenses` DISABLE KEYS */;
/*!40000 ALTER TABLE `expenses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventories`
--

DROP TABLE IF EXISTS `inventories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `total` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `beer_dispatch_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `delivery_time` datetime(6) DEFAULT NULL,
  `territory_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_inventories_on_beer_dispatch_id` (`beer_dispatch_id`),
  KEY `index_inventories_on_user_id` (`user_id`),
  KEY `index_inventories_on_territory_id` (`territory_id`),
  CONSTRAINT `fk_rails_6642cbdd87` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_722643612c` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`),
  CONSTRAINT `fk_rails_ab055f8fd6` FOREIGN KEY (`beer_dispatch_id`) REFERENCES `beer_dispatches` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventories`
--

LOCK TABLES `inventories` WRITE;
/*!40000 ALTER TABLE `inventories` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_item_stores`
--

DROP TABLE IF EXISTS `inventory_item_stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_item_stores` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `inventory_item_id` bigint NOT NULL,
  `store_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_inventory_item_stores_on_inventory_item_id` (`inventory_item_id`),
  KEY `index_inventory_item_stores_on_store_id` (`store_id`),
  CONSTRAINT `fk_rails_40b418a775` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`),
  CONSTRAINT `fk_rails_fbb7991bf5` FOREIGN KEY (`inventory_item_id`) REFERENCES `inventory_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_item_stores`
--

LOCK TABLES `inventory_item_stores` WRITE;
/*!40000 ALTER TABLE `inventory_item_stores` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_item_stores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory_items`
--

DROP TABLE IF EXISTS `inventory_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `inventory_id` bigint NOT NULL,
  `quantity_ordered` decimal(10,0) DEFAULT NULL,
  `quantity_dispatched` decimal(10,0) DEFAULT NULL,
  `quantity_received` decimal(10,0) DEFAULT NULL,
  `quantity_sold` decimal(10,0) DEFAULT '0',
  `purchase_price` decimal(10,0) DEFAULT NULL,
  `selling_price` decimal(10,0) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '0',
  `is_closed` tinyint(1) DEFAULT '0',
  `is_deleted` tinyint(1) DEFAULT '0',
  `manufacture_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `stock_no` varchar(255) DEFAULT NULL,
  `dispatch_item_id` bigint NOT NULL,
  `breakages` decimal(10,0) DEFAULT NULL,
  `missing_bottles` decimal(10,0) DEFAULT NULL,
  `complaints` decimal(10,0) DEFAULT NULL,
  `remaining_quantity` decimal(10,0) DEFAULT '0',
  `returns` decimal(10,0) DEFAULT '0',
  `transfers` decimal(10,0) DEFAULT '0',
  `nbl_return` decimal(10,0) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_inventory_items_on_inventory_id` (`inventory_id`),
  KEY `index_inventory_items_on_dispatch_item_id` (`dispatch_item_id`),
  CONSTRAINT `fk_rails_3f98195810` FOREIGN KEY (`dispatch_item_id`) REFERENCES `dispatch_items` (`id`),
  CONSTRAINT `fk_rails_a7dc109dcc` FOREIGN KEY (`inventory_id`) REFERENCES `inventories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory_items`
--

LOCK TABLES `inventory_items` WRITE;
/*!40000 ALTER TABLE `inventory_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `inventory_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loading_order_items`
--

DROP TABLE IF EXISTS `loading_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loading_order_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `loading_order_id` bigint NOT NULL,
  `quantity_loaded` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `nile_product_id` bigint NOT NULL,
  `remaining_quantity` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_loading_order_items_on_loading_order_id` (`loading_order_id`),
  KEY `index_loading_order_items_on_nile_product_id` (`nile_product_id`),
  CONSTRAINT `fk_rails_39f6dc3000` FOREIGN KEY (`nile_product_id`) REFERENCES `nile_products` (`id`),
  CONSTRAINT `fk_rails_c7d9326591` FOREIGN KEY (`loading_order_id`) REFERENCES `loading_orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loading_order_items`
--

LOCK TABLES `loading_order_items` WRITE;
/*!40000 ALTER TABLE `loading_order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `loading_order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `loading_orders`
--

DROP TABLE IF EXISTS `loading_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `loading_orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `territory_id` bigint NOT NULL,
  `vehicle_numperplate` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `loading_date` datetime(6) DEFAULT NULL,
  `order_number` varchar(255) DEFAULT NULL,
  `sales_man` int DEFAULT NULL,
  `authorized_by` int DEFAULT NULL,
  `verified_by` int DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `status_id` bigint NOT NULL,
  `driver_name` varchar(255) DEFAULT NULL,
  `sale_type_id` bigint NOT NULL,
  `store_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_loading_orders_on_user_id` (`user_id`),
  KEY `index_loading_orders_on_territory_id` (`territory_id`),
  KEY `index_loading_orders_on_status_id` (`status_id`),
  KEY `index_loading_orders_on_sale_type_id` (`sale_type_id`),
  KEY `index_loading_orders_on_store_id` (`store_id`),
  CONSTRAINT `fk_rails_2afc2b8571` FOREIGN KEY (`sale_type_id`) REFERENCES `sale_types` (`id`),
  CONSTRAINT `fk_rails_3cea17a414` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_6040f1a357` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`),
  CONSTRAINT `fk_rails_c38846ea25` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`),
  CONSTRAINT `fk_rails_f1dfeb551f` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `loading_orders`
--

LOCK TABLES `loading_orders` WRITE;
/*!40000 ALTER TABLE `loading_orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `loading_orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nile_categories`
--

DROP TABLE IF EXISTS `nile_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nile_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nile_categories`
--

LOCK TABLES `nile_categories` WRITE;
/*!40000 ALTER TABLE `nile_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `nile_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nile_products`
--

DROP TABLE IF EXISTS `nile_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nile_products` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `crate_size` int DEFAULT NULL,
  `bottle_size` varchar(255) DEFAULT NULL,
  `pcode` varchar(255) DEFAULT NULL,
  `nile_category_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `buying_price` varchar(255) DEFAULT NULL,
  `selling_price` varchar(255) DEFAULT NULL,
  `empty_type_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_nile_products_on_nile_category_id` (`nile_category_id`),
  KEY `index_nile_products_on_empty_type_id` (`empty_type_id`),
  CONSTRAINT `fk_rails_36b7e704f3` FOREIGN KEY (`nile_category_id`) REFERENCES `nile_categories` (`id`),
  CONSTRAINT `fk_rails_78471685f4` FOREIGN KEY (`empty_type_id`) REFERENCES `empty_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nile_products`
--

LOCK TABLES `nile_products` WRITE;
/*!40000 ALTER TABLE `nile_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `nile_products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_drivers`
--

DROP TABLE IF EXISTS `order_drivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_drivers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `driver_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_order_drivers_on_order_id` (`order_id`),
  KEY `index_order_drivers_on_driver_id` (`driver_id`),
  CONSTRAINT `fk_rails_67203dd775` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  CONSTRAINT `fk_rails_9207a5f17c` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_drivers`
--

LOCK TABLES `order_drivers` WRITE;
/*!40000 ALTER TABLE `order_drivers` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_drivers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_items`
--

DROP TABLE IF EXISTS `order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `nile_product_id` bigint NOT NULL,
  `quantity` decimal(10,0) DEFAULT NULL,
  `unit_price` decimal(10,0) DEFAULT NULL,
  `total` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `unit_of_measurement_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_order_items_on_order_id` (`order_id`),
  KEY `index_order_items_on_nile_product_id` (`nile_product_id`),
  KEY `index_order_items_on_unit_of_measurement_id` (`unit_of_measurement_id`),
  CONSTRAINT `fk_rails_7f5d87984a` FOREIGN KEY (`nile_product_id`) REFERENCES `nile_products` (`id`),
  CONSTRAINT `fk_rails_961acd49cc` FOREIGN KEY (`unit_of_measurement_id`) REFERENCES `unit_of_measurements` (`id`),
  CONSTRAINT `fk_rails_e3cb28f071` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_items`
--

LOCK TABLES `order_items` WRITE;
/*!40000 ALTER TABLE `order_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_routes`
--

DROP TABLE IF EXISTS `order_routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_routes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_id` bigint NOT NULL,
  `route_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_order_routes_on_order_id` (`order_id`),
  KEY `index_order_routes_on_route_id` (`route_id`),
  CONSTRAINT `fk_rails_525957e912` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `fk_rails_ed1ce4018a` FOREIGN KEY (`route_id`) REFERENCES `routes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_routes`
--

LOCK TABLES `order_routes` WRITE;
/*!40000 ALTER TABLE `order_routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `order_routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_number` varchar(255) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `status_id` bigint NOT NULL,
  `total_price` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `departure_date` date DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `territory_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_orders_on_user_id` (`user_id`),
  KEY `index_orders_on_status_id` (`status_id`),
  KEY `index_orders_on_territory_id` (`territory_id`),
  CONSTRAINT `fk_rails_60e8d544e7` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`),
  CONSTRAINT `fk_rails_f80a4e9572` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`),
  CONSTRAINT `fk_rails_f868b47f6a` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positions`
--

DROP TABLE IF EXISTS `positions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `positions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positions`
--

LOCK TABLES `positions` WRITE;
/*!40000 ALTER TABLE `positions` DISABLE KEYS */;
INSERT INTO `positions` VALUES (1,'Administrator','2025-02-12 15:05:12.303150','2025-02-12 15:05:12.303150'),(2,'C.E.O','2025-02-12 15:05:23.134187','2025-02-12 15:05:23.134187'),(3,'Accountant','2025-02-12 15:05:31.046991','2025-02-12 15:05:31.046991'),(4,'Driver','2025-02-12 15:05:38.724843','2025-02-12 15:05:38.724843');
/*!40000 ALTER TABLE `positions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `purchase_types`
--

DROP TABLE IF EXISTS `purchase_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `purchase_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `purchase_types`
--

LOCK TABLES `purchase_types` WRITE;
/*!40000 ALTER TABLE `purchase_types` DISABLE KEYS */;
INSERT INTO `purchase_types` VALUES (1,'Normal','2025-02-12 15:23:16.183585','2025-02-12 15:23:16.183585'),(2,'FBI','2025-02-12 15:23:21.433006','2025-02-12 15:23:21.433006');
/*!40000 ALTER TABLE `purchase_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `routes`
--

DROP TABLE IF EXISTS `routes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `routes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `start_location` varchar(255) DEFAULT NULL,
  `end_location` varchar(255) DEFAULT NULL,
  `distance` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `routes`
--

LOCK TABLES `routes` WRITE;
/*!40000 ALTER TABLE `routes` DISABLE KEYS */;
/*!40000 ALTER TABLE `routes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_empties`
--

DROP TABLE IF EXISTS `sale_empties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_empties` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `sale_id` bigint NOT NULL,
  `empty_type_id` bigint NOT NULL,
  `expected` int DEFAULT NULL,
  `received` int DEFAULT NULL,
  `variance` int DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sale_empties_on_sale_id` (`sale_id`),
  KEY `index_sale_empties_on_empty_type_id` (`empty_type_id`),
  CONSTRAINT `fk_rails_d6ff5e79f0` FOREIGN KEY (`empty_type_id`) REFERENCES `empty_types` (`id`),
  CONSTRAINT `fk_rails_ec1e41d4a8` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_empties`
--

LOCK TABLES `sale_empties` WRITE;
/*!40000 ALTER TABLE `sale_empties` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_empties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_items`
--

DROP TABLE IF EXISTS `sale_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_items` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `loading_order_item_id` bigint NOT NULL,
  `quantity_sold` decimal(10,0) DEFAULT NULL,
  `amount` decimal(10,0) DEFAULT NULL,
  `total` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `empties_returned` int DEFAULT NULL,
  `cash_for_empties` decimal(10,0) DEFAULT NULL,
  `sale_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sale_items_on_loading_order_item_id` (`loading_order_item_id`),
  KEY `index_sale_items_on_sale_id` (`sale_id`),
  CONSTRAINT `fk_rails_a2563c1567` FOREIGN KEY (`sale_id`) REFERENCES `sales` (`id`),
  CONSTRAINT `fk_rails_d6931688ee` FOREIGN KEY (`loading_order_item_id`) REFERENCES `loading_order_items` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_items`
--

LOCK TABLES `sale_items` WRITE;
/*!40000 ALTER TABLE `sale_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sale_types`
--

DROP TABLE IF EXISTS `sale_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sale_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sale_types`
--

LOCK TABLES `sale_types` WRITE;
/*!40000 ALTER TABLE `sale_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `sale_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sales` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `mode_of_payment` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `receipt_no` varchar(255) DEFAULT NULL,
  `territory_id` bigint NOT NULL,
  `verified_by` int DEFAULT NULL,
  `sale_date` datetime(6) DEFAULT NULL,
  `customer_name` varchar(255) DEFAULT NULL,
  `tin` varchar(255) DEFAULT NULL,
  `payment_ref` varchar(255) DEFAULT NULL,
  `status_id` bigint NOT NULL,
  `sales_route` varchar(255) DEFAULT NULL,
  `customer_mobile` varchar(255) DEFAULT NULL,
  `notes` text,
  `vat` decimal(10,0) DEFAULT NULL,
  `purchase_type_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_sales_on_user_id` (`user_id`),
  KEY `index_sales_on_territory_id` (`territory_id`),
  KEY `index_sales_on_status_id` (`status_id`),
  KEY `index_sales_on_purchase_type_id` (`purchase_type_id`),
  CONSTRAINT `fk_rails_032602a7f7` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`),
  CONSTRAINT `fk_rails_21b683dc5c` FOREIGN KEY (`status_id`) REFERENCES `statuses` (`id`),
  CONSTRAINT `fk_rails_8e94f16ccc` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_fbc7653f51` FOREIGN KEY (`purchase_type_id`) REFERENCES `purchase_types` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sales`
--

LOCK TABLES `sales` WRITE;
/*!40000 ALTER TABLE `sales` DISABLE KEYS */;
/*!40000 ALTER TABLE `sales` ENABLE KEYS */;
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
INSERT INTO `schema_migrations` VALUES ('20241112061814'),('20241113014554'),('20241113022003'),('20241113051227'),('20241114125723'),('20241122062843'),('20241123214759'),('20241124171857'),('20241124190555'),('20241125060039'),('20241125080655'),('20241125120434'),('20241126192524'),('20241126195700'),('20241126200406'),('20241126204423'),('20241127074214'),('20241127074506'),('20241127074652'),('20241127075640'),('20241127092628'),('20241127183230'),('20241127185828'),('20241127191832'),('20241127192513'),('20241127192857'),('20241127201052'),('20241127204134'),('20241127204252'),('20241127204553'),('20241129051239'),('20241129080445'),('20241129080555'),('20241129081552'),('20241129091354'),('20241202044052'),('20241203201037'),('20241203212650'),('20241203220856'),('20241203231610'),('20241206104913'),('20241207130915'),('20241207133559'),('20241208220249'),('20241208223303'),('20241208232632'),('20241211042701'),('20241211151745'),('20241211154057'),('20241211163556'),('20241211164656'),('20241211204111'),('20241211220330'),('20241211232234'),('20241212080332'),('20241212084420'),('20241212201946'),('20241212204552'),('20241212213911'),('20241213054822'),('20241213055944'),('20241213071730'),('20241215174924'),('20241215221644'),('20241215221907'),('20241215230704'),('20241215231446'),('20241215233613'),('20241217125340'),('20241217125443'),('20241217130009'),('20241217220457'),('20241218125921'),('20241219144333'),('20241219151541'),('20241219162921'),('20241219162922'),('20241220045911'),('20241220050422'),('20241220050732'),('20241220050911'),('20241220114335'),('20241220120718'),('20241220122301'),('20241220131056'),('20241220131321'),('20241220131717'),('20241229144044'),('20241229174440'),('20241230124512'),('20241230144125'),('20241230144229'),('20241230161858'),('20241230190552'),('20241230195824'),('20241230231638'),('20241230233022'),('20241230234749'),('20241231001937'),('20241231064913'),('20241231105708'),('20250121074345'),('20250122151225'),('20250122151512'),('20250210054505'),('20250210123526'),('20250210124326'),('20250210124636'),('20250210130516'),('20250210131600'),('20250211124902'),('20250211124939');
/*!40000 ALTER TABLE `schema_migrations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `statuses`
--

DROP TABLE IF EXISTS `statuses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `statuses` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `statuses`
--

LOCK TABLES `statuses` WRITE;
/*!40000 ALTER TABLE `statuses` DISABLE KEYS */;
INSERT INTO `statuses` VALUES (1,'Waiting for driver','ODD','Order has been waiting for driver','2025-02-12 15:28:09.068991','2025-02-12 15:28:09.068991'),(2,'Order Submitted','OS','Order has been submitted for supply','2025-02-12 15:28:36.739089','2025-02-12 15:28:36.739089'),(3,'Order Shipped','ODS','Order shipped from supplier to warehouse','2025-02-12 15:29:11.427481','2025-02-12 15:29:11.427481'),(4,'Order Received','ODR','Order has been delivered at the warehouse','2025-02-12 15:29:33.944161','2025-02-12 15:29:33.944161'),(5,'Order Canceled','ODC','Order has been canceled','2025-02-12 15:29:57.325932','2025-02-12 15:29:57.325932'),(6,'Order waiting approval','LOS','Loading order submitted for approval','2025-02-12 15:30:22.319299','2025-02-12 15:30:22.319299'),(7,'Loading Order Approved','LOA','Loading order approved by supervisor','2025-02-12 15:30:45.619706','2025-02-12 15:30:45.619706'),(8,'Expense waiting approval','EWA','Expense waiting approval from the manager','2025-02-12 15:31:10.190876','2025-02-12 15:31:10.190876'),(9,'Expense Approved','EA','Expense approved by responsible person','2025-02-12 15:31:47.219356','2025-02-12 15:31:47.219356'),(10,'Expense Rejected','ER','Expense rejected by approver','2025-02-12 15:32:20.714511','2025-02-12 15:32:20.714511'),(11,'Money Received','MR','After the expense is approved money can then be cashed','2025-02-12 15:33:38.949779','2025-02-12 15:33:38.949779'),(12,'Waiting approval','SS','Sale submitted for manager approval','2025-02-12 15:33:59.416783','2025-02-12 15:33:59.416783');
/*!40000 ALTER TABLE `statuses` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stock_stores`
--

DROP TABLE IF EXISTS `stock_stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stock_stores` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `inventory_item_id` bigint NOT NULL,
  `store_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_stock_stores_on_inventory_item_id` (`inventory_item_id`),
  KEY `index_stock_stores_on_store_id` (`store_id`),
  CONSTRAINT `fk_rails_a792f6d7a1` FOREIGN KEY (`inventory_item_id`) REFERENCES `inventory_items` (`id`),
  CONSTRAINT `fk_rails_aec777109f` FOREIGN KEY (`store_id`) REFERENCES `stores` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_stores`
--

LOCK TABLES `stock_stores` WRITE;
/*!40000 ALTER TABLE `stock_stores` DISABLE KEYS */;
/*!40000 ALTER TABLE `stock_stores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `stores`
--

DROP TABLE IF EXISTS `stores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `stores` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `territory_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_stores_on_territory_id` (`territory_id`),
  CONSTRAINT `fk_rails_a7618d0683` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stores`
--

LOCK TABLES `stores` WRITE;
/*!40000 ALTER TABLE `stores` DISABLE KEYS */;
/*!40000 ALTER TABLE `stores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `system_modules`
--

DROP TABLE IF EXISTS `system_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `system_modules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `module_url` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `department_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_system_modules_on_department_id` (`department_id`),
  CONSTRAINT `fk_rails_6783031ff5` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `system_modules`
--

LOCK TABLES `system_modules` WRITE;
/*!40000 ALTER TABLE `system_modules` DISABLE KEYS */;
INSERT INTO `system_modules` VALUES (1,'Products','/nile_products','',5,'2025-02-12 15:19:21.085670','2025-02-12 15:19:21.085670'),(2,'Orders','/orders','',5,'2025-02-12 15:19:44.628246','2025-02-12 15:19:44.628246'),(3,'Inventory','/inventory_items','',5,'2025-02-12 15:20:01.516852','2025-02-12 15:20:01.516852'),(4,'Distributions','/loading_orders','',5,'2025-02-12 15:20:18.725736','2025-02-12 15:20:18.725736'),(5,'Expenses','/expenses','',5,'2025-02-12 15:20:36.938402','2025-02-12 15:20:36.938402'),(6,'Sales','/sales','',5,'2025-02-12 15:20:54.105827','2025-02-12 15:20:54.105827');
/*!40000 ALTER TABLE `system_modules` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `taxes`
--

DROP TABLE IF EXISTS `taxes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `taxes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `tax_percentage` decimal(10,0) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `taxes`
--

LOCK TABLES `taxes` WRITE;
/*!40000 ALTER TABLE `taxes` DISABLE KEYS */;
/*!40000 ALTER TABLE `taxes` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `territories`
--

LOCK TABLES `territories` WRITE;
/*!40000 ALTER TABLE `territories` DISABLE KEYS */;
INSERT INTO `territories` VALUES (1,'Mbarara','','',5,'2025-02-12 15:14:15.383605','2025-02-12 15:14:15.383605'),(2,'Kasese','','',5,'2025-02-12 15:22:37.308762','2025-02-12 15:22:37.308762');
/*!40000 ALTER TABLE `territories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `truck_drivers`
--

DROP TABLE IF EXISTS `truck_drivers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `truck_drivers` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `truck_id` bigint NOT NULL,
  `driver_id` bigint NOT NULL,
  `date_assigned` varchar(255) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_truck_drivers_on_truck_id` (`truck_id`),
  KEY `index_truck_drivers_on_driver_id` (`driver_id`),
  KEY `index_truck_drivers_on_user_id` (`user_id`),
  CONSTRAINT `fk_rails_2ac4ecb9de` FOREIGN KEY (`truck_id`) REFERENCES `trucks` (`id`),
  CONSTRAINT `fk_rails_2acfa0ef6d` FOREIGN KEY (`driver_id`) REFERENCES `drivers` (`id`),
  CONSTRAINT `fk_rails_a72696296b` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `truck_drivers`
--

LOCK TABLES `truck_drivers` WRITE;
/*!40000 ALTER TABLE `truck_drivers` DISABLE KEYS */;
/*!40000 ALTER TABLE `truck_drivers` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `truck_types`
--

DROP TABLE IF EXISTS `truck_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `truck_types` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `truck_types`
--

LOCK TABLES `truck_types` WRITE;
/*!40000 ALTER TABLE `truck_types` DISABLE KEYS */;
/*!40000 ALTER TABLE `truck_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `trucks`
--

DROP TABLE IF EXISTS `trucks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `trucks` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `plate_number` varchar(255) DEFAULT NULL,
  `model` varchar(255) DEFAULT NULL,
  `chasis` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `car_make_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  `truck_type_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_trucks_on_car_make_id` (`car_make_id`),
  KEY `index_trucks_on_truck_type_id` (`truck_type_id`),
  CONSTRAINT `fk_rails_6876d6df80` FOREIGN KEY (`truck_type_id`) REFERENCES `truck_types` (`id`),
  CONSTRAINT `fk_rails_791cf30f8c` FOREIGN KEY (`car_make_id`) REFERENCES `car_makes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `trucks`
--

LOCK TABLES `trucks` WRITE;
/*!40000 ALTER TABLE `trucks` DISABLE KEYS */;
/*!40000 ALTER TABLE `trucks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tt_categories`
--

DROP TABLE IF EXISTS `tt_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tt_categories` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tt_categories`
--

LOCK TABLES `tt_categories` WRITE;
/*!40000 ALTER TABLE `tt_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `tt_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit_of_measurements`
--

DROP TABLE IF EXISTS `unit_of_measurements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit_of_measurements` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit_of_measurements`
--

LOCK TABLES `unit_of_measurements` WRITE;
/*!40000 ALTER TABLE `unit_of_measurements` DISABLE KEYS */;
INSERT INTO `unit_of_measurements` VALUES (1,'Bottle','Bottle','2025-02-12 15:34:44.948774','2025-02-12 15:34:44.948774'),(2,'Crate','Crate','2025-02-12 15:34:52.656937','2025-02-12 15:34:52.656937'),(3,'Piece','PC','2025-02-12 15:35:05.384632','2025-02-12 15:35:05.384632');
/*!40000 ALTER TABLE `unit_of_measurements` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_modules`
--

DROP TABLE IF EXISTS `user_modules`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_modules` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `system_module_id` bigint NOT NULL,
  `user_id` bigint NOT NULL,
  `territory_id` bigint NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `index_user_modules_on_system_module_id` (`system_module_id`),
  KEY `index_user_modules_on_user_id` (`user_id`),
  KEY `index_user_modules_on_territory_id` (`territory_id`),
  CONSTRAINT `fk_rails_4d1ae844c2` FOREIGN KEY (`system_module_id`) REFERENCES `system_modules` (`id`),
  CONSTRAINT `fk_rails_a26467225f` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `fk_rails_da0c613a42` FOREIGN KEY (`territory_id`) REFERENCES `territories` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_modules`
--

LOCK TABLES `user_modules` WRITE;
/*!40000 ALTER TABLE `user_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_modules` ENABLE KEYS */;
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
  `employee_id` bigint NOT NULL,
  `role` int DEFAULT NULL,
  `is_super` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_users_on_email` (`email`),
  UNIQUE KEY `index_users_on_reset_password_token` (`reset_password_token`),
  KEY `index_users_on_employee_id` (`employee_id`),
  CONSTRAINT `fk_rails_bb0d626f7d` FOREIGN KEY (`employee_id`) REFERENCES `employees` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'dbmukombe@gmail.com','$2a$12$cqav3Nvv.m38XSQ292OOkeUL5UhjEFHdjZx8yYIlxwvFCe0rbrMci',NULL,NULL,NULL,'2025-02-12 15:10:39.552687','2025-02-12 15:10:39.552687',1,2,1),(2,'atuhairepatience.finance@kabacoug.com','$2a$12$lZIsKPIJadW7qb7Ha4PmdOCUMiHmDmoRM6JwKhAJ/rTzb2qAEWSXO',NULL,NULL,NULL,'2025-02-17 07:04:48.687335','2025-02-17 07:04:48.687335',2,2,NULL);
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

-- Dump completed on 2025-02-17 10:06:28
