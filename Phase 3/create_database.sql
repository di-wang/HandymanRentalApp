/*** Create Database ***/
CREATE DATABASE HandymanTools;
USE HandymanTools;

/*** Create Tables ***/
CREATE TABLE Customer(
	Email varchar(36) NOT NULL,
	Password varchar(20) NOT NULL,
	FirstName varchar(25) NOT NULL,
	LastName varchar(40) NOT NULL,
	WorkPhoneAreaCode char(3) NOT NULL,
	WorkPhoneLocalNumber char(7) NOT NULL,
	HomePhoneAreaCode char(3) NOT NULL,
	HomePhoneLocalNumber char(7) NOT NULL,
	Address varchar(50) NOT NULL,
	PRIMARY KEY (Email));

CREATE TABLE Clerk(
	Login varchar(16) NOT NULL,
	Password varchar(20) NOT NULL,
	FirstName varchar(25) NOT NULL,
	LastName varchar(40) NOT NULL,
	PRIMARY KEY (Login));

CREATE TABLE Reservation(
	ReservationNumber int NOT NULL,
	StartDate date NOT NULL,
	EndDate date NOT NULL,
	CHECK (StartDate <= EndDate),
	CustomerLogin varchar(36) NOT NULL,
	PickupClerkLogin varchar(16) NULL,
	DropoffClerkLogin varchar(16) NULL,
	PickupDate date NULL,
	DropoffDate date NULL,
	CreditCardNumber char(16) NULL,
	CreditCardExpirationDate date NULL,
	PRIMARY KEY(ReservationNumber),
	FOREIGN KEY(CustomerLogin)
		REFERENCES Customer (Email),
	FOREIGN KEY(PickupClerkLogin)
		REFERENCES Clerk (Login),
	FOREIGN KEY(DropoffClerkLogin)
		REFERENCES Clerk (Login));

CREATE TABLE Tool(
	ToolID int NOT NULL,
	ToolType enum('Power Tool', 'Hand Tool', 'Construction Equipment') NOT NULL,
	AbbrDescription varchar(25) NOT NULL,
	FullDescription varchar(300) NOT NULL,
	PurchasePrice decimal(6, 2) NOT NULL CHECK (PurchasePrice >= 0),
	DailyRentalPrice decimal(6, 2) NOT NULL CHECK (DailyRentalPrice >= 0),
	Deposit decimal(6, 2) NOT NULL CHECK (Deposit >= 0),
	AddClerkLogin varchar(16) NOT NULL,
	SellClerkLogin varchar(16) NULL,
	SaleDate date NULL,
	SalePrice decimal(6, 2) NULL CHECK (SalePrice >= 0),
	PRIMARY KEY (ToolID),
	FOREIGN KEY (AddClerkLogin)
		REFERENCES Clerk (Login),
	FOREIGN KEY (SellClerkLogin)
		REFERENCES Clerk (Login));

CREATE TABLE ReservationReservesTool(
	ReservationNumber int NOT NULL,
	ToolID int NOT NULL,
	PRIMARY KEY (ReservationNumber, ToolID),
	FOREIGN KEY (ToolID)
	    REFERENCES Tool (ToolID),
	FOREIGN KEY (ReservationNumber)
	    REFERENCES Reservation (ReservationNumber));

CREATE TABLE PowerToolAccessories(
	ToolID int NOT NULL,
	Accessory varchar(25) NOT NULL,
	PRIMARY KEY(ToolID, Accessory),
	FOREIGN KEY (ToolID)
	    REFERENCES Tool (ToolID));

CREATE TABLE ServiceRequest(
	HoldClerkLoginKey varchar(16) NOT NULL,
	ToolID int NOT NULL,
	StartDate date NOT NULL,
	EndDate date NOT NULL,
	CHECK (StartDate <= EndDate),
	EstimateRepairCost decimal(6, 2) NOT NULL CHECK (EstimateRepairCost >= 0),
	PRIMARY KEY (HoldClerkLoginKey, ToolID, StartDate),
	FOREIGN KEY (HoldClerkLoginKey)
		REFERENCES Clerk (Login),
	FOREIGN KEY (ToolID)
		REFERENCES Tool (ToolID));

/* Insert data */
INSERT INTO Customer VALUES('user1@gatech.edu', 'user1', 'John', 'Smith', '865', '7346592', '865', '3874529','2763 Ave');
INSERT INTO Customer VALUES('user2@gatech.edu', 'user2', 'Jane', 'Smith', '865', '8347562', '865', '7462043','2762 Ave');
INSERT INTO Customer VALUES('user3@gatech.edu', 'user3', 'Bob', 'Smith', '865', '3874280', '865', '0384624','2764 Ave');
INSERT INTO Clerk VALUES('Sue123', 'Sue123', 'Sue', 'Smith');
INSERT INTO Clerk VALUES('Ash456', 'Ash456', 'Ash', 'Patel');
INSERT INTO Tool VALUES(1, 'Power Tool', 'Table Saw', '15 Amp 10 in. Heavy-Duty Portable Table Saw with Stand', 400, 20, 250, 'Sue123', null, null, null);
INSERT INTO Tool VALUES(2, 'Hand Tool', 'Wrench Set', 'Double Speed Adjustable Wrench Set (3-Piece)', 15, 2, 10, 'Ash456', null, null, null);
INSERT INTO Tool VALUES(3, 'Hand Tool', 'Hand Saw', '12 in. High-Tension Hack Saw with Mini Hack Saw', 16, 2, 14, 'Ash456', null, null, null);
INSERT INTO Tool VALUES(4, 'Construction Equipment', 'Crane', '2008 GROVE RT890E 90 Ton 4x4x4 Rough Terrain Crane', 9000, 950, 2400, 'Sue123', null, null, null);
INSERT INTO Tool VALUES(5, 'Construction Equipment', 'Hydraulic Excavator', 'CATERPILLAR 320EL Hydraulic Excavator heavy construction equipment', 8000, 400, 3500,'Ash456', null, null, null);
INSERT INTO Tool VALUES(6, 'Construction Equipment', 'Dump trailer', 'Dump Trailer 6X12 Landscape Construction Equipment Gooseneck Heavy Duty', 6000, 300, 4000, 'Sue123', 'Sue123', '2016-03-28', 3000);

INSERT INTO PowerToolAccessories VALUES(1, 'Push Blocks');
INSERT INTO PowerToolAccessories VALUES(1, 'Gauge');
INSERT INTO Reservation VALUES(1, '2016-4-1','2016-4-3','user1@gatech.edu', 'Ash456', 'Sue123', '2016-4-1','2016-4-3','8374248372659274', '2018-07-00');
INSERT INTO Reservation VALUES(2, '2016-4-21', '2016-4-26','user2@gatech.edu', 'Sue123', null, '2016-4-21', null, '8476302998462304','2020-10-00');
INSERT INTO Reservation VALUES(3, '2016-4-10', '2016-4-20','user3@gatech.edu', 'Ash456', 'Sue123', '2016-4-10', '2016-4-20', '7264928374649283','2020-10-00');
INSERT INTO Reservation VALUES(4, '2016-3-1', '2016-3-3', 'user3@gatech.edu', 'Ash456', 'Sue123', '2016-3-1', '2016-3-3','7264928374649283','2020-10-00');
INSERT INTO Reservation VALUES(5, '2016-5-1', '2016-5-3', 'user2@gatech.edu', null, null, null, null,null,null);
INSERT INTO Reservation VALUES(6, '2016-4-25', '2016-6-25', 'user1@gatech.edu', null, null, null, null,null,null);
INSERT INTO Reservation VALUES(7, '2016-3-24', '2016-3-29','user3@gatech.edu', 'Ash456', 'Ash456', '2016-3-24', '2016-3-29', '7264928374649283','2020-10-00');
INSERT INTO Reservation VALUES(8, '2016-5-26', '2016-6-1','user2@gatech.edu', null, null, null, null,null,null);
INSERT INTO ReservationReservesTool VALUES(1, 2);
INSERT INTO ReservationReservesTool VALUES(1, 3);
INSERT INTO ReservationReservesTool VALUES(2, 1);
INSERT INTO ReservationReservesTool VALUES(2, 2);
INSERT INTO ReservationReservesTool VALUES(2, 3);
INSERT INTO ReservationReservesTool VALUES(3, 4);
INSERT INTO ReservationReservesTool VALUES(4, 1);
INSERT INTO ReservationReservesTool VALUES(4, 5);
INSERT INTO ReservationReservesTool VALUES(4, 6);
INSERT INTO ReservationReservesTool VALUES(4, 2);
INSERT INTO ReservationReservesTool VALUES(4, 4);
INSERT INTO ReservationReservesTool VALUES(5, 4);
INSERT INTO ReservationReservesTool VALUES(5, 2);
INSERT INTO ReservationReservesTool VALUES(6, 1);
INSERT INTO ReservationReservesTool VALUES(7, 1);
INSERT INTO ReservationReservesTool VALUES(7, 2);
INSERT INTO ReservationReservesTool VALUES(7, 3);
INSERT INTO ReservationReservesTool VALUES(7, 5);
INSERT INTO ReservationReservesTool VALUES(8, 4);
INSERT INTO ReservationReservesTool VALUES(8, 2);
INSERT INTO ReservationReservesTool VALUES(8, 3);
INSERT INTO ServiceRequest VALUES('Ash456', 3, '2016-2-3', '2016-2-18', 5);
