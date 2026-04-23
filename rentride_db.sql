-- ================================================================
--  RentRide — MySQL Database Schema + Seed Data
--  Version: 2.0
--
--  HOW TO IMPORT:
--    mysql -u root -p < rentride_db.sql
--    (or use phpMyAdmin / MySQL Workbench Import)
--
--  Admin login after import:
--    Email:    admin@rentride.in
--    Password: Admin@123
--
--  NOTE: The backend server ALSO auto-creates tables and
--        re-syncs the admin password on every startup,
--        so even if you import this file, the login will work.
-- ================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ── CREATE & SELECT DATABASE ────────────────────────────────
CREATE DATABASE IF NOT EXISTS `rentride`
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE `rentride`;

-- ── DROP TABLES (clean slate) ───────────────────────────────
DROP TABLE IF EXISTS `bookings`;
DROP TABLE IF EXISTS `vehicles`;
DROP TABLE IF EXISTS `users`;

-- ── USERS ───────────────────────────────────────────────────
CREATE TABLE `users` (
  `id`         INT AUTO_INCREMENT PRIMARY KEY,
  `name`       VARCHAR(100)  NOT NULL,
  `email`      VARCHAR(150)  NOT NULL UNIQUE,
  `password`   VARCHAR(255)  NOT NULL,
  `role`       ENUM('user','admin') NOT NULL DEFAULT 'user',
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Admin user
-- Password: Admin@123
-- Hash: bcrypt, cost=10  (the backend re-generates this on startup anyway)
INSERT INTO `users` (`name`, `email`, `password`, `role`) VALUES
('RentRide Admin', 'admin@rentride.in',
 '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
 'admin');

-- ── VEHICLES ────────────────────────────────────────────────
CREATE TABLE `vehicles` (
  `id`            INT AUTO_INCREMENT PRIMARY KEY,
  `name`          VARCHAR(150)  NOT NULL,
  `type`          ENUM('car','bike','suv','van','truck','scooter') NOT NULL,
  `brand`         VARCHAR(100)  DEFAULT NULL,
  `fuel_type`     ENUM('petrol','diesel','electric','hybrid') NOT NULL DEFAULT 'petrol',
  `seats`         INT           NOT NULL DEFAULT 5,
  `price_per_day` DECIMAL(10,2) NOT NULL,
  `image_url`     VARCHAR(500)  DEFAULT NULL,
  `location`      VARCHAR(150)  DEFAULT NULL,
  `availability`  TINYINT(1)    NOT NULL DEFAULT 1,
  `description`   TEXT          DEFAULT NULL,
  `created_at`    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `vehicles`
  (`name`,`type`,`brand`,`fuel_type`,`seats`,`price_per_day`,`image_url`,`location`,`availability`,`description`)
VALUES
('Swift Dzire',               'car',    'Maruti Suzuki','petrol',   5, 1200.00,'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=800','Mumbai',    1,'Comfortable sedan perfect for city and highway drives.'),
('Royal Enfield Classic 350', 'bike',   'Royal Enfield','petrol',   2,  800.00,'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800','Goa',       1,'Iconic motorcycle, perfect for road trips and coastal drives.'),
('Mahindra Thar',             'suv',    'Mahindra',     'diesel',   4, 2500.00,'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=800','Manali',    1,'Rugged off-roader built for mountain adventures.'),
('Toyota Innova Crysta',      'van',    'Toyota',       'diesel',   7, 3000.00,'https://images.unsplash.com/photo-1511527844068-006b95d162c2?w=800','Delhi',     1,'Spacious MPV ideal for family trips across India.'),
('Tata Nexon EV',             'car',    'Tata',         'electric', 5, 1800.00,'https://images.unsplash.com/photo-1593941707882-a5bba14938c7?w=800','Bengaluru', 1,'Eco-friendly electric SUV with long range.'),
('Honda Activa 6G',           'scooter','Honda',        'petrol',   2,  400.00,'https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800','Pune',      1,'Reliable scooter for daily city commutes.'),
('Force Traveller',           'van',    'Force',        'diesel',  12, 4500.00,'https://images.unsplash.com/photo-1502877338535-766e1452684a?w=800','Jaipur',    1,'Perfect for group travel and corporate outings.'),
('BMW 3 Series',              'car',    'BMW',          'petrol',   5, 6000.00,'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800','Mumbai',    1,'Luxury sedan for a premium travel experience.'),
('Hyundai Creta',             'suv',    'Hyundai',      'petrol',   5, 2000.00,'https://images.unsplash.com/photo-1607853202273-797f1c22a38e?w=800','Chennai',   1,'Popular compact SUV with great mileage and comfort.'),
('Bajaj Pulsar NS200',        'bike',   'Bajaj',        'petrol',   2,  600.00,'https://images.unsplash.com/photo-1449426468159-d96dbf08f19f?w=800','Hyderabad', 1,'Sporty naked motorcycle for thrill-seekers.'),
('Toyota Fortuner',           'suv',    'Toyota',       'diesel',   7, 5500.00,'https://images.unsplash.com/photo-1519641471654-76ce0107ad1b?w=800','Delhi',     1,'Full-size SUV with commanding presence for long road trips.'),
('Ather 450X',                'scooter','Ather',        'electric', 2,  500.00,'https://images.unsplash.com/photo-1571068316344-75bc76f77890?w=800','Bengaluru', 1,'Premium electric scooter with smart features and fast charging.');

-- ── BOOKINGS ────────────────────────────────────────────────
CREATE TABLE `bookings` (
  `id`              INT AUTO_INCREMENT PRIMARY KEY,
  `user_id`         INT           NOT NULL,
  `vehicle_id`      INT           NOT NULL,
  `start_date`      DATE          NOT NULL,
  `end_date`        DATE          NOT NULL,
  `total_price`     DECIMAL(10,2) NOT NULL,
  `status`          ENUM('pending','confirmed','cancelled','completed') NOT NULL DEFAULT 'confirmed',
  `pickup_location` VARCHAR(200)  DEFAULT NULL,
  `created_at`      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT `fk_booking_user`
    FOREIGN KEY (`user_id`)    REFERENCES `users`(`id`)    ON DELETE CASCADE,
  CONSTRAINT `fk_booking_vehicle`
    FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Sample booking history
INSERT INTO `bookings` (`user_id`,`vehicle_id`,`start_date`,`end_date`,`total_price`,`status`,`pickup_location`) VALUES
(1, 1, '2024-03-01', '2024-03-04',  3600.00, 'completed', 'Mumbai'),
(1, 3, '2024-03-10', '2024-03-13',  7500.00, 'completed', 'Manali'),
(1, 8, '2024-04-01', '2024-04-02',  6000.00, 'confirmed', 'Mumbai');

-- ── HELPER VIEW ─────────────────────────────────────────────
CREATE OR REPLACE VIEW `v_booking_details` AS
  SELECT
    b.id              AS booking_id,
    b.status,
    b.start_date,
    b.end_date,
    b.total_price,
    b.pickup_location,
    b.created_at      AS booked_at,
    u.id              AS user_id,
    u.name            AS user_name,
    u.email           AS user_email,
    v.id              AS vehicle_id,
    v.name            AS vehicle_name,
    v.type            AS vehicle_type,
    v.brand,
    v.price_per_day,
    v.image_url,
    v.location
  FROM bookings b
  JOIN users    u ON b.user_id    = u.id
  JOIN vehicles v ON b.vehicle_id = v.id;

SET FOREIGN_KEY_CHECKS = 1;

SELECT '✅ RentRide database imported successfully! Login: admin@rentride.in / Admin@123' AS status;
