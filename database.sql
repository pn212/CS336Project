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
VALUES ('Wheel Count', 'Car', 'int'), ('Door Count', 'Car', 'int'), ('Color', 'Car', 'string'), 
('Weight', 'Car', 'double'), ('MPG', 'Bike', 'int'), ('Seat Count', 'Bus', 'int');
/*!40000 ALTER TABLE AttributeName ENABLE KEYS */;
UNLOCK TABLES;

DROP table if exists Item;
CREATE TABLE Item (
	itemId int auto_increment primary key,
	`name` varchar(100) NOT NULL,
    -- itemStatus = 0 means the item has not been sold --
    -- itemStatus = 1 means the item has been sold --
    -- itemStatus = 2 means the item had an auction concluded but there was no winner -- 
    itemStatus int NOT NULL default 0,
    userId int,
    FOREIGN KEY (userId) references endUser (userId) ON DELETE SET NULL
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
    FOREIGN KEY (itemId) references Item (itemId) ON DELETE CASCADE
    
) ;

-- Table Structure for Bid -- 
DROP TABLE IF EXISTS Bid;
CREATE TABLE Bid (
	amount decimal(15,2) NOT NULL,
    bidDateTime datetime NOT NULL,
    auctionId int NOT NULL,
    userId int,
    PRIMARY KEY (auctionId, amount),
    FOREIGN KEY (auctionId) references Auction (auctionId) ON DELETE CASCADE,
    FOREIGN KEY (userId) references endUser (userId) ON DELETE SET NULL
);

-- Table Structure for AlertSettings --
DROP TABLE IF EXISTS AlertSettings;
CREATE TABLE AlertSettings (
	alertSettingsId int AUTO_INCREMENT PRIMARY KEY,
    userId int,
    FOREIGN KEY (userId) references endUser (userId) ON DELETE CASCADE
);

-- Table Structure for AutoBid --
DROP TABLE IF EXISTS AutoBid;
CREATE TABLE AutoBid (
	maxAmount decimal(15,2) NOT NULL,
    userID int NOT NULL,
    auctionId int NOT NULL,
    PRIMARY KEY (userId, auctionId),
    FOREIGN KEY (userId) references endUser (userId) ON DELETE CASCADE,
    FOREIGN KEY (auctionId) references Auction (auctionId)
);

DROP TABLE IF EXISTS Alert;
CREATE TABLE Alert(
	alertId int AUTO_INCREMENT primary key,
    userId int,
    alertMessage varchar(1000),
    alertDateTime datetime,
    alertRead bool NOT NULL default false,
    foreign key (userId) references endUser (userId) ON DELETE CASCADE
);

DROP TABLE IF EXISTS ItemAttribute;
CREATE TABLE ItemAttribute (
	attributeValue varchar(100) NOT NULL, -- string for now that we can parse and convert --
	itemId int,
    `name` varchar(50) NOT NULL,
    catName varchar(50) NOT NULL,
    PRIMARY KEY (`name`, catName, itemId),
    FOREIGN KEY (`name`, catName) references AttributeName (`name`, catName),
    FOREIGN KEY(itemId) references Item (itemId) ON DELETE CASCADE   
);

DROP TABLE IF EXISTS AlertForAttributeName;
CREATE TABLE AlertForAttributeName (
    alertSettingsId int,
    `name` varchar(50) NOT NULL,
    catName varchar(50) NOT NULL,
    attributeValue varchar(100) NOT NULL,
    PRIMARY KEY (`name`, alertSettingsId, catName),
    FOREIGN KEY (alertSettingsId) references AlertSettings (alertSettingsId) ON DELETE CASCADE,
    FOREIGN KEY (`name`, catName) references AttributeName (`name`, catName)
);


DROP TABLE IF EXISTS ForumPost;
CREATE TABLE ForumPost (
	postId int auto_increment,
	title varchar(50) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	description varchar(1000) NOT NULL,
	userId int,
	PRIMARY KEY (postId),
	FOREIGN KEY (userId) references EndUser (userId) ON DELETE SET NULL
);

DROP TABLE IF EXISTS ForumAnswer;
CREATE TABLE ForumAnswer (
	answerId int auto_increment,
    postId int NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	content varchar(1000) NOT NULL,
	userId int NOT NULL,
	PRIMARY KEY (answerId),
	FOREIGN KEY (userId) references CustomerSupport (userId),
    FOREIGN KEY (postId) references ForumPost (postId) ON DELETE CASCADE
);

DROP TABLE IF EXISTS ForumComment;
CREATE TABLE ForumComment (
	commentId int auto_increment,
    postId int NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	content varchar(1000) NOT NULL,
	userId int,
	PRIMARY KEY (commentId),
	FOREIGN KEY (userId) references EndUser (userId) ON DELETE SET NULL,
    FOREIGN KEY (postId) references ForumPost (postId) ON DELETE CASCADE
);
