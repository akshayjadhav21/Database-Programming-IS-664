use sync;

CREATE TABLE IF NOT EXISTS `sync`.`ACCESSRULE` (
  `ar_id` INT NOT NULL AUTO_INCREMENT,
  `role` VARCHAR(15) NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  `component` VARCHAR(10) NOT NULL,
  `request_type` VARCHAR(10) NOT NULL,
  `requestor` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`ar_id`),
  UNIQUE INDEX `ar_id_UNIQUE` (`ar_id` ASC) VISIBLE)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `sync`.`MODEL` (
  `m_id` INT NOT NULL AUTO_INCREMENT,
  `time` DATETIME  NOT NULL,
  `requestor` VARCHAR(20) NOT NULL,
  `role` VARCHAR(15) NOT NULL,
  `component` VARCHAR(10) NOT NULL,
  `request_type` VARCHAR(10) NOT NULL,
  `violation_type` VARCHAR(30) NOT NULL,
  `score` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`m_id`),
  UNIQUE INDEX `m_id_UNIQUE` (`m_id` ASC) VISIBLE)
ENGINE = InnoDB;



CREATE TABLE IF NOT EXISTS `sync`.`DISCREPANCY` (
  `d_id` INT NOT NULL AUTO_INCREMENT,
  `m_id` INT NOT NULL,
  `ar_id` INT NOT NULL,
  `time` DATETIME NOT NULL,
  `requestor` VARCHAR(20) NOT NULL,
  `role` VARCHAR(15) NOT NULL,
  `component` VARCHAR(10) NOT NULL,
  `request_type` VARCHAR(10) NOT NULL,
  `violation_type` VARCHAR(20) NOT NULL,
  `score` VARCHAR(5) NOT NULL,
  PRIMARY KEY (`d_id`),
  INDEX `m_id_idx` (`m_id` ASC) VISIBLE,
  INDEX `ar_id_idx` (`ar_id` ASC) VISIBLE,
  CONSTRAINT `m_id`
    FOREIGN KEY (`m_id`)
    REFERENCES `sync`.`MODEL` (`m_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ar_id`
    FOREIGN KEY (`ar_id`)
    REFERENCES `sync`.`ACCESSRULE` (`ar_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `sync`.`Comparison` (
  `A_ar_id` INT NOT NULL,
  `M_m_id` INT NULL,
  INDEX `fk_m_id_idx` (`M_m_id` ASC) VISIBLE,
  CONSTRAINT `fk_ar_id`
    FOREIGN KEY (`A_ar_id`)
    REFERENCES `sync`.`ACCESSRULE` (`ar_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_m_id`
    FOREIGN KEY (`M_m_id`)
    REFERENCES `sync`.`MODEL` (`m_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;