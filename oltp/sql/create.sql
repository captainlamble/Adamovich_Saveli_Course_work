DROP TABLE IF EXISTS staging_cruiselines;
CREATE TEMP TABLE staging_cruiselines
(
    cruisline_name VARCHAR(100) PRIMARY KEY,
    contact_email  VARCHAR(100),
    contact_phone  VARCHAR(15)
);
COPY staging_cruiselines FROM '/scripts/cruiselines_data.csv' DELIMITER ',' CSV HEADER;
INSERT INTO oltp.cruiselines (cruisline_name, contact_email, contact_phone)
SELECT cruisline_name, contact_email, contact_phone
FROM staging_cruiselines
ON CONFLICT (cruisline_name) DO NOTHING;

DROP TABLE IF EXISTS staging_ports;
CREATE TEMP TABLE staging_ports
(
    port_code VARCHAR(3) PRIMARY KEY,
    port_name VARCHAR(100),
    city      VARCHAR(100),
    country   VARCHAR(100)
);
COPY staging_ports FROM '/scripts/ports_data.csv' DELIMITER ',' CSV HEADER;
INSERT INTO oltp.ports (port_code, port_name, city, country)
SELECT port_code, port_name, city, country
FROM staging_ports
ON CONFLICT (port_code) DO NOTHING;

DROP TABLE IF EXISTS staging_customers;
CREATE TEMP TABLE staging_customers
(
    passport_number VARCHAR(20) PRIMARY KEY,
    first_name      VARCHAR(50),
    last_name       VARCHAR(50),
    email           VARCHAR(100),
    phone_number    VARCHAR(15)
);
COPY staging_customers FROM '/scripts/customers_data.csv' DELIMITER ',' CSV HEADER;
INSERT INTO oltp.customers (passport_number, first_name, last_name, email, phone_number)
SELECT passport_number, first_name, last_name, email, phone_number
FROM staging_customers
ON CONFLICT (passport_number) DO NOTHING;

DROP TABLE IF EXISTS staging_cruises;
CREATE TEMP TABLE staging_cruises
(
    cruise_number       VARCHAR(10) PRIMARY KEY,
    cruiseline_name     VARCHAR(100),
    departure_port_code CHAR(3),
    arrival_port_code   CHAR(3),
    departure_time      TIMESTAMP,
    arrival_time        TIMESTAMP,
    base_price          DECIMAL(10, 2)
);
COPY staging_cruises FROM '/scripts/cruises_data.csv' DELIMITER ',' CSV HEADER;
INSERT INTO oltp.cruises (cruise_number, cruiseline_name, departure_port_code, arrival_port_code,
                          departure_time, arrival_time, base_price)
SELECT cruise_number, cruiseline_name, departure_port_code, arrival_port_code, departure_time, arrival_time, base_price
FROM staging_cruises
ON CONFLICT (cruise_number) DO NOTHING;

DROP TABLE IF EXISTS staging_cabins;
CREATE TEMP TABLE staging_cabins
(
    cabin_number VARCHAR(255) PRIMARY KEY,
    seat_number  VARCHAR(255),
    is_available BOOLEAN
);
COPY staging_cabins FROM '/scripts/cabins_data.csv' DELIMITER ',' CSV HEADER;
INSERT INTO oltp.cabins (cabin_number, seat_number, is_available)
SELECT cabin_number, seat_number, is_available
FROM staging_cabins
ON CONFLICT (cabin_number) DO NOTHING;

DROP TABLE IF EXISTS staging_cruise_seats;
CREATE TEMP TABLE staging_cruise_seats
(
    cruise_number VARCHAR(10),
    cabin_number  VARCHAR(10),
    cabin_class   VARCHAR(20),
    PRIMARY KEY (cruise_number, cabin_number)
);
COPY staging_cruise_seats FROM '/scripts/cruiseseats_data.csv' DELIMITER ',' CSV HEADER;
INSERT INTO oltp.cruise_seats (cruise_number, cabin_number, cabin_class)
SELECT cruise_number, cabin_number, cabin_class
FROM staging_cruise_seats
ON CONFLICT (cruise_number, cabin_number) DO NOTHING;

DROP TABLE IF EXISTS staging_bookings;
CREATE TEMP TABLE staging_bookings
(
    booking_id      VARCHAR(20) PRIMARY KEY,
    passport_number VARCHAR(20),
    cruise_number   VARCHAR(30),
    seat_number     VARCHAR(30),
    booking_date    TIMESTAMP,
    status          VARCHAR(20)
);
COPY staging_bookings FROM '/scripts/bookings_data.csv' DELIMITER ',' CSV HEADER;
INSERT INTO oltp.bookings (booking_id, passport_number, cruise_number, seat_number, booking_date, status)
SELECT booking_id, passport_number, cruise_number, seat_number, booking_date, status
FROM staging_bookings
ON CONFLICT (booking_id) DO NOTHING;

DROP TABLE IF EXISTS staging_payments;
CREATE TEMP TABLE staging_payments
(
    payment_id      VARCHAR(20) PRIMARY KEY,
    booking_id      VARCHAR(20),
    passport_number VARCHAR(20),
    cruise_number   VARCHAR(20),
    seat_number     VARCHAR(20),
    payment_date    TIMESTAMP,
    amount          DECIMAL(10, 2),
    payment_method  VARCHAR(20),
    payment_status  VARCHAR(20)
);
COPY staging_payments FROM '/scripts/payments_data.csv' DELIMITER ',' CSV HEADER;
INSERT INTO oltp.payments (payment_id, booking_id, passport_number, cruise_number, seat_number, payment_date, amount,
                           payment_method, payment_status)
SELECT payment_id,
       booking_id,
       passport_number,
       cruise_number,
       seat_number,
       payment_date,
       amount,
       payment_method,
       payment_status
FROM staging_payments
ON CONFLICT (payment_id) DO NOTHING;

DROP TABLE IF EXISTS staging_cruises_ports;
CREATE TEMP TABLE staging_cruises_ports
(
    id BIGINT primary key,
    cruise_number VARCHAR(10),
    inter_port_code varchar(3)
);
COPY staging_cruises_ports FROM '/scripts/cruises_ports_data.csv' DELIMITER ',' CSV HEADER;
INSERT INTO oltp.cruises_ports (id, cruise_number, inter_port_code)
SELECT id, cruise_number, inter_port_code
FROM staging_cruises_ports
ON CONFLICT (id) DO NOTHING;
