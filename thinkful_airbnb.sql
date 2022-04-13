/* Write a query to return a table with the name, neighborhood, number of reviews, 
average price, and percentage availability for the 10 listings with the most reviews. 
The correct tables all start with sfo_. */


/* ~767+ msec, needs refinement */
WITH top10 AS (
    SELECT listing_id, COUNT(*) AS num_reviews
    FROM sfo_reviews
    GROUP BY listing_id
    ORDER BY num_reviews DESC
    LIMIT 10),

cal10 AS (SELECT cal.listing_id,
	   CASE WHEN cal.available = 'f' 
	             THEN 0
				 ELSE 1
				 END AS available_bool,
       SUBSTRING(cal.price, 2)::FLOAT AS price_float
FROM sfo_calendar AS cal
     JOIN top10 AS top ON cal.listing_id = top.listing_id),
	 	 
cal_agg AS (SELECT listing_id,
       ROUND(CAST(SUM(available_bool)::FLOAT / COUNT(*)::FLOAT AS numeric), 2) AS percent_avail,
	   ROUND(CAST(AVG(NULLIF(price_float, 0)) AS numeric), 2) AS avg_price
FROM cal10
GROUP BY listing_id)

SELECT list.id,
       list.neighbourhood,
	   top.num_reviews,
	   cal.avg_price,
	   cal.percent_avail
FROM sfo_listings AS list
    JOIN top10 AS top ON list.id = top.listing_id
	JOIN cal_agg AS cal ON list.id = cal.listing_id;
	
	
	
/* SOLUTION, ~583 msec */
WITH most_reviewed AS (
SELECT listing_id, COUNT(id) as reviews
FROM sfo_reviews
GROUP BY listing_id
ORDER BY 2 DESC
LIMIT 10)

SELECT m.listing_id,
       l.name,
	   l.neighbourhood,
	   m.reviews,
	   ROUND(AVG(REPLACE(REPLACE(c.price, ',', ''), '$', '')::numeric), 2)::money AS price,
	   ROUND(100.0 * (SUM(CASE WHEN available = 't' THEN 1 ELSE 0 END))/COUNT(*)) AS perc_available
FROM most_reviewed m
    LEFT JOIN sfo_calendar c ON m.listing_id = c.listing_id
	LEFT JOIN sfo_listings l ON m.listing_id = l.id
GROUP BY m.listing_id, l.name, l.neighbourhood, m.reviews;