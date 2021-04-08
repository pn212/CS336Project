CREATE DATABASE  IF NOT EXISTS `AuctionSite` /*!40100 DEFAULT CHARACTER SET latin1 */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `AuctionSite`;
-- MySQL dump 10.13  Distrib 8.0.12, for macos10.13 (x86_64)
--
-- Host: 127.0.0.1    Database: AuctionSite
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
 SET NAMES utf8 ;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `administrator`
--

DROP TABLE IF EXISTS `administrator`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `administrator` (
  `userId` int NOT NULL AUTO_INCREMENT,
  `fName` varchar(50) NOT NULL,
  `lName` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `pw` varchar(200) NOT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `administrator`
--

LOCK TABLES `administrator` WRITE;
/*!40000 ALTER TABLE `administrator` DISABLE KEYS */;
INSERT INTO `administrator` VALUES (1,'Big','Shot','ceodude@coolauctions.com','adminPassword');
/*!40000 ALTER TABLE `administrator` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Alert`
--

DROP TABLE IF EXISTS `Alert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Alert` (
  `alertSettingsId` int NOT NULL,
  `auctionId` int NOT NULL,
  PRIMARY KEY (`alertSettingsId`,`auctionId`),
  KEY `auctionId` (`auctionId`),
  CONSTRAINT `alert_ibfk_1` FOREIGN KEY (`alertSettingsId`) REFERENCES `AlertSettings` (`alertSettingsId`),
  CONSTRAINT `alert_ibfk_2` FOREIGN KEY (`auctionId`) REFERENCES `Auction` (`auctionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Alert`
--

LOCK TABLES `Alert` WRITE;
/*!40000 ALTER TABLE `Alert` DISABLE KEYS */;
/*!40000 ALTER TABLE `Alert` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AlertForAttributeName`
--

DROP TABLE IF EXISTS `AlertForAttributeName`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `AlertForAttributeName` (
  `alertSettingsId` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `catName` varchar(50) NOT NULL,
  `attributeValue` varchar(100) NOT NULL,
  PRIMARY KEY (`name`,`alertSettingsId`,`catName`),
  KEY `alertSettingsId` (`alertSettingsId`),
  KEY `name` (`name`,`catName`),
  CONSTRAINT `alertforattributename_ibfk_1` FOREIGN KEY (`alertSettingsId`) REFERENCES `AlertSettings` (`alertSettingsId`),
  CONSTRAINT `alertforattributename_ibfk_2` FOREIGN KEY (`name`, `catName`) REFERENCES `AttributeName` (`name`, `catName`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AlertForAttributeName`
--

LOCK TABLES `AlertForAttributeName` WRITE;
/*!40000 ALTER TABLE `AlertForAttributeName` DISABLE KEYS */;
/*!40000 ALTER TABLE `AlertForAttributeName` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AlertSettings`
--

DROP TABLE IF EXISTS `AlertSettings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `AlertSettings` (
  `alertSettingsId` int NOT NULL AUTO_INCREMENT,
  `userId` int DEFAULT NULL,
  PRIMARY KEY (`alertSettingsId`),
  KEY `userId` (`userId`),
  CONSTRAINT `alertsettings_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `endUser` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AlertSettings`
--

LOCK TABLES `AlertSettings` WRITE;
/*!40000 ALTER TABLE `AlertSettings` DISABLE KEYS */;
/*!40000 ALTER TABLE `AlertSettings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AttributeName`
--

DROP TABLE IF EXISTS `AttributeName`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `AttributeName` (
  `name` varchar(50) NOT NULL,
  `catName` varchar(50) NOT NULL,
  PRIMARY KEY (`name`,`catName`),
  KEY `catName` (`catName`),
  CONSTRAINT `attributename_ibfk_1` FOREIGN KEY (`catName`) REFERENCES `SubCategoryType` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AttributeName`
--

LOCK TABLES `AttributeName` WRITE;
/*!40000 ALTER TABLE `AttributeName` DISABLE KEYS */;
INSERT INTO `AttributeName` VALUES ('Car','doorCount'),('Bike','mpg'),('Bus','seatCount');
/*!40000 ALTER TABLE `AttributeName` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Auction`
--

DROP TABLE IF EXISTS `Auction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Auction` (
  `auctionName` varchar(100) NOT NULL,
  `description` varchar(1000) NOT NULL DEFAULT '',
  `minPriceCents` int NOT NULL,
  `startPriceCents` int NOT NULL,
  `incPriceCents` int NOT NULL,
  `startingDateTime` datetime NOT NULL,
  `endingDateTime` datetime NOT NULL,
  `itemId` int NOT NULL,
  `auctionId` int NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`auctionId`),
  KEY `itemId` (`itemId`),
  CONSTRAINT `auction_ibfk_1` FOREIGN KEY (`itemId`) REFERENCES `Item` (`itemId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Auction`
--

LOCK TABLES `Auction` WRITE;
/*!40000 ALTER TABLE `Auction` DISABLE KEYS */;
/*!40000 ALTER TABLE `Auction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `AutoBid`
--

DROP TABLE IF EXISTS `AutoBid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `AutoBid` (
  `maxAmount` int NOT NULL,
  `userID` int NOT NULL,
  `auctionId` int NOT NULL,
  PRIMARY KEY (`userID`,`auctionId`),
  KEY `auctionId` (`auctionId`),
  CONSTRAINT `autobid_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `endUser` (`userId`),
  CONSTRAINT `autobid_ibfk_2` FOREIGN KEY (`auctionId`) REFERENCES `Auction` (`auctionId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AutoBid`
--

LOCK TABLES `AutoBid` WRITE;
/*!40000 ALTER TABLE `AutoBid` DISABLE KEYS */;
/*!40000 ALTER TABLE `AutoBid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Bid`
--

DROP TABLE IF EXISTS `Bid`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Bid` (
  `amountCents` int NOT NULL,
  `bidDateTime` datetime NOT NULL,
  `auctionId` int NOT NULL,
  `userId` int NOT NULL,
  PRIMARY KEY (`auctionId`,`amountCents`),
  KEY `userId` (`userId`),
  CONSTRAINT `bid_ibfk_1` FOREIGN KEY (`auctionId`) REFERENCES `Auction` (`auctionId`),
  CONSTRAINT `bid_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `endUser` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Bid`
--

LOCK TABLES `Bid` WRITE;
/*!40000 ALTER TABLE `Bid` DISABLE KEYS */;
/*!40000 ALTER TABLE `Bid` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerSupport`
--

DROP TABLE IF EXISTS `customerSupport`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `customerSupport` (
  `userId` int NOT NULL AUTO_INCREMENT,
  `fName` varchar(50) NOT NULL,
  `lName` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `pw` varchar(200) NOT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerSupport`
--

LOCK TABLES `customerSupport` WRITE;
/*!40000 ALTER TABLE `customerSupport` DISABLE KEYS */;
INSERT INTO `customerSupport` VALUES (1,'John','Doe','john.doe@gmail.com','csPassword');
/*!40000 ALTER TABLE `customerSupport` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `endUser`
--

DROP TABLE IF EXISTS `endUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `endUser` (
  `userId` int NOT NULL AUTO_INCREMENT,
  `fName` varchar(50) NOT NULL,
  `lName` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `pw` varchar(200) NOT NULL,
  PRIMARY KEY (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endUser`
--

LOCK TABLES `endUser` WRITE;
/*!40000 ALTER TABLE `endUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `endUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Item`
--

DROP TABLE IF EXISTS `Item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `Item` (
  `itemId` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `isSold` tinyint(1) NOT NULL DEFAULT '0',
  `userId` int NOT NULL,
  PRIMARY KEY (`itemId`),
  KEY `userId` (`userId`),
  CONSTRAINT `item_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `endUser` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Item`
--

LOCK TABLES `Item` WRITE;
/*!40000 ALTER TABLE `Item` DISABLE KEYS */;
/*!40000 ALTER TABLE `Item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ItemAttribute`
--

DROP TABLE IF EXISTS `ItemAttribute`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `ItemAttribute` (
  `attributeValue` varchar(100) NOT NULL,
  `itemId` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `catName` varchar(50) NOT NULL,
  PRIMARY KEY (`name`,`catName`,`itemId`),
  KEY `itemId` (`itemId`),
  CONSTRAINT `itemattribute_ibfk_1` FOREIGN KEY (`name`, `catName`) REFERENCES `AttributeName` (`name`, `catName`),
  CONSTRAINT `itemattribute_ibfk_2` FOREIGN KEY (`itemId`) REFERENCES `Item` (`itemId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ItemAttribute`
--

LOCK TABLES `ItemAttribute` WRITE;
/*!40000 ALTER TABLE `ItemAttribute` DISABLE KEYS */;
/*!40000 ALTER TABLE `ItemAttribute` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ItemUser`
--

DROP TABLE IF EXISTS `ItemUser`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `ItemUser` (
  `itemId` int NOT NULL,
  `userId` int DEFAULT NULL,
  PRIMARY KEY (`itemId`),
  KEY `userId` (`userId`),
  CONSTRAINT `itemuser_ibfk_1` FOREIGN KEY (`itemId`) REFERENCES `Item` (`itemId`),
  CONSTRAINT `itemuser_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `endUser` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ItemUser`
--

LOCK TABLES `ItemUser` WRITE;
/*!40000 ALTER TABLE `ItemUser` DISABLE KEYS */;
/*!40000 ALTER TABLE `ItemUser` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SubCategoryType`
--

DROP TABLE IF EXISTS `SubCategoryType`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `SubCategoryType` (
  `name` varchar(50) NOT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SubCategoryType`
--

LOCK TABLES `SubCategoryType` WRITE;
/*!40000 ALTER TABLE `SubCategoryType` DISABLE KEYS */;
INSERT INTO `SubCategoryType` VALUES ('Bike'),('Bus'),('Car');
/*!40000 ALTER TABLE `SubCategoryType` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserHasAlert`
--

DROP TABLE IF EXISTS `UserHasAlert`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
 SET character_set_client = utf8mb4 ;
CREATE TABLE `UserHasAlert` (
  `alertSettingsId` int NOT NULL,
  `userId` int NOT NULL,
  PRIMARY KEY (`alertSettingsId`,`userId`),
  KEY `userId` (`userId`),
  CONSTRAINT `userhasalert_ibfk_1` FOREIGN KEY (`alertSettingsId`) REFERENCES `AlertSettings` (`alertSettingsId`),
  CONSTRAINT `userhasalert_ibfk_2` FOREIGN KEY (`userId`) REFERENCES `endUser` (`userId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserHasAlert`
--

LOCK TABLES `UserHasAlert` WRITE;
/*!40000 ALTER TABLE `UserHasAlert` DISABLE KEYS */;
/*!40000 ALTER TABLE `UserHasAlert` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-03-24 21:11:31
