CREATE DATABASE IF NOT EXISTS `AuctionSite` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `AuctionSite`;
-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: cs336.ckksjtjg2jto.us-east-2.rds.amazonaws.com    Database: AuctionSite
-- ------------------------------------------------------
-- Server version	5.6.35-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `endUser`
--

DROP TABLE IF EXISTS endUser;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE endUser (
  userId int auto_increment primary key,
  fName varchar(50) NOT NULL,
  lName varchar(50) NOT NULL,
  email varchar(100) NOT NULL,
  pw varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
CREATE DATABASE IF NOT EXISTS `AuctionSite` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `AuctionSite`;
-- MySQL dump 10.13  Distrib 5.7.17, for macos10.12 (x86_64)
--
-- Host: cs336.ckksjtjg2jto.us-east-2.rds.amazonaws.com    Database: AuctionSite
-- ------------------------------------------------------
-- Server version	5.6.35-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `endUser`
--

DROP TABLE IF EXISTS endUser;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE endUser (
  userId int auto_increment primary key,
  fName varchar(50) NOT NULL,
  lName varchar(50) NOT NULL,
  email varchar(100) NOT NULL,
  pw varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Table structure for table `customerSupport`
--

DROP TABLE IF EXISTS customerSupport;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE customerSupport (
  userId int auto_increment primary key,
  fName varchar(50) NOT NULL,
  lName varchar(50) NOT NULL,
  email varchar(100) NOT NULL,
  pw varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Dumping data for table `customerSupport`
--

LOCK TABLES customerSupport WRITE;
/*!40000 ALTER TABLE customerSupport DISABLE KEYS */;
INSERT INTO customerSupport (fName, lName, email, pw)
VALUES ('John', 'Doe', 'john.doe@gmail.com', 'csPassword');
/*!40000 ALTER TABLE customerSupport ENABLE KEYS */;
UNLOCK TABLES;


--
-- Table structure for table `administrator`
--

DROP TABLE IF EXISTS administrator;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE administrator (
  userId int auto_increment primary key,
  fName varchar(50) NOT NULL,
  lName varchar(50) NOT NULL,
  email varchar(100) NOT NULL,
  pw varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;


--
-- Dumping data for table `administrator`
--

LOCK TABLES administrator WRITE;
/*!40000 ALTER TABLE administrator DISABLE KEYS */;
INSERT INTO administrator (fName, lName, email, pw)
VALUES ('Big', 'Shot', 'ceodude@coolauctions.com', 'adminPassword');
/*!40000 ALTER TABLE administrator ENABLE KEYS */;
UNLOCK TABLES;


DROP TABLE IF EXISTS SubCategoryType;
CREATE TABLE SubCategoryType (
	`name` varchar(50) NOT NULL,
    PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- domain is to store the type of attribute
-- domain can be 'int', 'string', 'double', or 'boolean'
DROP TABLE IF EXISTS AttributeName;
CREATE TABLE AttributeName (
	`name` varchar(50) NOT NULL,
    catName varchar(50) NOT NULL,
    `domain` varchar(50) NOT NULL default 'string',
    FOREIGN KEY (catName) references SubCategoryType (`name`),
    PRIMARY KEY (`name`, catName)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


LOCK TABLES SubCategoryType WRITE;
/*!40000 ALTER TABLE SubCategoryType DISABLE KEYS */;
INSERT INTO SubCategoryType (`name`)
VALUES ('Car'), ('Bike'), ('Bus');
/*!40000 ALTER TABLE SubCategoryType ENABLE KEYS */;
UNLOCK TABLES;

LOCK TABLES AttributeName WRITE;
/*!40000 ALTER TABLE AttributeName DISABLE KEYS */;
INSERT INTO AttributeName (`name`, catName, `domain`)
VALUES ('numWheels', 'Car', 'int'), ('doorCount', 'Car', 'int'), ('color', 'Car', 'string'), 
('weight', 'Car', 'double'), ('mpg', 'Bike', 'int'), ('seatCount', 'Bus', 'int');
/*!40000 ALTER TABLE AttributeName ENABLE KEYS */;
UNLOCK TABLES;


DROP table if exists Item;
CREATE TABLE Item (
	itemId int auto_increment primary key,
	`name` varchar(100) NOT NULL,
    isSold bool NOT NULL default false,
    /*onAuction bool NOT NULL default false,*/
    userId int NOT NULL,
    FOREIGN KEY (userId) references endUser (userId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


DROP TABLE IF EXISTS Auction;
CREATE TABLE Auction (
	auctionName varchar(100) NOT NULL,
    `description` varchar(1000)NOT NULL DEFAULT '',
    minPrice decimal(15,2) NOT NULL, 
    startPrice decimal(15,2) NOT NULL,
    incPrice decimal(15,2) NOT NULL,
    startingDateTime datetime NOT NULL,
    endingDateTime datetime NOT NULL,
    itemId int NOT NULL,
    auctionId int AUTO_INCREMENT PRIMARY KEY,
    FOREIGN KEY (itemId) references Item (itemId)
    
) ;

-- Table Structure for Bid -- 
DROP TABLE IF EXISTS Bid;
CREATE TABLE Bid (
	amount decimal(15,2) NOT NULL,
    bidDateTime datetime NOT NULL,
    auctionId int NOT NULL,
    userId int NOT NULL,
    PRIMARY KEY (auctionId, amount),
    FOREIGN KEY (auctionId) references Auction (auctionId),
    FOREIGN KEY (userId) references endUser (userId)
);

-- Table Structure for AlertSettings --
DROP TABLE IF EXISTS AlertSettings;
CREATE TABLE AlertSettings (
	alertSettingsId int AUTO_INCREMENT PRIMARY KEY,
    userId int,
    FOREIGN KEY (userId) references endUser (userId)
);

-- Table Structure for AutoBid --
DROP TABLE IF EXISTS AutoBid;
CREATE TABLE AutoBid (
	maxAmount decimal(15,2) NOT NULL,
    userID int NOT NULL,
    auctionId int NOT NULL,
    PRIMARY KEY (userId, auctionId),
    FOREIGN KEY (userId) references endUser (userId),
    FOREIGN KEY (auctionId) references Auction (auctionId)
);

DROP TABLE IF EXISTS Alert;
CREATE TABLE Alert (
	alertSettingsId int,
    auctionId int,
    PRIMARY KEY(alertSettingsId, auctionId),
    FOREIGN KEY (alertSettingsId) references AlertSettings (alertSettingsId),
    FOREIGN KEY (auctionId) references Auction (auctionId)
);

DROP TABLE IF EXISTS ItemAttribute;
CREATE TABLE ItemAttribute (
	attributeValue varchar(100) NOT NULL, -- string for now that we can parse and convert --
	itemId int,
    `name` varchar(50) NOT NULL,
    catName varchar(50) NOT NULL,
    PRIMARY KEY (`name`, catName, itemId),
    FOREIGN KEY (`name`, catName) references AttributeName (`name`, catName),
    FOREIGN KEY(itemId) references Item (itemId)
    
);

DROP TABLE IF EXISTS UserHasAlert;
CREATE TABLE UserHasAlert (
    alertSettingsId int,
    userId int,
    PRIMARY KEY (alertSettingsId, userId),
    FOREIGN KEY (alertSettingsId) references AlertSettings (alertSettingsId),
    FOREIGN KEY (userId) references endUser (userId)
);

DROP TABLE IF EXISTS AlertForAttributeName;
CREATE TABLE AlertForAttributeName (
    alertSettingsId int,
    `name` varchar(50) NOT NULL,
    catName varchar(50) NOT NULL,
    attributeValue varchar(100) NOT NULL,
    PRIMARY KEY (`name`, alertSettingsId, catName),
    FOREIGN KEY (alertSettingsId) references AlertSettings (alertSettingsId),
    FOREIGN KEY (`name`, catName) references AttributeName (`name`, catName)
);



