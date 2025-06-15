SELECT
    cust.passport_number,
    cust.first_name,
    cust.last_name,
    cust.email,
    COUNT(b.booking_id) AS total_bookings,
    SUM(p.amount) AS total_spent,
    MIN(b.booking_date) AS first_booking_date,
    MAX(b.booking_date) AS most_recent_booking,
    COUNT(DISTINCT c.cruiseline_name) AS different_cruiselines_used,
    ROUND(AVG(p.amount), 2) AS avg_booking_value,
    STRING_AGG(DISTINCT cs.cabin_class, ', ') AS preferred_cabin_classes
FROM oltp.customers cust
         JOIN oltp.bookings b ON cust.passport_number = b.passport_number
         JOIN oltp.payments p ON b.booking_id = p.booking_id
         JOIN oltp.cruises c ON b.cruise_number = c.cruise_number
         JOIN oltp.cruise_seats cs ON b.cruise_number = cs.cruise_number
GROUP BY cust.passport_number, cust.first_name, cust.last_name, cust.email
ORDER BY total_spent DESC, total_bookings DESC;