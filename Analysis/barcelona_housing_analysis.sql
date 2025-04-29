-- 1) Top 5 most expensive listings

SELECT * FROM housing_data
ORDER BY price DESC
LIMIT 5;

-- 2) Top 5 least expensive listings

SELECT * FROM housing_data
ORDER BY price ASC
LIMIT 5;

-- 3) Average price per district: 

SELECT district, ROUND(AVG(price),0) AS avg_price
FROM housing_data
GROUP BY district
ORDER BY avg_price DESC; 

-- 4) Listings by amount of rooms

SELECT rooms, COUNT(*) AS listings
FROM housing_data
GROUP BY rooms
ORDER BY rooms;

-- 5) Listing count & avg area per district

SELECT 
    district,
    COUNT(*) AS total_listings,
    ROUND(AVG(area_m2), 1) AS avg_area_m2
FROM 
    housing_data
GROUP BY 
    district
ORDER BY 
    total_listings DESC;
    
--  X) Average price by floor: 

SELECT 
    floor_number,
    COUNT(*) AS listings,
    ROUND(AVG(price), 0) AS avg_price
FROM 
    housing_data
WHERE 
    floor_number IS NOT NULL
GROUP BY 
    floor_number
ORDER BY 
    avg_price DESC;

-- X) -- most expensive district per type (subquery)

SELECT 
    type,
    district,
    ROUND(AVG(price), 0) AS avg_price
FROM 
    housing_data
GROUP BY 
    type, district
HAVING 
    AVG(price) = (
        SELECT MAX(avg_price)
        FROM (
            SELECT type AS t, district AS d, AVG(price) AS avg_price
            FROM housing_data
            GROUP BY type, district
        ) AS sub
        WHERE sub.t = housing_data.type
    );

-- x) CTE (price per square meter for listings with Lift)

WITH with_price_m2 AS (
    SELECT *, 
           ROUND(price / area_m2, 2) AS price_per_m2
    FROM housing_data
    WHERE area_m2 > 0
)

SELECT 
    district,
    ROUND(AVG(price_per_m2), 0) AS avg_price_per_m2,
    COUNT(*) AS listings_with_lift
FROM with_price_m2
WHERE lift = 'Yes'
GROUP BY district
ORDER BY avg_price_per_m2 DESC;

-- X) Cheapest neighborhood on each district 

SELECT hd.district, hd.neighborhood, ROUND(AVG(hd.price)) AS avg_price
FROM housing_data hd
WHERE (hd.district, hd.neighborhood) IN (
    SELECT district, neighborhood
    FROM (
        SELECT district, neighborhood, AVG(price) AS avg_price,
               RANK() OVER (PARTITION BY district ORDER BY AVG(price)) AS rnk
        FROM housing_data
        GROUP BY district, neighborhood
    ) ranked
    WHERE rnk = 1
)
GROUP BY hd.district, hd.neighborhood
ORDER BY district;


-- Top 3 most expensive listings per district (check if save as new table) 

WITH ranked_listings AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY district ORDER BY price DESC) AS rank_within_district
    FROM housing_data
)

SELECT *
FROM ranked_listings
WHERE rank_within_district <= 3
ORDER BY district, price DESC;

-- Avg price by condition 

SELECT 
    `condition`,
    COUNT(*) AS listings,
    ROUND(AVG(price), 0) AS avg_price,
    ROUND(AVG(area_m2), 1) AS avg_area
FROM housing_data
GROUP BY `condition`
ORDER BY avg_price DESC;


-- Price per m2 by condition 

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


-- 
