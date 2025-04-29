-- Creating DB --
CREATE DATABASE barcelona_housing;
USE barcelona_housing;

-- Creating table --
CREATE TABLE housing_data (
    id INT PRIMARY KEY,
    city VARCHAR(50),
    district VARCHAR(100),
    neighborhood VARCHAR(100),
    `condition` VARCHAR(50),
    type VARCHAR(50),
    rooms INT,
    area_m2 DECIMAL(10,2),
    lift VARCHAR(10),
    views VARCHAR(100),
    floor_number VARCHAR(50),
    price INT
);

-- Loading CSV --

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Barcelona_Housing_Prices_2020.csv'
INTO TABLE housing_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

