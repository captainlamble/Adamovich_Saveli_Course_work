CREATE TABLE "dim_cruisline"(
    "cruisline_id" INTEGER NOT NULL,
    "cruisline_name" VARCHAR(100) NOT NULL,
    "contact_email" VARCHAR(100) NULL,
    "contact_phone" VARCHAR(15) NULL
);
ALTER TABLE
    "dim_cruisline" ADD PRIMARY KEY("cruisline_id");
ALTER TABLE
    "dim_cruisline" ADD CONSTRAINT "dim_cruisline_cruisline_name_unique" UNIQUE("cruisline_name");
CREATE TABLE "dim_country"(
    "country_id" INTEGER NOT NULL,
    "name" VARCHAR(255) NULL
);
ALTER TABLE
    "dim_country" ADD PRIMARY KEY("country_id");
ALTER TABLE
    "dim_country" ADD CONSTRAINT "dim_country_name_unique" UNIQUE("name");
CREATE TABLE "dim_city"(
    "city_id" INTEGER NOT NULL,
    "country_id" INTEGER NULL,
    "name" VARCHAR(255) NULL
);
ALTER TABLE
    "dim_city" ADD PRIMARY KEY("city_id");
ALTER TABLE
    "dim_city" ADD CONSTRAINT "dim_city_name_unique" UNIQUE("name");
CREATE TABLE "dim_port"(
    "port_id" INTEGER NOT NULL,
    "city_id" INTEGER NULL,
    "port_code" CHAR(3) NOT NULL,
    "port_name" VARCHAR(100) NOT NULL
);
ALTER TABLE
    "dim_port" ADD PRIMARY KEY("port_id");
ALTER TABLE
    "dim_port" ADD CONSTRAINT "dim_port_port_code_unique" UNIQUE("port_code");
ALTER TABLE
    "dim_port" ADD CONSTRAINT "dim_port_port_name_unique" UNIQUE("port_name");
CREATE TABLE "dim_arrive_time"(
    "time_id" INTEGER NOT NULL,
    "date" DATE NOT NULL,
    "day_of_week" VARCHAR(20) NULL,
    "month" INTEGER NULL,
    "quarter" INTEGER NULL,
    "year" INTEGER NULL
);
ALTER TABLE
    "dim_arrive_time" ADD PRIMARY KEY("time_id");
ALTER TABLE
    "dim_arrive_time" ADD CONSTRAINT "dim_arrive_time_date_unique" UNIQUE("date");
CREATE TABLE "dim_departure_time"(
    "time_id" INTEGER NOT NULL,
    "date" DATE NOT NULL,
    "day_of_week" VARCHAR(20) NULL,
    "month" INTEGER NULL,
    "quarter" INTEGER NULL,
    "year" INTEGER NULL
);
ALTER TABLE
    "dim_departure_time" ADD PRIMARY KEY("time_id");
ALTER TABLE
    "dim_departure_time" ADD CONSTRAINT "dim_departure_time_date_unique" UNIQUE("date");
CREATE TABLE "dim_booking_time"(
    "time_id" INTEGER NOT NULL,
    "date" DATE NOT NULL,
    "day_of_week" VARCHAR(20) NULL,
    "month" INTEGER NULL,
    "quarter" INTEGER NULL,
    "year" INTEGER NULL
);
ALTER TABLE
    "dim_booking_time" ADD PRIMARY KEY("time_id");
ALTER TABLE
    "dim_booking_time" ADD CONSTRAINT "dim_booking_time_date_unique" UNIQUE("date");
CREATE TABLE "dim_payment_method"(
    "payment_method_id" INTEGER NOT NULL,
    "name" VARCHAR(20) NOT NULL
);
ALTER TABLE
    "dim_payment_method" ADD PRIMARY KEY("payment_method_id");
ALTER TABLE
    "dim_payment_method" ADD CONSTRAINT "dim_payment_method_name_unique" UNIQUE("name");
CREATE TABLE "dim_payment_status"(
    "payment_status_id" INTEGER NOT NULL,
    "name" VARCHAR(20) NOT NULL
);
ALTER TABLE
    "dim_payment_status" ADD PRIMARY KEY("payment_status_id");
ALTER TABLE
    "dim_payment_status" ADD CONSTRAINT "dim_payment_status_name_unique" UNIQUE("name");
CREATE TABLE "dim_cruise_booking_status"(
    "cruise_booking_status_id" INTEGER NOT NULL,
    "name" VARCHAR(20) NOT NULL
);
ALTER TABLE
    "dim_cruise_booking_status" ADD PRIMARY KEY("cruise_booking_status_id");
ALTER TABLE
    "dim_cruise_booking_status" ADD CONSTRAINT "dim_cruise_booking_status_name_unique" UNIQUE("name");
CREATE TABLE "dim_customer"(
    "customer_id" INTEGER NOT NULL,
    "passport_number" VARCHAR(20) NOT NULL,
    "first_name" VARCHAR(50) NOT NULL,
    "last_name" VARCHAR(50) NOT NULL,
    "email" VARCHAR(100) NOT NULL,
    "phone_number" VARCHAR(15) NOT NULL,
    "ts_created" DATE NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "ts_finished" DATE NULL,
    "is_current" BOOLEAN NOT NULL DEFAULT '1'
);
ALTER TABLE
    "dim_customer" ADD PRIMARY KEY("customer_id");
CREATE TABLE "dim_cruise"(
    "cruise_id" INTEGER NOT NULL,
    "cruisline_id" INTEGER NULL,
    "departure_port_id" INTEGER NULL,
    "arrival_port_id" INTEGER NULL,
    "departure_date" INTEGER NULL,
    "arrival_date" INTEGER NULL,
    "cruise_number" VARCHAR(10) NULL
);
ALTER TABLE
    "dim_cruise" ADD CONSTRAINT "dim_cruise_cruise_number_departure_date_arrival_date_unique" UNIQUE(
        "cruise_number",
        "departure_date",
        "arrival_date"
    );
ALTER TABLE
    "dim_cruise" ADD PRIMARY KEY("cruise_id");
CREATE TABLE "fact_booking"(
    "booking_id" varchar(20) NOT NULL,
    "customer_id" INTEGER NULL,
    "cruise_id" INTEGER NULL,
    "booking_date_id" INTEGER NULL,
    "payment_method_id" INTEGER NULL,
    "payment_status_id" INTEGER NULL,
    "cruise_booking_status_id" INTEGER NULL,
    "seat_number" VARCHAR(10) NULL,
    "total_amount" DECIMAL(10, 2) NULL
);
ALTER TABLE
    "fact_booking" ADD CONSTRAINT "fact_booking_customer_id_cruise_id_booking_date_id_unique" UNIQUE(
        "customer_id",
        "cruise_id",
        "booking_date_id"
    );
ALTER TABLE
    "fact_booking" ADD PRIMARY KEY("booking_id");
CREATE TABLE "fact_cruise"(
    "cruise_id" INTEGER NOT NULL,
    "cruisline_id" INTEGER NULL,
    "departure_port_id" INTEGER NULL,
    "arrival_port_id" INTEGER NULL,
    "departure_date" INTEGER NULL,
    "arrival_date" INTEGER NULL,
    "flight_number" VARCHAR(10) NULL,
    "total_seats" INTEGER NULL,
    "available_seats_first_class" INTEGER NULL,
    "available_seats_second_class" INTEGER NULL,
    "available_seats_third_class" INTEGER NULL,
    "sold_seats" INTEGER NULL,
    "popularity_index" DOUBLE PRECISION NULL,
    "total_cabins" INTEGER NULL,
    "available_cabins" INTEGER NULL
);
ALTER TABLE
    "fact_cruise" ADD CONSTRAINT "fact_cruise_flight_number_departure_date_arrival_date_unique" UNIQUE(
        "flight_number",
        "departure_date",
        "arrival_date"
    );
ALTER TABLE
    "fact_cruise" ADD PRIMARY KEY("cruise_id");
CREATE TABLE "bridge_cruise_ports"(
    "id" BIGSERIAL NOT NULL,
    "cruise_id" INTEGER NOT NULL,
    "port_id" INTEGER NOT NULL,
    "stop_order" INTEGER NOT NULL,
    "stop_type" VARCHAR(255) NOT NULL
);
ALTER TABLE
    "bridge_cruise_ports" ADD PRIMARY KEY("id");
ALTER TABLE
    "fact_booking" ADD CONSTRAINT "fact_booking_payment_status_id_foreign" FOREIGN KEY("payment_status_id") REFERENCES "dim_payment_status"("payment_status_id");
ALTER TABLE
    "dim_city" ADD CONSTRAINT "dim_city_country_id_foreign" FOREIGN KEY("country_id") REFERENCES "dim_country"("country_id");
ALTER TABLE
    "fact_booking" ADD CONSTRAINT "fact_booking_booking_date_id_foreign" FOREIGN KEY("booking_date_id") REFERENCES "dim_booking_time"("time_id");
ALTER TABLE
    "fact_booking" ADD CONSTRAINT "fact_booking_customer_id_foreign" FOREIGN KEY("customer_id") REFERENCES "dim_customer"("customer_id");
ALTER TABLE
    "dim_cruise" ADD CONSTRAINT "dim_cruise_arrival_date_foreign" FOREIGN KEY("arrival_date") REFERENCES "dim_arrive_time"("time_id");
ALTER TABLE
    "bridge_cruise_ports" ADD CONSTRAINT "dim_bridge_cruise_ports_cruise_id_foreign" FOREIGN KEY("cruise_id") REFERENCES "dim_cruise"("cruise_id");
ALTER TABLE
    "bridge_cruise_ports" ADD CONSTRAINT "bridge_cruise_ports_cruise_id_foreign" FOREIGN KEY("cruise_id") REFERENCES "fact_cruise"("cruise_id");
ALTER TABLE
    "fact_cruise" ADD CONSTRAINT "fact_cruise_arrival_date_foreign" FOREIGN KEY("arrival_date") REFERENCES "dim_arrive_time"("time_id");
ALTER TABLE
    "fact_cruise" ADD CONSTRAINT "fact_cruise_cruisline_id_foreign" FOREIGN KEY("cruisline_id") REFERENCES "dim_cruisline"("cruisline_id");
ALTER TABLE
    "fact_booking" ADD CONSTRAINT "fact_booking_payment_method_id_foreign" FOREIGN KEY("payment_method_id") REFERENCES "dim_payment_method"("payment_method_id");
ALTER TABLE
    "dim_port" ADD CONSTRAINT "dim_port_city_id_foreign" FOREIGN KEY("city_id") REFERENCES "dim_city"("city_id");
ALTER TABLE
    "fact_booking" ADD CONSTRAINT "fact_booking_cruise_id_foreign" FOREIGN KEY("cruise_id") REFERENCES "dim_cruise"("cruise_id");
ALTER TABLE
    "bridge_cruise_ports" ADD CONSTRAINT "bridge_cruise_ports_port_id_foreign" FOREIGN KEY("port_id") REFERENCES "dim_port"("port_id");
ALTER TABLE
    "dim_cruise" ADD CONSTRAINT "dim_cruise_cruisline_id_foreign" FOREIGN KEY("cruisline_id") REFERENCES "dim_cruisline"("cruisline_id");
ALTER TABLE
    "fact_booking" ADD CONSTRAINT "fact_booking_cruise_booking_status_id_foreign" FOREIGN KEY("cruise_booking_status_id") REFERENCES "dim_cruise_booking_status"("cruise_booking_status_id");
ALTER TABLE
    "dim_cruise" ADD CONSTRAINT "dim_cruise_departure_date_foreign" FOREIGN KEY("departure_date") REFERENCES "dim_departure_time"("time_id");
ALTER TABLE
    "fact_cruise" ADD CONSTRAINT "fact_cruise_departure_date_foreign" FOREIGN KEY("departure_date") REFERENCES "dim_departure_time"("time_id");