select * from export_import
select SUM(Total_Value_USD) as Total_Value from export_import 


#Export vs Import
select Trade_Type,SUM(Total_Value_USD) as Total_Value 
from export_import 
group by Trade_Type 

#Trade Differnce
SELECT 
    SUM(CASE WHEN Trade_type='Export' THEN total_value_usd ELSE 0 END) -
    SUM(CASE WHEN Trade_type='Import' THEN total_value_usd ELSE 0 END) 
    AS trade_balance
FROM export_import;


#
select Trade_Type,SUM(Total_Value_USD) as Total_Value 
from export_import 
group by Trade_Type 


#Top Export Country
SELECT partner_country, SUM(total_value_usd) AS total_export
FROM export_import
WHERE trade_type = 'Export'
GROUP BY partner_country
ORDER BY total_export DESC
LIMIT 1;


#Top Import Country
SELECT partner_country, SUM(total_value_usd) AS total_export
FROM export_import
WHERE trade_type = 'Import'
GROUP BY partner_country
ORDER BY total_export DESC
LIMIT 1;


#Company wise import export gap
SELECT 
    company_name,
    SUM(CASE WHEN trade_type='Export' THEN total_value_usd ELSE 0 END) AS export_val,
    SUM(CASE WHEN trade_type='Import' THEN total_value_usd ELSE 0 END) AS import_val,
    SUM(CASE WHEN trade_type='Export' THEN total_value_usd ELSE 0 END) -
    SUM(CASE WHEN trade_type='Import' THEN total_value_usd ELSE 0 END) AS gap
FROM export_import
GROUP BY company_name;



SELECT 
    AVG(DATEDIFF(
        STR_TO_DATE(delivery_date,'%d/%m/%Y'), 
        STR_TO_DATE(order_date,'%d/%m/%Y')
    ) * 1.0) AS avg_days
FROM export_import
WHERE delivery_date IS NOT NULL
  AND order_date IS NOT NULL;


ALTER TABLE export_import
ADD COLUMN order_date_clean DATE,
ADD COLUMN delivery_date_clean DATE;


UPDATE export_import
SET 
    order_date_clean = STR_TO_DATE(order_date, '%m/%d/%Y'),
    delivery_date_clean = STR_TO_DATE(delivery_date, '%m/%d/%Y');



SELECT order_date
FROM export_import
LIMIT 20;


ALTER TABLE export_import
DROP COLUMN order_date,
DROP COLUMN delivery_date;

ALTER TABLE export_import
change order_date_clean order_date date,
change delivery_date_clean delivery_date date;




SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(total_value_usd) AS total_value
FROM export_import
WHERE order_date IS NOT NULL
GROUP BY 
    YEAR(order_date),
    MONTH(order_date)
    
ORDER BY year, month;


SELECT *
FROM export_import
WHERE DATEDIFF(delivery_date, order_date) > 7;


SELECT 
   Order_Month,SUM(total_value_usd) AS total_value
FROM export_import
GROUP BY Order_Month ;


WITH country_trade AS (
    SELECT 
        partner_country,
        SUM(total_value_usd) AS total_val
    FROM export_import
    GROUP BY partner_country
)
SELECT *
FROM country_trade
ORDER BY total_val DESC;


SELECT 
    partner_country,
    SUM(total_value_usd) AS total_val,
    RANK() OVER (ORDER BY SUM(total_value_usd) DESC) AS country_rank
FROM export_import
GROUP BY partner_country;


SELECT VERSION();

SELECT *
FROM (
    SELECT 
        trade_type,
        partner_country,
        SUM(total_value_usd) AS total_val,
        RANK() OVER (PARTITION BY trade_type ORDER BY SUM(total_value_usd) DESC) AS rnk
    FROM export_import
    GROUP BY trade_type, partner_country
) t
WHERE rnk <= 3;


SELECT *
FROM export_import
WHERE total_value_usd > (
    SELECT AVG(total_value_usd)
    FROM export_import
)



SELECT 
    SUM(freight_cost_usd) / SUM(total_value_usd) AS freight_percentage
FROM export_import;


SELECT 
    order_date,
    SUM(total_value_usd) OVER (ORDER BY order_date) AS running_total
FROM export_import;


SELECT 
    order_date,
    AVG(total_value_usd) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg
FROM export_import;



SELECT 
    product_category,
    SUM(total_value_usd) * 100.0 / 
    (SELECT SUM(total_value_usd) FROM export_import) AS Percentage
FROM export_import
GROUP BY product_category;




SELECT company_name, MAX(total_value_usd) AS max_val
FROM export_import
GROUP BY company_name;



SELECT partner_country, COUNT(*) AS freq
FROM export_import
GROUP BY partner_country
ORDER BY freq DESC
LIMIT 5;





















