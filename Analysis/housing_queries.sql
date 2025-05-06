-- 1. Top 5 most expensive listings
SELECT * 
FROM housing_data
ORDER BY price DESC
LIMIT 5;

-- 2. Top 5 least expensive listings
SELECT * 
FROM housing_data
ORDER BY price ASC
LIMIT 5;

-- 3. Average price per district
SELECT 
    district, 
    ROUND(AVG(price), 0) AS avg_price
FROM housing_data
GROUP BY district
ORDER BY avg_price DESC;

-- 4. Average price per neighborhood
SELECT 
    district, 
    neighborhood, 
    ROUND(AVG(price), 0) AS avg_price
FROM housing_data  
GROUP BY district, neighborhood
ORDER BY avg_price DESC;

-- 5. Listings by number of rooms
SELECT 
    rooms, 
    COUNT(*) AS listings
FROM housing_data
GROUP BY rooms
ORDER BY rooms;

-- 6. Listing count & average area per district
SELECT 
    district,
    COUNT(*) AS total_listings,
    ROUND(AVG(area_m2), 1) AS avg_area_m2
FROM housing_data
GROUP BY district
ORDER BY total_listings DESC;

-- 7. Average price by floor number
SELECT 
    floor_number,
    COUNT(*) AS listings,
    ROUND(AVG(price), 0) AS avg_price
FROM housing_data
WHERE floor_number IS NOT NULL
GROUP BY floor_number
ORDER BY avg_price DESC;

-- 8. Average price and area by property condition
SELECT 
    `condition`,
    COUNT(*) AS listings,
    ROUND(AVG(price), 0) AS avg_price,
    ROUND(AVG(area_m2), 1) AS avg_area
FROM housing_data
GROUP BY `condition`
ORDER BY avg_price DESC;

-- 9. Average price by property type
SELECT 
    `type`,
    COUNT(*) AS listings, 
    ROUND(AVG(price), 0) AS avg_price
FROM housing_data
GROUP BY `type`
ORDER BY avg_price DESC;

-- 10. Price per m² by condition
WITH price_per_m2 AS (
    SELECT *, 
           ROUND(price / area_m2, 2) AS ppm2
    FROM housing_data
    WHERE area_m2 > 0
)
SELECT 
    `condition`,
    COUNT(*) AS listings,
    ROUND(AVG(ppm2), 2) AS avg_price_per_m2
FROM price_per_m2
GROUP BY `condition`
ORDER BY avg_price_per_m2 DESC;

-- 11. Elevator access rate by district and total for Barcelona
SELECT
    district,
    ROUND(SUM(CASE WHEN lift = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1) AS percent_with_lift
FROM housing_data
GROUP BY district

UNION

SELECT
    'Barcelona' AS district,
    ROUND(SUM(CASE WHEN lift = 'Yes' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 1)
FROM housing_data;

-- 12. Most & least expensive neighborhoods per district (with avg prices)
SELECT
    district,
    MAX(CASE WHEN avg_price = max_price THEN neighborhood END) AS most_expensive_neighborhood,
    MAX(CASE WHEN avg_price = max_price THEN avg_price END) AS most_expensive_avg_price,
    MAX(CASE WHEN avg_price = min_price THEN neighborhood END) AS least_expensive_neighborhood,
    MAX(CASE WHEN avg_price = min_price THEN avg_price END) AS least_expensive_avg_price
FROM (
    SELECT 
        district,
        neighborhood,
        ROUND(AVG(price)) AS avg_price,
        MAX(ROUND(AVG(price))) OVER (PARTITION BY district) AS max_price,
        MIN(ROUND(AVG(price))) OVER (PARTITION BY district) AS min_price
    FROM housing_data
    GROUP BY district, neighborhood
) ranked
GROUP BY district
ORDER BY district;
