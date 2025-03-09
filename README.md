## FOOD DELIVERY PREDICTION

#### About Dataset
* This dataset is designed for predicting food delivery times based on various influencing factors such as distance, weather, traffic conditions, and time of day.
* It offers a practical and engaging challenge for machine learning practitioners/Data Analysis, especially those interested in logistics and operations research.

**Key Features:**

* Order_ID: Unique identifier for each order.
* Distance_km: The delivery distance in kilometers.
* Weather: Weather conditions during the delivery, including Clear, Rainy, Snowy, Foggy, and Windy.
* Traffic_Level: Traffic conditions categorized as Low, Medium, or High.
* Time_of_Day: The time when the delivery took place, categorized as Morning, Afternoon, Evening, or Night.
* Vehicle_Type: Type of vehicle used for delivery, including Bike, Scooter, and Car.
* Preparation_Time_min: The time required to prepare the order, measured in minutes.
* Courier_Experience_yrs: Experience of the courier in years.
* Delivery_Time_min: The total delivery time in minutes (target variable).

-----------------------------

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





 ### Findings

1. **Distance and Delivery Time**:
   - Short distances (1.00 to 5.00 km) have the shortest average delivery times.
   - Medium distances (6.00 to 12.00 km) have moderate average delivery times.
   - Long distances (greater than 12.00 km) have the longest average delivery times.

2. **Weather and Delivery Time**:
   - Different weather conditions impact delivery times. Orders delivered in unknown weather conditions were excluded from the analysis.
   - The average delivery time varies significantly across different weather conditions.

3. **Traffic Level and Delivery Time**:
   - Traffic levels significantly affect delivery times. Orders delivered in 'n/a' traffic conditions were excluded from the analysis.
   - Higher traffic levels generally correlate with longer delivery times.

4. **Time of Day and Delivery Time**:
   - The time of day impacts delivery times. Orders delivered during undefined times were excluded from the analysis.
   - Certain times of the day have shorter average delivery times compared to others.

5. **Vehicle Type and Delivery Time**:
   - The type of vehicle used for delivery affects the delivery time.
   - Some vehicle types are faster on average than others.

6. **Preparation Time and Delivery Time**:
   - Preparation time impacts delivery times.
   - Fast preparation times (5 to 10 minutes) correlate with shorter delivery times.
   - Medium (11 to 18 minutes) and slow preparation times (greater than 18 minutes) correlate with longer delivery times.

7. **Courier Experience and Delivery Time**:
   - Courier experience significantly affects delivery times.
   - Rookie workers (1 to 3 years of experience) have the longest average delivery times.
   - Senior workers (4 to 6 years of experience) have moderate average delivery times.
   - Veteran workers (more than 6 years of experience) have the shortest average delivery times.

### Recommendations

1. **Optimize Delivery Routes**:
   - Focus on optimizing routes for long-distance deliveries to reduce delivery times.
   - Implement route optimization software to find the fastest routes.

2. **Weather Preparedness**:
   - Equip couriers with the necessary gear and training to handle adverse weather conditions.
   - Consider offering incentives for deliveries made under challenging weather conditions.

3. **Traffic Management**:
   - Use real-time traffic data to avoid high-traffic areas.
   - Schedule deliveries during off-peak traffic hours whenever possible.

4. **Time of Day Strategy**:
   - Analyze peak delivery times and allocate more resources during these periods.
   - Consider offering promotions during off-peak hours to balance the workload.

5. **Vehicle Optimization**:
   - Evaluate the performance of different vehicle types and invest in those that offer the best delivery times.
   - Consider using faster vehicles for urgent deliveries.

6. **Improve Preparation Times**:
   - Streamline the food preparation process to reduce preparation times.
   - Implement best practices and training for kitchen staff to ensure efficiency.

7. **Courier Training and Retention**:
   - Invest in training programs for rookie couriers to improve their efficiency.
   - Implement retention strategies to keep experienced couriers, as they significantly reduce delivery times.
   - Consider offering performance-based incentives to motivate couriers.
