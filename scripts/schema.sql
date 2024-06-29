CREATE DATABASE IF NOT EXISTS `email_validator`;
USE `email_validator`;


-- -----------------------------------------------------
-- Table `otp_session`
-- Variables for table:
-- * sql_id [int] - The unique identifier
-- * email  [string]
-- * id     [string]
-- * secret [string]
-- -----------------------------------------------------
CREATE TABLE `otp_session` (
    `sql_id` SERIAL integer NOT NULL,
    `email` varchar(255) NOT NULL,
    `id` varchar(255) NOT NULL UNIQUE,
    `secret` varchar(255) NOT NULL,
    PRIMARY KEY (`sql_id`)
)
