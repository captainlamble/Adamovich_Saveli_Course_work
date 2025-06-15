SELECT
    cl.cruisline_name,
    dt.year,
    dt.quarter,
    COUNT(fb.booking_id) AS total_bookings,
    SUM(fb.total_amount) AS total_revenue,
    AVG(fb.total_amount) AS average_booking_value
FROM
    fact_booking fb
        JOIN
    dim_cruise dc ON fb.cruise_id = dc.cruise_id
        JOIN
    dim_cruisline cl ON dc.cruisline_id = cl.cruisline_id
        JOIN
    dim_booking_time dt ON fb.booking_date_id = dt.time_id
WHERE
    fb.payment_status_id = (SELECT payment_status_id FROM dim_payment_status WHERE name = 'paid')
GROUP BY
    cl.cruisline_name, dt.year, dt.quarter
ORDER BY
    cl.cruisline_name, dt.year, dt.quarter;