-- MariaDB dump 10.17  Distrib 10.4.11-MariaDB, for osx10.15 (x86_64)
--
-- Host: localhost    Database: corona
-- ------------------------------------------------------
-- Server version	10.4.11-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `corona`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `corona` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;

USE `corona`;

--
-- Table structure for table `US_status`
--

DROP TABLE IF EXISTS `US_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `US_status` (
  `STTUS_SN` int(11) NOT NULL AUTO_INCREMENT,
  `STTUS_NUM` int(11) NOT NULL,
  `STTUS_NAME` varchar(20) NOT NULL,
  `NUM` int(11) NOT NULL,
  `REGIST_DTM` date NOT NULL,
  PRIMARY KEY (`STTUS_SN`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `US_status`
--

LOCK TABLES `US_status` WRITE;
/*!40000 ALTER TABLE `US_status` DISABLE KEYS */;
INSERT INTO `US_status` VALUES (21,0,'Corona Cases',1215862,'2020-05-05'),(22,1,'Death',70147,'2020-05-05'),(23,2,'Recovered',188069,'2020-05-05'),(24,0,'Corona Cases',1263092,'2020-05-06'),(25,1,'Death',74799,'2020-05-06'),(26,2,'Recovered',212981,'2020-05-06'),(27,0,'Corona Cases',1292623,'2020-05-07'),(28,1,'Death',76928,'2020-05-07'),(29,2,'Recovered',217250,'2020-05-07'),(30,0,'Corona Cases',1349599,'2020-05-09'),(31,1,'Death',80101,'2020-05-09'),(32,2,'Recovered',238081,'2020-05-09'),(33,0,'Corona Cases',1349996,'2020-05-10'),(34,1,'Death',80121,'2020-05-10'),(35,2,'Recovered',238114,'2020-05-10'),(36,0,'Corona Cases',1387407,'2020-05-11'),(37,1,'Death',81909,'2020-05-11'),(38,2,'Recovered',262225,'2020-05-11'),(39,0,'Corona Cases',1408636,'2020-05-12'),(40,1,'Death',83425,'2020-05-12'),(41,2,'Recovered',296746,'2020-05-12'),(42,0,'Corona Cases',1527664,'2020-05-17'),(43,1,'Death',90978,'2020-05-17'),(44,2,'Recovered',346389,'2020-05-17'),(45,0,'Corona Cases',1706226,'2020-05-25'),(46,1,'Death',99805,'2020-05-25'),(47,2,'Recovered',464670,'2020-05-25'),(48,0,'Corona Cases',1859693,'2020-06-01'),(49,1,'Death',106927,'2020-06-01'),(50,2,'Recovered',615426,'2020-06-01');
/*!40000 ALTER TABLE `US_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `affiliation`
--

DROP TABLE IF EXISTS `affiliation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `affiliation` (
  `AFF_SN` int(11) NOT NULL AUTO_INCREMENT,
  `AFF_NM` varchar(200) NOT NULL,
  PRIMARY KEY (`AFF_SN`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `affiliation`
--

LOCK TABLES `affiliation` WRITE;
/*!40000 ALTER TABLE `affiliation` DISABLE KEYS */;
INSERT INTO `affiliation` VALUES (1,'U.S. Military'),(2,'ROK Military'),(3,'U.S. Civilian'),(4,'ROK Civilian');
/*!40000 ALTER TABLE `affiliation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `answer`
--

DROP TABLE IF EXISTS `answer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `answer` (
  `U_SN` int(11) NOT NULL,
  `Q_SN` int(11) NOT NULL,
  `A_ANS` varchar(500) DEFAULT NULL,
  KEY `Q_SN` (`Q_SN`),
  CONSTRAINT `answer_ibfk_1` FOREIGN KEY (`Q_SN`) REFERENCES `question` (`Q_SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `answer`
--

LOCK TABLES `answer` WRITE;
/*!40000 ALTER TABLE `answer` DISABLE KEYS */;
INSERT INTO `answer` VALUES (975,1,'1'),(975,2,'1'),(975,2,'2'),(975,3,'1'),(975,4,'US'),(975,5,'1'),(975,6,'Dunkin Donuts'),(975,7,'0'),(283,1,'1'),(283,2,'5'),(283,3,'1'),(283,4,'United States'),(283,5,'0'),(283,7,'1'),(283,8,'1'),(725,1,'0'),(725,3,'0'),(725,5,'0'),(725,7,'0'),(169,1,'1'),(169,2,'1'),(169,2,'2'),(169,2,'3'),(169,3,'0'),(169,5,'1'),(169,6,'Starbucks'),(169,7,'1'),(169,8,'1'),(907,1,'1'),(907,2,'4'),(907,2,'5'),(907,3,'1'),(907,4,'adsd'),(907,5,'0'),(907,7,'1'),(907,8,'1'),(798,1,'0'),(798,3,'1'),(798,6,'New Px'),(798,7,'1'),(798,5,'1'),(798,4,'United States'),(14,4,'United States'),(15,1,'1'),(492,2,'2'),(492,2,'4'),(932,1,'1'),(932,2,'3'),(932,2,'5'),(932,3,'0'),(932,5,'0'),(932,7,'0'),(435,1,'1'),(435,2,'5'),(435,3,'1'),(944,1,'0'),(944,3,'0'),(944,5,'0'),(944,7,'0'),(830,1,'0'),(830,3,'0'),(830,5,'0'),(830,7,'0'),(517,1,'1'),(517,2,'4'),(517,2,'5'),(517,3,'0'),(517,5,'0'),(517,7,'0'),(733,1,'0'),(733,3,'0'),(733,5,'0'),(733,7,'0'),(365,1,'0'),(365,3,'0'),(365,5,'0'),(365,7,'0'),(46,1,'0'),(46,3,'0'),(46,5,'0'),(46,7,'0'),(480,1,'0'),(480,3,'0'),(480,5,'0'),(480,7,'0'),(119,1,'0'),(119,3,'0'),(119,5,'0'),(119,7,'0'),(247,1,'0'),(247,3,'0'),(247,5,'0'),(247,7,'0'),(251,3,'0'),(251,5,'0'),(251,7,'0'),(149,1,'0'),(149,3,'0'),(149,5,'0'),(149,7,'0'),(715,1,'0'),(715,3,'0'),(715,5,'0'),(715,7,'0'),(271,1,'0'),(271,3,'0'),(271,5,'0'),(271,7,'0'),(859,1,'0'),(859,3,'0'),(859,5,'0'),(859,7,'0'),(287,1,'1'),(287,2,'1'),(287,2,'2'),(287,2,'3'),(287,3,'1'),(287,4,'United States'),(287,5,'1'),(287,6,'Dunkin Donuts'),(287,7,'1'),(287,8,'0'),(186,1,'0'),(186,3,'0'),(186,5,'0'),(186,7,'0'),(740,1,'0'),(740,3,'0'),(97,1,'1'),(97,2,'1'),(97,2,'3'),(97,2,'4'),(97,3,'0'),(97,5,'0'),(97,7,'0'),(741,1,'1'),(741,2,'5'),(741,3,'0'),(741,5,'1'),(741,6,'Dunkin Donuts'),(741,7,'1'),(741,8,'1'),(771,1,'1'),(568,1,'1'),(884,1,'1'),(884,2,'1'),(884,2,'2'),(884,2,'3'),(884,2,'4'),(884,3,'1'),(884,4,'United States'),(884,5,'1'),(884,6,'Dunkin Donuts'),(884,7,'0'),(140,1,'0'),(140,3,'0'),(140,5,'0'),(140,7,'1'),(140,8,'1'),(473,1,'1'),(473,2,'1'),(473,2,'2'),(473,2,'3'),(473,3,'0'),(473,5,'1'),(473,6,'Dunkin Donuts'),(473,7,'1'),(473,8,'0'),(251,1,'1'),(251,2,'5'),(319,1,'0'),(105,1,'0'),(105,3,'0'),(434,1,'0'),(434,3,'0'),(434,5,'0'),(434,7,'0'),(815,1,'1'),(815,2,'1'),(815,2,'2'),(815,2,'5'),(815,3,'0'),(815,5,'0'),(815,7,'1'),(815,8,'1'),(888,1,'1'),(888,2,'2'),(888,2,'3'),(888,2,'4'),(888,3,'0'),(888,5,'0'),(888,7,'1'),(888,8,'1'),(868,1,'1'),(37,1,'1'),(37,2,'1'),(37,2,'2'),(37,2,'3'),(37,3,'0'),(37,5,'1'),(37,6,'New PX, Dunkin Donuts, Starbucks '),(37,7,'1'),(37,8,'0'),(432,1,'1'),(432,2,'2'),(432,2,'3'),(432,2,'4'),(432,3,'1'),(432,4,'United States'),(432,5,'0'),(432,7,'1'),(432,8,'0'),(596,1,'1'),(596,2,'1'),(596,2,'2'),(596,2,'3'),(596,3,'1'),(596,4,'United States'),(596,5,'1'),(596,6,'New Px'),(596,7,'1'),(596,8,'0'),(265,1,'1'),(265,2,'1'),(265,2,'2'),(265,2,'3'),(265,3,'1'),(265,4,'China'),(265,5,'1'),(265,6,'8th Army HQ'),(265,7,'1'),(265,8,'0'),(811,1,'1'),(811,2,'1'),(811,2,'2'),(811,2,'3'),(811,2,'4'),(811,3,'1'),(811,4,'CHina'),(811,5,'1'),(811,6,'Super Gym '),(811,7,'1'),(811,8,'0'),(803,1,'1'),(803,2,'1'),(803,2,'2'),(803,2,'3'),(803,3,'0'),(803,5,'1'),(803,6,'Super Gym '),(803,7,'1'),(803,8,'0'),(92,1,'0'),(92,3,'0'),(92,5,'0'),(189,1,'1'),(189,2,'1'),(189,2,'3'),(189,2,'4'),(189,3,'0'),(189,5,'1'),(189,6,'Super Gym '),(51,1,'1'),(51,2,'1'),(51,2,'4'),(51,2,'5'),(51,3,'0'),(51,5,'1'),(51,6,'Super Gym '),(51,7,'1'),(51,8,'1'),(113,1,'1'),(113,2,'1'),(113,2,'3'),(113,3,'0'),(113,5,'1'),(113,6,'Provider Grills, Dunkin Donuts (Old PX)'),(113,7,'0'),(832,1,'1'),(832,2,'1'),(832,2,'2'),(832,2,'5'),(832,3,'0'),(832,5,'1'),(832,6,'Provider Grills, Super Gym, Dukin Donuts(Old PX)'),(832,7,'0'),(349,1,'0'),(939,1,'0'),(939,3,'0'),(939,5,'0'),(939,7,'0'),(792,1,'0'),(792,3,'0'),(792,5,'0'),(792,7,'0'),(492,1,'0'),(492,3,'0'),(492,5,'0'),(492,7,'0'),(511,1,'1'),(511,2,'5'),(511,3,'0'),(511,5,'0'),(511,7,'0'),(931,1,'0'),(931,3,'0'),(931,5,'0'),(931,7,'0'),(563,1,'0'),(563,3,'0'),(563,5,'0'),(563,7,'0');
/*!40000 ALTER TABLE `answer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `date`
--

DROP TABLE IF EXISTS `date`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `date` (
  `P_SN` int(11) NOT NULL,
  `H_SN` int(11) NOT NULL,
  `H_DATE` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `date`
--

LOCK TABLES `date` WRITE;
/*!40000 ALTER TABLE `date` DISABLE KEYS */;
/*!40000 ALTER TABLE `date` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `example`
--

DROP TABLE IF EXISTS `example`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `example` (
  `Q_SN` int(11) NOT NULL,
  `EX_TEXT` varchar(500) NOT NULL,
  `A_ANS` int(11) DEFAULT NULL,
  `NEXT_Q_SN` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `example`
--

LOCK TABLES `example` WRITE;
/*!40000 ALTER TABLE `example` DISABLE KEYS */;
INSERT INTO `example` VALUES (1,'Yes',1,2),(1,'No',0,3),(2,'Chest Pain',1,3),(2,'Fever',2,3),(2,'Chills',3,3),(2,'Cough',4,3),(2,'Shortness of Breath',5,3),(3,'Yes',1,4),(3,'No',0,5),(4,'Type All the List of Visted Countries (ex. United States, China)',0,5),(5,'Yes',1,6),(5,'No',0,7),(6,'Type All the List of Visited Hotspots (ex. New PX, Super Gym)',0,7),(7,'Yes',1,8),(7,'No',0,9),(8,'Direct Contact',1,9),(8,'Indirect Contact',0,9);
/*!40000 ALTER TABLE `example` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hotspots`
--

DROP TABLE IF EXISTS `hotspots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hotspots` (
  `P_SN` int(11) NOT NULL,
  `H_TIME` datetime NOT NULL,
  `H_DESC` varchar(800) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hotspots`
--

LOCK TABLES `hotspots` WRITE;
/*!40000 ALTER TABLE `hotspots` DISABLE KEYS */;
/*!40000 ALTER TABLE `hotspots` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `location`
--

DROP TABLE IF EXISTS `location`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `location` (
  `LOC_SN` int(11) NOT NULL AUTO_INCREMENT,
  `LOC_NUM` int(11) NOT NULL,
  `LOC_NAME` varchar(20) DEFAULT NULL,
  `CONFIRM` int(11) NOT NULL,
  `REGIST_DTM` date NOT NULL,
  PRIMARY KEY (`LOC_SN`)
) ENGINE=InnoDB AUTO_INCREMENT=19801 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `location`
--

LOCK TABLES `location` WRITE;
/*!40000 ALTER TABLE `location` DISABLE KEYS */;
INSERT INTO `location` VALUES (19585,1,'Seoul',637,'2020-05-03'),(19586,2,'Busan',138,'2020-05-03'),(19587,3,'Dae-gu',6856,'2020-05-03'),(19588,4,'Incheon',96,'2020-05-03'),(19589,5,'Gwangju',30,'2020-05-03'),(19590,6,'Daejeon',40,'2020-05-03'),(19591,7,'Ulsan',44,'2020-05-03'),(19592,8,'Sejong',46,'2020-05-03'),(19593,9,'Gyeong-gi',681,'2020-05-03'),(19594,10,'Gangwon',53,'2020-05-03'),(19595,11,'Chungbuk',45,'2020-05-03'),(19596,12,'Chungnam',143,'2020-05-03'),(19597,13,'Jeonbuk',18,'2020-05-03'),(19598,14,'Jeonnam',16,'2020-05-03'),(19599,15,'Kyungpook',1366,'2020-05-03'),(19600,16,'Gyeongnam',117,'2020-05-03'),(19601,17,'Jeju',13,'2020-05-03'),(19602,18,'Quarantine',462,'2020-05-03'),(19603,1,'Seoul',637,'2020-05-04'),(19604,2,'Busan',138,'2020-05-04'),(19605,3,'Dae-gu',6856,'2020-05-04'),(19606,4,'Incheon',97,'2020-05-04'),(19607,5,'Gwangju',30,'2020-05-04'),(19608,6,'Daejeon',40,'2020-05-04'),(19609,7,'Ulsan',44,'2020-05-04'),(19610,8,'Sejong',46,'2020-05-04'),(19611,9,'Gyeong-gi',681,'2020-05-04'),(19612,10,'Gangwon',53,'2020-05-04'),(19613,11,'Chungbuk',45,'2020-05-04'),(19614,12,'Chungnam',143,'2020-05-04'),(19615,13,'Jeonbuk',18,'2020-05-04'),(19616,14,'Jeonnam',16,'2020-05-04'),(19617,15,'Kyungpook',1366,'2020-05-04'),(19618,16,'Gyeongnam',117,'2020-05-04'),(19619,17,'Jeju',13,'2020-05-04'),(19620,18,'Quarantine',464,'2020-05-04'),(19621,1,'Seoul',637,'2020-05-05'),(19622,2,'Busan',138,'2020-05-05'),(19623,3,'Dae-gu',6856,'2020-05-05'),(19624,4,'Incheon',97,'2020-05-05'),(19625,5,'Gwangju',30,'2020-05-05'),(19626,6,'Daejeon',40,'2020-05-05'),(19627,7,'Ulsan',44,'2020-05-05'),(19628,8,'Sejong',46,'2020-05-05'),(19629,9,'Gyeong-gi',681,'2020-05-05'),(19630,10,'Gangwon',53,'2020-05-05'),(19631,11,'Chungbuk',45,'2020-05-05'),(19632,12,'Chungnam',143,'2020-05-05'),(19633,13,'Jeonbuk',18,'2020-05-05'),(19634,14,'Jeonnam',16,'2020-05-05'),(19635,15,'Kyungpook',1366,'2020-05-05'),(19636,16,'Gyeongnam',117,'2020-05-05'),(19637,17,'Jeju',13,'2020-05-05'),(19638,18,'Quarantine',466,'2020-05-05'),(19639,1,'Seoul',637,'2020-05-06'),(19640,2,'Busan',138,'2020-05-06'),(19641,3,'Dae-gu',6856,'2020-05-06'),(19642,4,'Incheon',97,'2020-05-06'),(19643,5,'Gwangju',30,'2020-05-06'),(19644,6,'Daejeon',41,'2020-05-06'),(19645,7,'Ulsan',44,'2020-05-06'),(19646,8,'Sejong',46,'2020-05-06'),(19647,9,'Gyeong-gi',682,'2020-05-06'),(19648,10,'Gangwon',53,'2020-05-06'),(19649,11,'Chungbuk',46,'2020-05-06'),(19650,12,'Chungnam',143,'2020-05-06'),(19651,13,'Jeonbuk',18,'2020-05-06'),(19652,14,'Jeonnam',16,'2020-05-06'),(19653,15,'Kyungpook',1366,'2020-05-06'),(19654,16,'Gyeongnam',117,'2020-05-06'),(19655,17,'Jeju',13,'2020-05-06'),(19656,18,'Quarantine',467,'2020-05-06'),(19657,1,'Seoul',637,'2020-05-07'),(19658,2,'Busan',140,'2020-05-07'),(19659,3,'Dae-gu',6859,'2020-05-07'),(19660,4,'Incheon',97,'2020-05-07'),(19661,5,'Gwangju',30,'2020-05-07'),(19662,6,'Daejeon',41,'2020-05-07'),(19663,7,'Ulsan',44,'2020-05-07'),(19664,8,'Sejong',46,'2020-05-07'),(19665,9,'Gyeong-gi',684,'2020-05-07'),(19666,10,'Gangwon',53,'2020-05-07'),(19667,11,'Chungbuk',47,'2020-05-07'),(19668,12,'Chungnam',143,'2020-05-07'),(19669,13,'Jeonbuk',19,'2020-05-07'),(19670,14,'Jeonnam',16,'2020-05-07'),(19671,15,'Kyungpook',1366,'2020-05-07'),(19672,16,'Gyeongnam',117,'2020-05-07'),(19673,17,'Jeju',13,'2020-05-07'),(19674,18,'Quarantine',470,'2020-05-07'),(19675,1,'Seoul',663,'2020-05-09'),(19676,2,'Busan',141,'2020-05-09'),(19677,3,'Dae-gu',6861,'2020-05-09'),(19678,4,'Incheon',101,'2020-05-09'),(19679,5,'Gwangju',30,'2020-05-09'),(19680,6,'Daejeon',41,'2020-05-09'),(19681,7,'Ulsan',44,'2020-05-09'),(19682,8,'Sejong',46,'2020-05-09'),(19683,9,'Gyeong-gi',694,'2020-05-09'),(19684,10,'Gangwon',53,'2020-05-09'),(19685,11,'Chungbuk',49,'2020-05-09'),(19686,12,'Chungnam',143,'2020-05-09'),(19687,13,'Jeonbuk',19,'2020-05-09'),(19688,14,'Jeonnam',16,'2020-05-09'),(19689,15,'Kyungpook',1366,'2020-05-09'),(19690,16,'Gyeongnam',117,'2020-05-09'),(19691,17,'Jeju',14,'2020-05-09'),(19692,18,'Quarantine',476,'2020-05-09'),(19693,1,'Seoul',663,'2020-05-10'),(19694,2,'Busan',141,'2020-05-10'),(19695,3,'Dae-gu',6861,'2020-05-10'),(19696,4,'Incheon',101,'2020-05-10'),(19697,5,'Gwangju',30,'2020-05-10'),(19698,6,'Daejeon',41,'2020-05-10'),(19699,7,'Ulsan',44,'2020-05-10'),(19700,8,'Sejong',46,'2020-05-10'),(19701,9,'Gyeong-gi',694,'2020-05-10'),(19702,10,'Gangwon',53,'2020-05-10'),(19703,11,'Chungbuk',49,'2020-05-10'),(19704,12,'Chungnam',143,'2020-05-10'),(19705,13,'Jeonbuk',19,'2020-05-10'),(19706,14,'Jeonnam',16,'2020-05-10'),(19707,15,'Kyungpook',1366,'2020-05-10'),(19708,16,'Gyeongnam',117,'2020-05-10'),(19709,17,'Jeju',14,'2020-05-10'),(19710,18,'Quarantine',476,'2020-05-10'),(19711,1,'Seoul',695,'2020-05-11'),(19712,2,'Busan',141,'2020-05-11'),(19713,3,'Dae-gu',6862,'2020-05-11'),(19714,4,'Incheon',105,'2020-05-11'),(19715,5,'Gwangju',30,'2020-05-11'),(19716,6,'Daejeon',43,'2020-05-11'),(19717,7,'Ulsan',44,'2020-05-11'),(19718,8,'Sejong',47,'2020-05-11'),(19719,9,'Gyeong-gi',706,'2020-05-11'),(19720,10,'Gangwon',54,'2020-05-11'),(19721,11,'Chungbuk',52,'2020-05-11'),(19722,12,'Chungnam',143,'2020-05-11'),(19723,13,'Jeonbuk',19,'2020-05-11'),(19724,14,'Jeonnam',16,'2020-05-11'),(19725,15,'Kyungpook',1367,'2020-05-11'),(19726,16,'Gyeongnam',118,'2020-05-11'),(19727,17,'Jeju',14,'2020-05-11'),(19728,18,'Quarantine',480,'2020-05-11'),(19729,1,'Seoul',707,'2020-05-12'),(19730,2,'Busan',144,'2020-05-12'),(19731,3,'Dae-gu',6865,'2020-05-12'),(19732,4,'Incheon',107,'2020-05-12'),(19733,5,'Gwangju',30,'2020-05-12'),(19734,6,'Daejeon',43,'2020-05-12'),(19735,7,'Ulsan',45,'2020-05-12'),(19736,8,'Sejong',47,'2020-05-12'),(19737,9,'Gyeong-gi',708,'2020-05-12'),(19738,10,'Gangwon',54,'2020-05-12'),(19739,11,'Chungbuk',52,'2020-05-12'),(19740,12,'Chungnam',143,'2020-05-12'),(19741,13,'Jeonbuk',20,'2020-05-12'),(19742,14,'Jeonnam',16,'2020-05-12'),(19743,15,'Kyungpook',1367,'2020-05-12'),(19744,16,'Gyeongnam',119,'2020-05-12'),(19745,17,'Jeju',14,'2020-05-12'),(19746,18,'Quarantine',481,'2020-05-12'),(19747,1,'Seoul',736,'2020-05-17'),(19748,2,'Busan',144,'2020-05-17'),(19749,3,'Dae-gu',6871,'2020-05-17'),(19750,4,'Incheon',124,'2020-05-17'),(19751,5,'Gwangju',30,'2020-05-17'),(19752,6,'Daejeon',44,'2020-05-17'),(19753,7,'Ulsan',45,'2020-05-17'),(19754,8,'Sejong',47,'2020-05-17'),(19755,9,'Gyeong-gi',724,'2020-05-17'),(19756,10,'Gangwon',55,'2020-05-17'),(19757,11,'Chungbuk',59,'2020-05-17'),(19758,12,'Chungnam',144,'2020-05-17'),(19759,13,'Jeonbuk',20,'2020-05-17'),(19760,14,'Jeonnam',18,'2020-05-17'),(19761,15,'Kyungpook',1368,'2020-05-17'),(19762,16,'Gyeongnam',121,'2020-05-17'),(19763,17,'Jeju',14,'2020-05-17'),(19764,18,'Quarantine',501,'2020-05-17'),(19765,1,'Seoul',783,'2020-05-25'),(19766,2,'Busan',144,'2020-05-25'),(19767,3,'Dae-gu',6875,'2020-05-25'),(19768,4,'Incheon',147,'2020-05-25'),(19769,5,'Gwangju',30,'2020-05-25'),(19770,6,'Daejeon',45,'2020-05-25'),(19771,7,'Ulsan',50,'2020-05-25'),(19772,8,'Sejong',47,'2020-05-25'),(19773,9,'Gyeong-gi',768,'2020-05-25'),(19774,10,'Gangwon',56,'2020-05-25'),(19775,11,'Chungbuk',60,'2020-05-25'),(19776,12,'Chungnam',145,'2020-05-25'),(19777,13,'Jeonbuk',21,'2020-05-25'),(19778,14,'Jeonnam',18,'2020-05-25'),(19779,15,'Kyungpook',1378,'2020-05-25'),(19780,16,'Gyeongnam',123,'2020-05-25'),(19781,17,'Jeju',14,'2020-05-25'),(19782,18,'Quarantine',521,'2020-05-25'),(19783,1,'Seoul',876,'2020-06-01'),(19784,2,'Busan',147,'2020-06-01'),(19785,3,'Dae-gu',6884,'2020-06-01'),(19786,4,'Incheon',232,'2020-06-01'),(19787,5,'Gwangju',32,'2020-06-01'),(19788,6,'Daejeon',46,'2020-06-01'),(19789,7,'Ulsan',52,'2020-06-01'),(19790,8,'Sejong',47,'2020-06-01'),(19791,9,'Gyeong-gi',867,'2020-06-01'),(19792,10,'Gangwon',57,'2020-06-01'),(19793,11,'Chungbuk',60,'2020-06-01'),(19794,12,'Chungnam',146,'2020-06-01'),(19795,13,'Jeonbuk',21,'2020-06-01'),(19796,14,'Jeonnam',20,'2020-06-01'),(19797,15,'Kyungpook',1379,'2020-06-01'),(19798,16,'Gyeongnam',123,'2020-06-01'),(19799,17,'Jeju',15,'2020-06-01'),(19800,18,'Quarantine',537,'2020-06-01');
/*!40000 ALTER TABLE `location` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password`
--

DROP TABLE IF EXISTS `password`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `password` (
  `password` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password`
--

LOCK TABLES `password` WRITE;
/*!40000 ALTER TABLE `password` DISABLE KEYS */;
INSERT INTO `password` VALUES ('123123');
/*!40000 ALTER TABLE `password` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `positive`
--

DROP TABLE IF EXISTS `positive`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `positive` (
  `P_SN` int(11) NOT NULL AUTO_INCREMENT,
  `P_SEX` int(11) NOT NULL,
  `P_AGE` varchar(200) NOT NULL,
  `P_AREA` int(11) DEFAULT NULL,
  `P_AFF` varchar(200) NOT NULL,
  `P_NUM` varchar(200) NOT NULL,
  PRIMARY KEY (`P_NUM`),
  KEY `P_SN` (`P_SN`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `positive`
--

LOCK TABLES `positive` WRITE;
/*!40000 ALTER TABLE `positive` DISABLE KEYS */;
/*!40000 ALTER TABLE `positive` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `question`
--

DROP TABLE IF EXISTS `question`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `question` (
  `Q_SN` int(11) NOT NULL,
  `Q_NUM` varchar(20) DEFAULT NULL,
  `Q_TYPE` int(11) DEFAULT NULL,
  `Q_TEXT` varchar(1000) NOT NULL,
  PRIMARY KEY (`Q_SN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `question`
--

LOCK TABLES `question` WRITE;
/*!40000 ALTER TABLE `question` DISABLE KEYS */;
INSERT INTO `question` VALUES (1,'1',0,'In the last 72 hours, have you had any of the following symptoms (chest pain,  fever, chills, cough, shortness of breath)?'),(2,'1-a',1,'Check all that apply'),(3,'2',0,'Have you traveled to or from Korea in the last 14 days?'),(4,'2-a',2,'What countries did you visit?'),(5,'3',0,'Did you visit a COVID-19 HOTSPOT in the last 14 days?'),(6,'3-a',2,'Explain which hotspot.'),(7,'4',0,'Have you been in contact with a positive COVID-19 individual?'),(8,'4-a',0,'Select the type of contact with individual');
/*!40000 ALTER TABLE `question` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `status`
--

DROP TABLE IF EXISTS `status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `status` (
  `STTUS_SN` int(11) NOT NULL AUTO_INCREMENT,
  `STTUS_NUM` int(11) NOT NULL,
  `STTUS_NAME` varchar(20) NOT NULL,
  `NUM` int(11) NOT NULL,
  `REGIST_DTM` date NOT NULL,
  PRIMARY KEY (`STTUS_SN`)
) ENGINE=InnoDB AUTO_INCREMENT=3412 DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `status`
--

LOCK TABLES `status` WRITE;
/*!40000 ALTER TABLE `status` DISABLE KEYS */;
INSERT INTO `status` VALUES (3376,0,'완치',9217,'2020-05-03'),(3377,1,'치료 중',1332,'2020-05-03'),(3378,2,'사망',252,'2020-05-03'),(3379,0,'완치',9283,'2020-05-04'),(3380,1,'치료 중',1267,'2020-05-04'),(3381,2,'사망',254,'2020-05-04'),(3382,0,'완치',9333,'2020-05-05'),(3383,1,'치료 중',1218,'2020-05-05'),(3384,2,'사망',255,'2020-05-05'),(3385,0,'완치',9419,'2020-05-06'),(3386,1,'치료 중',1135,'2020-05-06'),(3387,2,'사망',256,'2020-05-06'),(3388,0,'완치',9484,'2020-05-07'),(3389,1,'치료 중',1082,'2020-05-07'),(3390,2,'사망',256,'2020-05-07'),(3391,0,'완치',9610,'2020-05-09'),(3392,1,'치료 중',1008,'2020-05-09'),(3393,2,'사망',256,'2020-05-09'),(3394,0,'완치',9610,'2020-05-10'),(3395,1,'치료 중',1008,'2020-05-10'),(3396,2,'사망',256,'2020-05-10'),(3397,0,'완치',9670,'2020-05-11'),(3398,1,'치료 중',1008,'2020-05-11'),(3399,2,'사망',258,'2020-05-11'),(3400,0,'완치',9695,'2020-05-12'),(3401,1,'치료 중',1008,'2020-05-12'),(3402,2,'사망',259,'2020-05-12'),(3403,0,'완치',9904,'2020-05-17'),(3404,1,'치료 중',898,'2020-05-17'),(3405,2,'사망',263,'2020-05-17'),(3406,0,'완치',10275,'2020-05-25'),(3407,1,'치료 중',681,'2020-05-25'),(3408,2,'사망',269,'2020-05-25'),(3409,0,'완치',10446,'2020-06-01'),(3410,1,'치료 중',823,'2020-06-01'),(3411,2,'사망',272,'2020-06-01');
/*!40000 ALTER TABLE `status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `U_SN` int(11) NOT NULL,
  `LAST_NAME` varchar(50) NOT NULL,
  `FIRST_NAME` varchar(50) NOT NULL,
  `AREA` varchar(11) NOT NULL,
  `UNIT` varchar(50) NOT NULL,
  `AFFIL` varchar(50) NOT NULL,
  `PHONE_NUM` varchar(50) NOT NULL,
  `REGIST_DTM` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (563,'Kim','Ji Hyung','Area I','121 CSH','U.S. Military','01022217393','2020-05-13');
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

-- Dump completed on 2020-06-02 21:32:21
