ROLLBACK;
BEGIN;

SET session_replication_role = 'replica';

INSERT INTO dim_country (country_id, name)
SELECT
    (SELECT COALESCE(MAX(country_id), 0) FROM dim_country) + ROW_NUMBER() OVER (ORDER BY country) as country_id,
    TRIM(country) as name
FROM (SELECT DISTINCT country FROM oltp_fdw.ports) as unique_countries
WHERE NOT EXISTS (SELECT 1 FROM dim_country dc WHERE TRIM(country) = TRIM(dc.name));

INSERT INTO dim_cruisline (cruisline_id, cruisline_name, contact_email, contact_phone)
SELECT
    (SELECT COALESCE(MAX(cruisline_id), 0) FROM dim_cruisline) + ROW_NUMBER() OVER (ORDER BY cruisline_name) as cruisline_id,
    TRIM(cruisline_name) as cruisline_name,
    contact_email,
    contact_phone
FROM oltp_fdw.cruiselines cl
WHERE NOT EXISTS (SELECT 1 FROM dim_cruisline dc WHERE TRIM(cl.cruisline_name) = TRIM(dc.cruisline_name));

INSERT INTO dim_cruisline (cruisline_id, cruisline_name, contact_email, contact_phone)
SELECT
    (SELECT COALESCE(MAX(cruisline_id), 0) FROM dim_cruisline) + ROW_NUMBER() OVER (ORDER BY c.cruiseline_name) as cruisline_id,
    TRIM(c.cruiseline_name) as cruisline_name,
    NULL as contact_email,
    NULL as contact_phone
FROM oltp_fdw.cruises c
WHERE NOT EXISTS (SELECT 1 FROM dim_cruisline dc WHERE TRIM(c.cruiseline_name) = TRIM(dc.cruisline_name));

INSERT INTO dim_city (city_id, country_id, name)
SELECT
    (SELECT COALESCE(MAX(city_id), 0) FROM dim_city) + ROW_NUMBER() OVER (ORDER BY p.city) as city_id,
    c.country_id,
    TRIM(p.city) as name
FROM (SELECT DISTINCT TRIM(city) as city, TRIM(country) as country FROM oltp_fdw.ports) as p
         JOIN dim_country c ON TRIM(p.country) = TRIM(c.name)
WHERE NOT EXISTS (SELECT 1 FROM dim_city dc WHERE TRIM(p.city) = TRIM(dc.name));

INSERT INTO dim_port (port_id, city_id, port_code, port_name)
SELECT
    (SELECT COALESCE(MAX(port_id), 0) FROM dim_port) + ROW_NUMBER() OVER (ORDER BY p.port_code) as port_id,
    c.city_id,
    TRIM(p.port_code) as port_code,
    TRIM(p.port_name) as port_name
FROM oltp_fdw.ports p
         JOIN dim_city c ON TRIM(p.city) = TRIM(c.name)
WHERE NOT EXISTS (SELECT 1 FROM dim_port dp WHERE TRIM(p.port_code) = TRIM(dp.port_code));

INSERT INTO dim_arrive_time (time_id, date, day_of_week, month, quarter, year)
SELECT DISTINCT
    EXTRACT(EPOCH FROM arrival_time)::INTEGER as time_id,
    DATE(arrival_time) as date,
    TO_CHAR(arrival_time, 'Day') as day_of_week,
    EXTRACT(MONTH FROM arrival_time) as month,
    EXTRACT(QUARTER FROM arrival_time) as quarter,
    EXTRACT(YEAR FROM arrival_time) as year
FROM oltp_fdw.cruises
WHERE NOT EXISTS (
    SELECT 1 FROM dim_arrive_time
    WHERE time_id = EXTRACT(EPOCH FROM arrival_time)::INTEGER
);

INSERT INTO dim_departure_time (time_id, date, day_of_week, month, quarter, year)
SELECT DISTINCT
    EXTRACT(EPOCH FROM departure_time)::INTEGER as time_id,
    DATE(departure_time) as date,
    TO_CHAR(departure_time, 'Day') as day_of_week,
    EXTRACT(MONTH FROM departure_time) as month,
    EXTRACT(QUARTER FROM departure_time) as quarter,
    EXTRACT(YEAR FROM departure_time) as year
FROM oltp_fdw.cruises
WHERE NOT EXISTS (
    SELECT 1 FROM dim_departure_time
    WHERE time_id = EXTRACT(EPOCH FROM departure_time)::INTEGER
);

INSERT INTO dim_booking_time (time_id, date, day_of_week, month, quarter, year)
SELECT DISTINCT
    EXTRACT(EPOCH FROM booking_date)::INTEGER as time_id,
    DATE(booking_date) as date,
    TO_CHAR(booking_date, 'Day') as day_of_week,
    EXTRACT(MONTH FROM booking_date) as month,
    EXTRACT(QUARTER FROM booking_date) as quarter,
    EXTRACT(YEAR FROM booking_date) as year
FROM oltp_fdw.bookings
WHERE NOT EXISTS (
    SELECT 1 FROM dim_booking_time
    WHERE time_id = EXTRACT(EPOCH FROM booking_date)::INTEGER
);

INSERT INTO dim_payment_method (payment_method_id, name)
SELECT
    (SELECT COALESCE(MAX(payment_method_id), 0) FROM dim_payment_method) + ROW_NUMBER() OVER (ORDER BY payment_method) as payment_method_id,
    TRIM(payment_method) as name
FROM (SELECT DISTINCT payment_method FROM oltp_fdw.payments) as unique_methods
WHERE NOT EXISTS (SELECT 1 FROM dim_payment_method dpm WHERE TRIM(payment_method) = TRIM(dpm.name));

INSERT INTO dim_payment_status (payment_status_id, name)
SELECT
    (SELECT COALESCE(MAX(payment_status_id), 0) FROM dim_payment_status) + ROW_NUMBER() OVER (ORDER BY payment_status) as payment_status_id,
    TRIM(payment_status) as name
FROM (SELECT DISTINCT payment_status FROM oltp_fdw.payments) as unique_statuses
WHERE NOT EXISTS (SELECT 1 FROM dim_payment_status dps WHERE TRIM(payment_status) = TRIM(dps.name));

INSERT INTO dim_cruise_booking_status (cruise_booking_status_id, name)
SELECT
    (SELECT COALESCE(MAX(cruise_booking_status_id), 0) FROM dim_cruise_booking_status) + ROW_NUMBER() OVER (ORDER BY status) as cruise_booking_status_id,
    TRIM(status) as name
FROM (SELECT DISTINCT status FROM oltp_fdw.bookings) as unique_statuses
WHERE NOT EXISTS (SELECT 1 FROM dim_cruise_booking_status dcbs WHERE TRIM(status) = TRIM(dcbs.name));

INSERT INTO dim_customer (
    customer_id, passport_number, first_name, last_name,
    email, phone_number, ts_created, ts_finished, is_current
)
SELECT
    (SELECT COALESCE(MAX(customer_id), 0) FROM dim_customer) + ROW_NUMBER() OVER (ORDER BY passport_number) as customer_id,
    TRIM(passport_number) as passport_number,
    TRIM(first_name) as first_name,
    TRIM(last_name) as last_name,
    TRIM(email) as email,
    TRIM(phone_number) as phone_number,
    CURRENT_DATE,
    NULL,
    TRUE
FROM oltp_fdw.customers c
WHERE NOT EXISTS (SELECT 1 FROM dim_customer dc WHERE TRIM(c.passport_number) = TRIM(dc.passport_number));

INSERT INTO dim_cruise (
    cruise_id, cruisline_id, departure_port_id, arrival_port_id,
    departure_date, arrival_date, cruise_number
)
SELECT
    (SELECT COALESCE(MAX(cruise_id), 0) FROM dim_cruise) + ROW_NUMBER() OVER (ORDER BY c.cruise_number) as cruise_id,
    cl.cruisline_id,
    dp.port_id as departure_port_id,
    ap.port_id as arrival_port_id,
    EXTRACT(EPOCH FROM c.departure_time)::INTEGER as departure_date,
    EXTRACT(EPOCH FROM c.arrival_time)::INTEGER as arrival_date,
    TRIM(c.cruise_number) as cruise_number
FROM oltp_fdw.cruises c
         JOIN dim_cruisline cl ON TRIM(c.cruiseline_name) = TRIM(cl.cruisline_name)
         JOIN dim_port dp ON TRIM(c.departure_port_code) = TRIM(dp.port_code)
         JOIN dim_port ap ON TRIM(c.arrival_port_code) = TRIM(ap.port_code)
WHERE NOT EXISTS (SELECT 1 FROM dim_cruise dc WHERE TRIM(c.cruise_number) = TRIM(dc.cruise_number));

INSERT INTO bridge_cruise_ports (cruise_id, port_id, stop_order, stop_type)
SELECT DISTINCT
    dc.cruise_id,
    p.port_id,
    cp.id as stop_order,
    'Intermediate' as stop_type
FROM oltp_fdw.cruises_ports cp
         JOIN dim_cruise dc ON TRIM(cp.cruise_number) = TRIM(dc.cruise_number)
         JOIN dim_port p ON TRIM(cp.inter_port_code) = TRIM(p.port_code)
WHERE NOT EXISTS (
    SELECT 1 FROM bridge_cruise_ports bcp
    WHERE bcp.cruise_id = dc.cruise_id
      AND bcp.port_id = p.port_id
      AND bcp.stop_order = cp.id
);

INSERT INTO fact_cruise (
    cruise_id, cruisline_id, departure_port_id, arrival_port_id,
    departure_date, arrival_date, flight_number, total_seats,
    available_seats_first_class, available_seats_second_class,
    available_seats_third_class, sold_seats, popularity_index,
    total_cabins, available_cabins
)
SELECT
    dc.cruise_id,
    dc.cruisline_id,
    dc.departure_port_id,
    dc.arrival_port_id,
    dc.departure_date,
    dc.arrival_date,
    TRIM(c.cruise_number) as flight_number,
    COUNT(cs.cabin_number) as total_seats,
    COUNT(CASE WHEN cs.cabin_class = 'First Class' THEN 1 END) as available_seats_first_class,
    COUNT(CASE WHEN cs.cabin_class = 'Second Class' THEN 1 END) as available_seats_second_class,
    COUNT(CASE WHEN cs.cabin_class = 'Third Class' THEN 1 END) as available_seats_third_class,
    COUNT(b.booking_id) as sold_seats,
    CASE WHEN COUNT(cs.cabin_number) > 0 THEN
             (COUNT(b.booking_id)::FLOAT / COUNT(cs.cabin_number)::FLOAT)
         ELSE 0 END as popularity_index,
    COUNT(cs.cabin_number) as total_cabins,
    COUNT(cs.cabin_number) - COUNT(b.booking_id) as available_cabins
FROM oltp_fdw.cruises c
         JOIN dim_cruise dc ON TRIM(c.cruise_number) = TRIM(dc.cruise_number)
         LEFT JOIN oltp_fdw.cruise_seats cs ON TRIM(c.cruise_number) = TRIM(cs.cruise_number)
         LEFT JOIN oltp_fdw.bookings b ON TRIM(c.cruise_number) = TRIM(b.cruise_number) AND TRIM(cs.cabin_number) = TRIM(b.seat_number)
WHERE NOT EXISTS (SELECT 1 FROM fact_cruise fc WHERE fc.cruise_id = dc.cruise_id)
GROUP BY dc.cruise_id, dc.cruisline_id, dc.departure_port_id, dc.arrival_port_id,
         dc.departure_date, dc.arrival_date, c.cruise_number;

INSERT INTO fact_booking (
    booking_id, customer_id, cruise_id, booking_date_id,
    payment_method_id, payment_status_id, cruise_booking_status_id,
    seat_number, total_amount
)
SELECT
    TRIM(b.booking_id) as booking_id,
    dc.customer_id,
    dcr.cruise_id,
    EXTRACT(EPOCH FROM b.booking_date)::INTEGER as booking_date_id,
    pm.payment_method_id,
    ps.payment_status_id,
    bs.cruise_booking_status_id,
    TRIM(b.seat_number) as seat_number,
    p.amount
FROM oltp_fdw.bookings b
         JOIN dim_customer dc ON TRIM(b.passport_number) = TRIM(dc.passport_number)
         JOIN dim_cruise dcr ON TRIM(b.cruise_number) = TRIM(dcr.cruise_number)
         LEFT JOIN oltp_fdw.payments p ON TRIM(b.booking_id) = TRIM(p.booking_id)
         LEFT JOIN dim_payment_method pm ON TRIM(p.payment_method) = TRIM(pm.name)
         LEFT JOIN dim_payment_status ps ON TRIM(p.payment_status) = TRIM(ps.name)
         JOIN dim_cruise_booking_status bs ON TRIM(b.status) = TRIM(bs.name)
WHERE NOT EXISTS (SELECT 1 FROM fact_booking fb WHERE TRIM(fb.booking_id) = TRIM(b.booking_id));

SET session_replication_role = 'origin';

COMMIT;