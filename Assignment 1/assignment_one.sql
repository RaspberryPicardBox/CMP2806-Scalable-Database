DROP DATABASE IF EXISTS delivery;
CREATE DATABASE delivery;

USE delivery;

CREATE TABLE Driver (
	DriverID INT PRIMARY KEY AUTO_INCREMENT,
	First_Name VARCHAR(255) NOT NULL,
	Last_Name VARCHAR(255) NOT NULL,
	MobileNo VARCHAR(11) NOT NULL,
	ParcelsShift INT,
	ParcelsTotal INT,
    Shift VARCHAR(255) NOT NULL
	);
	
CREATE TABLE Vehicle (
    VehicleID INT PRIMARY KEY AUTO_INCREMENT,
	DriverID INT,
    RegistrationNo VARCHAR(7) NOT NULL,
    FOREIGN KEY (DriverID) REFERENCES driver(DriverID)
    );
	
CREATE TABLE Location (
	VehicleID INT,
	Latitude FLOAT NOT NULL,
    Longitude FLOAT NOT NULL,
	Date_Time DATETIME NOT NULL,
	FOREIGN KEY (VehicleID) REFERENCES vehicle(VehicleID)
	);
	
INSERT INTO `driver`(`First_Name`, `Last_Name`, `MobileNo`, `ParcelsShift`, `ParcelsTotal`, `Shift`) VALUES 
	("Ayush","Rigby",07700900380,3,79,"Morning"),
	("Antonina","Madden",01144960587,4,87,"Afternoon"),
	("Neriah","Huerta",01144960587,4,100,"Afternoon"),
	("Alysia","Villanueva",01414960432,2,77,"Afternoon"),
	("Leja","Cottrel",01134960747,1,91,"Morning"),
	("Nimrah","Healy",01214960968,6,65,"Morning"),
	("Ruairidh","Clegg",01134960511,3,78,"Afternoon"),
	("Willis","Lester",02079460708,2,61,"Morning"),
	("Mindy","Whitehouse",01174960951,2,52,"Afternoon"),
	("Aneesa","Bradley",02079460381,1,55,"Morning");
	
INSERT INTO `vehicle`(`DriverID`, `RegistrationNo`) VALUES 
	(1,"MW72BAD"),
	(4,"FA04QQX"),
	(8,"QW37JHG"),
	(5,"MP43STH"),
	(2,"WQ30SXO");
	
INSERT INTO `location`(`VehicleID`, `Latitude`, `Longitude`, `Date_Time`) VALUES 
	(1,51.426233,0.109845,'2021-01-01 08:25:12'),
	(1,58.218757,-6.386288,'2021-01-01 09:39:25'),
	(1,50.900825,-3.501539,'2021-01-01 09:42:01'),
	(3,55.328069,-1.598804,'2021-01-01 10:15:34'),
	(3,53.533919,-2.410258,'2021-01-01 10:36:26'),
	(4,51.771438,0.104673,'2021-01-01 11:45:09'),
	(2,51.301918,-0.583171,'2021-01-01 12:30:25'),
	(2,53.388765,-2.250728,'2021-01-01 15:26:08'),
	(5,	52.444579,-2.21992,'2021-01-01 15:45:25');
	
SELECT driver.*, vehicle.VehicleID, vehicle.RegistrationNo, location.Date_Time from driver 
INNER JOIN vehicle ON driver.DriverID = vehicle.DriverID
INNER JOIN location ON location.VehicleID = vehicle.VehicleID WHERE location.Date_Time >= '2021-01-01 09:00:00' AND location.Date_Time < '2021-01-01 10:00:00'; #--Find between two seperate dates and times

SELECT `driver`.* FROM `driver` WHERE `driver`.`ParcelsShift` > 2;

SELECT `driver`.* FROM `driver`;

SELECT `driver`.* FROM `driver` WHERE `driver`.`Shift` = "Morning";

DROP PROCEDURE IF EXISTS findDriverAtTime;
DELIMITER //

CREATE PROCEDURE findDriverAtTime ( IN timeOne DateTime, IN timeTwo DateTime ) #--Same as query one, except in procedure form and takes user input
BEGIN
	SELECT driver.*, vehicle.VehicleID, vehicle.RegistrationNo, location.Date_Time from driver 
INNER JOIN vehicle ON driver.DriverID = vehicle.DriverID
INNER JOIN location ON location.VehicleID = vehicle.VehicleID WHERE location.Date_Time >= timeOne AND location.Date_Time < timeTwo;
END//

DELIMITER ;

CALL findDriverAtTime('2021-01-01 09:00:00', '2021-01-01 10:00:00');

DROP PROCEDURE IF EXISTS findDriverWithPackages; #--Finds any drivers who have delivered more than the specified number of parcels in one day
DELIMITER //

CREATE PROCEDURE findDriverWithPackages ( IN packageNum int )
BEGIN
	SELECT driver.* FROM driver WHERE driver.ParcelsShift > packageNum;
END//

DELIMITER ;

CALL findDriverWithPackages(2);

DROP PROCEDURE IF EXISTS findAllDrivers;
DELIMITER //

CREATE PROCEDURE findAllDrivers ()

BEGIN
	SELECT * FROM driver;
END//

DELIMITER ;

CALL findAllDrivers();

DROP PROCEDURE IF EXISTS findShift; #--Only takes "Morning" and "Afternoon" as inputs
DELIMITER //

CREATE PROCEDURE findShift ( IN shift varchar(255) )

BEGIN
	SELECT * FROM driver WHERE driver.Shift = shift;
END//

DELIMITER ;

CALL findShift("Morning");

DROP PROCEDURE IF EXISTS dropOffCount; #--An extra procedure to find the number of parcels delivered by any driver, using their driverID
DELIMITER //

CREATE PROCEDURE dropOffCount( IN driverIDNum int )
BEGIN
	SELECT COUNT(*) from driver INNER JOIN vehicle ON driver.DriverID = vehicle.DriverID INNER JOIN location ON location.VehicleID = vehicle.VehicleID WHERE driver.DriverID = driverIDNum;
END//

DELIMITER ;

CALL dropOffCount(1);

#--Create a new user with a password to edit this database
FLUSH PRIVILEGES;
DROP USER 'databaseUser'@'localhost';
CREATE USER 'databaseUser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON `delivery`.* TO 'databaseUser'@'localhost';
FLUSH PRIVILEGES;