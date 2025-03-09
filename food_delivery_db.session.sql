
```SQL
CREATE TABLE food_delivery
(order_id INT,
distance_km FLOAT ,
weather VARCHAR(100),
traffic_level VARCHAR(100),
time_of_day VARCHAR(100),
vehicle_type VARCHAR(100),
preparation_time_min INT,
courier_experience_yrs INT ,
delivery_time_min INT
);
```

DATA CLEANING

```SQL
SELECT * FROM food_delivery;
```

```SQL
SELECT * FROM food_delivery
WHERE order_id IS NULL
OR distance_km IS NULL
OR weather IS NULL
OR traffic_level IS NULL
OR time_of_day IS NULL
OR vehicle_type IS NULL
OR preparation_time_min IS NULL
OR courier_experience_yrs IS NULL
OR delivery_time_min IS NULL;
```

our data consist of null values, we must replace or delete them inorder to analyze our data better.

```SQL
UPDATE food_delivery
SET weather = 'Unknown'
WHERE weather = 'Unkown';
```

```SQL
UPDATE food_delivery
SET traffic_level = 'n/a'
WHERE traffic_level IS NULL;
```

```SQL
UPDATE food_delivery
SET time_of_day = 'undefined'
WHERE time_of_day IS NULL;
```

```SQL
UPDATE food_delivery
SET courier_experience_yrs = 0
WHERE courier_experience_yrs IS NULL;
```

Our data contains no null values, we can now continue with the our analysis

```SQL
SELECT * FROM food_delivery
```

EDA 
1. How distance affects delivery 

```SQL
WITH distance_covered
AS
( 
SELECT
      ROUND(AVG(distance_km)::integer,2) AS avg_distance,
      delivery_time_min,
      distance_km,
      order_id,
      CASE
          WHEN distance_km BETWEEN 1.00 AND 5.00 THEN 'short_distance'
          WHEN distance_km BETWEEN 6.00 AND 12.00 THEN 'medium_distance'
          ELSE 'long_distance'
          END AS distance_coverage
FROM food_delivery
GROUP BY 2,3,4
ORDER BY 1 ASC
)
SELECT 
      distance_coverage, 
      ROUND(AVG(delivery_time_min),2) AS avg_delivery_time_min,
      COUNT(order_id) AS total_orders
FROM distance_covered
GROUP BY 1
ORDER BY 2 ASC;
```

2. How weather affects delivery 
```SQL
SELECT 
      weather,
      COUNT(*) AS total_orders,
      ROUND(AVG(delivery_time_min),2) AS avg_delivery_time_time_min
FROM food_delivery
WHERE weather != 'Unknown'
GROUP BY 1
ORDER BY 3 ASC;
```

3. How the level of traffic affects delivery
```SQL
SELECT 
      traffic_level,
      COUNT(*) AS total_orders,
      ROUND(AVG(delivery_time_min),2) AS avg_delivery_time_min
FROM food_delivery
WHERE traffic_level != 'n/a'
GROUP BY 1
ORDER BY 3 ASC;
```

4. How time of the day affects delivery
```SQL
SELECT 
      time_of_day,
      COUNT(*) AS total_orders,
      ROUND(AVG(delivery_time_min),2) AS avg_delivery_time_min
FROM food_delivery
WHERE time_of_day != 'undefined'
GROUP BY 1
ORDER BY 3 ASC;
```

5. How vehicle type affects delivery
```SQL
SELECT
      vehicle_type,
      COUNT(*) AS total_orders,
      ROUND(AVG(delivery_time_min),2) AS avg_delivery_time_mins
FROM food_delivery
GROUP BY 1
ORDER BY 3 ASC;
```

6. How preparation time affects delivery
```SQL
WITH workers
AS
(
SELECT
       preparation_time_min,
       delivery_time_min,
       order_id,
       CASE 
            WHEN  preparation_time_min BETWEEN 5 AND 10 THEN 'fast_rate_workers'
            WHEN   preparation_time_min BETWEEN 11 AND 18 THEN 'mdeium_rate_workers'
            ELSE 'slow_rate_workers'
            END AS working_rate
FROM food_delivery
)
SELECT 
      working_rate,
      ROUND(AVG(delivery_time_min),2) AS avg_delivery_time_mins,
        COUNT(order_id) AS total_orders
FROM workers
GROUP BY 1
ORDER BY 2 ASC
```

7. How courier exprerience affects delivery
```SQL
WITH worker_seg
AS
(
SELECT 
      courier_experience_yrs,
      delivery_time_min,
      order_id,
      CASE 
          WHEN courier_experience_yrs BETWEEN 1 AND 3 THEN 'Rookie_worker'
          WHEN courier_experience_yrs BETWEEN 4 AND 6 THEN 'Senior_worker'
          ELSE 'Veteran_worker'
          END AS worker_experience
FROM food_delivery
WHERE courier_experience_yrs != 0
)
SELECT
      worker_experience,
      COUNT(order_id) AS total_orders,
      ROUND(AVG(delivery_time_min),2) AS avg_delivery_time_min
FROM worker_seg
GROUP BY 1
ORDER BY 3 ASC
```

