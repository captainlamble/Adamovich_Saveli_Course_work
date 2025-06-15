SELECT
    c.cruiseline_name,
    cs.cabin_class,
    COUNT(b.booking_id) AS total_bookings,
    SUM(p.amount) AS total_revenue,
    AVG(p.amount) AS average_booking_value,
    SUM(CASE WHEN p.payment_status = 'Completed' THEN p.amount ELSE 0 END) AS confirmed_revenue
FROM oltp.cruises c
         JOIN oltp.cruise_seats cs ON c.cruise_number = cs.cruise_number
         JOIN oltp.bookings b ON c.cruise_number = b.cruise_number
         JOIN oltp.payments p ON b.booking_id = p.booking_id
GROUP BY c.cruiseline_name, cs.cabin_class
ORDER BY c.cruiseline_name, total_revenue DESC;