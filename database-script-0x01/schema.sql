-- AirBnB Database Schema (MySQL 8.x)
-- Create database (optional)
-- CREATE DATABASE IF NOT EXISTS airbnb_db DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
-- USE airbnb_db;

-- For consistency
SET NAMES utf8mb4;
SET time_zone = '+00:00';

-- Drop in dependency order (child -> parent)
DROP TABLE IF EXISTS Message;
DROP TABLE IF EXISTS Review;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS User;

-- USER
CREATE TABLE User (
  user_id       CHAR(36)     NOT NULL DEFAULT (UUID()),
  first_name    VARCHAR(100) NOT NULL,
  last_name     VARCHAR(100) NOT NULL,
  email         VARCHAR(255) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  phone_number  VARCHAR(30)  NULL,
  role          ENUM('guest','host','admin') NOT NULL,
  created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (user_id),
  UNIQUE KEY uk_user_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PROPERTY
CREATE TABLE Property (
  property_id   CHAR(36)     NOT NULL DEFAULT (UUID()),
  host_id       CHAR(36)     NOT NULL,
  name          VARCHAR(150) NOT NULL,
  description   TEXT         NOT NULL,
  location      VARCHAR(255) NOT NULL,
  pricepernight DECIMAL(10,2) NOT NULL,
  created_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (property_id),
  KEY idx_property_host (host_id),
  CONSTRAINT fk_property_host
    FOREIGN KEY (host_id) REFERENCES User(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- BOOKING
CREATE TABLE Booking (
  booking_id  CHAR(36)     NOT NULL DEFAULT (UUID()),
  property_id CHAR(36)     NOT NULL,
  user_id     CHAR(36)     NOT NULL,
  start_date  DATE         NOT NULL,
  end_date    DATE         NOT NULL,
  total_price DECIMAL(10,2) NOT NULL,
  status      ENUM('pending','confirmed','canceled') NOT NULL,
  created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (booking_id),
  KEY idx_booking_property (property_id),
  KEY idx_booking_user (user_id),
  CONSTRAINT fk_booking_property
    FOREIGN KEY (property_id) REFERENCES Property(property_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_booking_user
    FOREIGN KEY (user_id) REFERENCES User(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_booking_dates CHECK (start_date <= end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- PAYMENT
CREATE TABLE Payment (
  payment_id     CHAR(36)     NOT NULL DEFAULT (UUID()),
  booking_id     CHAR(36)     NOT NULL,
  amount         DECIMAL(10,2) NOT NULL,
  payment_date   TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  payment_method ENUM('credit_card','paypal','stripe') NOT NULL,
  PRIMARY KEY (payment_id),
  KEY idx_payment_booking (booking_id),
  CONSTRAINT fk_payment_booking
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- REVIEW
CREATE TABLE Review (
  review_id   CHAR(36)     NOT NULL DEFAULT (UUID()),
  property_id CHAR(36)     NOT NULL,
  user_id     CHAR(36)     NOT NULL,
  rating      INT          NOT NULL,
  comment     TEXT         NOT NULL,
  created_at  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (review_id),
  KEY idx_review_property (property_id),
  KEY idx_review_user (user_id),
  CONSTRAINT fk_review_property
    FOREIGN KEY (property_id) REFERENCES Property(property_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_review_user
    FOREIGN KEY (user_id) REFERENCES User(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- MESSAGE
CREATE TABLE Message (
  message_id   CHAR(36)   NOT NULL DEFAULT (UUID()),
  sender_id    CHAR(36)   NOT NULL,
  recipient_id CHAR(36)   NOT NULL,
  message_body TEXT       NOT NULL,
  sent_at      TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (message_id),
  KEY idx_msg_sender (sender_id),
  KEY idx_msg_recipient (recipient_id),
  CONSTRAINT fk_msg_sender
    FOREIGN KEY (sender_id) REFERENCES User(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_msg_recipient
    FOREIGN KEY (recipient_id) REFERENCES User(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT chk_msg_sender_recipient CHECK (sender_id <> recipient_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
