CREATE DATABASE IF NOT EXISTS `email_validator`;
USE `email_validator`;


-- -----------------------------------------------------
-- Table `email_validator`
-- Variables for table:
-- * sql_id [int] - The unique identifier
-- * email  [string]
-- * id     [string]
-- * secret [string]
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `email_validator` (
    `sql_id` int NOT NULL AUTO_INCREMENT,
    `email` varchar(255) NOT NULL,
    `id` varchar(255) NOT NULL UNIQUE,
    `secret` varchar(255) NOT NULL,
    PRIMARY KEY (`sql_id`)
)