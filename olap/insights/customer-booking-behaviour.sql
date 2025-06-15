SELECT
    dp.port_name AS departure_port,
    dc.name AS departure_country,
    ap.port_name AS arrival_port,
    ac.name AS arrival_country,
    COUNT(fc.cruise_id) AS cruise_count,
    SUM(fc.sold_seats) AS total_passengers,
    AVG(fc.popularity_index) AS avg_popularity,
    SUM(fb.total_amount) AS total_revenue
FROM
    fact_cruise fc
        JOIN
    dim_port dp ON fc.departure_port_id = dp.port_id
        JOIN
    dim_port ap ON fc.arrival_port_id = ap.port_id
        JOIN
    dim_city dpc ON dp.city_id = dpc.city_id
        JOIN
    dim_city apc ON ap.city_id = apc.city_id
        JOIN
    dim_country dc ON dpc.country_id = dc.country_id
        JOIN
    dim_country ac ON apc.country_id = ac.country_id
        LEFT JOIN
    fact_booking fb ON fc.cruise_id = fb.cruise_id
GROUP BY
    dp.port_name, dc.name, ap.port_name, ac.name
ORDER BY
    total_passengers DESC, total_revenue DESC;