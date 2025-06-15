Create SCHEMA IF NOT EXISTS oltp;

CREATE TABLE oltp.cruiselines
(
    "cruisline_name" VARCHAR(100) NOT NULL,
    "contact_email"  VARCHAR(100) NULL,
    "contact_phone"  VARCHAR(15)  NULL
);
ALTER TABLE
    oltp.cruiselines
    ADD PRIMARY KEY ("cruisline_name");
CREATE TABLE oltp.ports
(
    "port_code" CHAR(3)      NOT NULL,
    "port_name" VARCHAR(100) NOT NULL,
    "city"      VARCHAR(100) NOT NULL,
    "country"   VARCHAR(100) NOT NULL
);
ALTER TABLE
    oltp.ports
    ADD PRIMARY KEY ("port_code");
CREATE TABLE oltp.cruises
(
    "cruise_number"       VARCHAR(10)                    NOT NULL,
    "cruiseline_name"     VARCHAR(100)                   NOT NULL,
    "departure_port_code" CHAR(3)                        NOT NULL,
    "arrival_port_code"   CHAR(3)                        NOT NULL,
    "departure_time"      TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "arrival_time"        TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "base_price"          DECIMAL(10, 2)                 NOT NULL
);
ALTER TABLE
    oltp.cruises
    ADD PRIMARY KEY ("cruise_number");
CREATE TABLE oltp.cruise_seats
(
    "cruise_number" VARCHAR(10) NOT NULL,
    "cabin_number"  VARCHAR(10) NOT NULL,
    "cabin_class"   VARCHAR(20) NOT NULL,
    PRIMARY KEY (cruise_number, cabin_number)
);
CREATE TABLE oltp.customers
(
    "passport_number" VARCHAR(20)  NOT NULL,
    "first_name"      VARCHAR(50)  NOT NULL,
    "last_name"       VARCHAR(50)  NOT NULL,
    "email"           VARCHAR(100) NOT NULL,
    "phone_number"    VARCHAR(15)  NOT NULL
);
ALTER TABLE
    oltp.customers
    ADD PRIMARY KEY ("passport_number");
ALTER TABLE
    oltp.customers
    ADD CONSTRAINT "customers_email_unique" UNIQUE ("email");
CREATE TABLE oltp.bookings
(
    "booking_id"      varchar(20)                    NOT NULL,
    "passport_number" VARCHAR(20)                    NOT NULL,
    "cruise_number"   VARCHAR(10)                    NOT NULL,
    "seat_number"     VARCHAR(10)                    NOT NULL,
    "booking_date"    TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "status"          VARCHAR(20)                    NOT NULL
);
ALTER TABLE
    oltp.bookings
    ADD CONSTRAINT "bookings_cruise_number_seat_number_unique" UNIQUE ("cruise_number", "seat_number");
ALTER TABLE
    oltp.bookings
    ADD PRIMARY KEY ("booking_id");
CREATE TABLE oltp.payments
(
    "payment_id"      varchar(20)                    NOT NULL,
    "booking_id"      varchar(20)                    NOT NULL,
    "passport_number" VARCHAR(20)                    NOT NULL,
    "cruise_number"   VARCHAR(10)                    NOT NULL,
    "seat_number"     VARCHAR(10)                    NOT NULL,
    "payment_date"    TIMESTAMP(0) WITHOUT TIME ZONE NOT NULL,
    "amount"          DECIMAL(10, 2)                 NOT NULL,
    "payment_method"  VARCHAR(20)                    NOT NULL,
    "payment_status"  VARCHAR(20)                    NOT NULL
);
ALTER TABLE
    oltp.payments
    ADD PRIMARY KEY ("payment_id");
CREATE TABLE oltp.cabins
(
    "cabin_number" VARCHAR(255) NOT NULL,
    "seat_number"  VARCHAR(255) NOT NULL,
    "is_available" BOOLEAN      NOT NULL DEFAULT '1'
);
ALTER TABLE
    oltp.cabins
    ADD PRIMARY KEY ("cabin_number");
CREATE TABLE oltp.cruises_ports
(
    "id"              Bigint PRIMARY KEY,
    "cruise_number"   VARCHAR(255) NOT NULL,
    "inter_port_code" CHAR(3)      NOT NULL
);
ALTER TABLE
    oltp.cruises_ports
    ADD FOREIGN KEY ("cruise_number") REFERENCES oltp.cruises ("cruise_number");
ALTER TABLE
    oltp.bookings
    ADD CONSTRAINT "bookings_cruise_number_foreign" FOREIGN KEY ("cruise_number") REFERENCES oltp.cruises ("cruise_number");
ALTER TABLE
    oltp.cruises_ports
    ADD CONSTRAINT "cruises_ports_inter_port_code_foreign" FOREIGN KEY ("inter_port_code") REFERENCES oltp.ports ("port_code");
ALTER TABLE
    oltp.payments
    ADD CONSTRAINT "payments_booking_id_foreign" FOREIGN KEY ("booking_id") REFERENCES oltp.bookings ("booking_id");
ALTER TABLE
    oltp.bookings
    ADD CONSTRAINT "bookings_passport_number_foreign" FOREIGN KEY ("passport_number") REFERENCES oltp.customers ("passport_number");
ALTER TABLE
    oltp.cruise_seats
    ADD CONSTRAINT "cruise_seats_cabin_number_foreign" FOREIGN KEY ("cabin_number") REFERENCES oltp.cabins ("cabin_number");
ALTER TABLE
    oltp.cruises
    ADD CONSTRAINT "cruises_arrival_port_code_foreign" FOREIGN KEY ("arrival_port_code") REFERENCES oltp.ports ("port_code");
ALTER TABLE
    oltp.cruises
    ADD CONSTRAINT "cruises_departure_port_code_foreign" FOREIGN KEY ("departure_port_code") REFERENCES oltp.ports ("port_code");
ALTER TABLE
    oltp.cruises
    ADD CONSTRAINT "cruises_cruiseline_name_foreign" FOREIGN KEY ("cruiseline_name") REFERENCES oltp.cruiselines ("cruisline_name");