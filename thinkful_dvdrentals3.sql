/* number rentals per customer per US state with at least 2 customers */

WITH num_rentals AS (
    SELECT ad.district, r.customer_id, COUNT(*) AS rentals
	FROM rental AS r 
    	JOIN customer AS cu ON r.customer_id = cu.customer_id
		JOIN address AS ad ON cu.address_id = ad.address_id
		JOIN city AS ci ON ad.city_id = ci.city_id
		JOIN country AS co ON ci.country_id = co.country_id
	WHERE country = 'United States'
	GROUP BY ad.district, r.customer_id
	ORDER BY ad.district),
	
morethan_2 AS (
    SELECT district, COUNT(*)
    FROM num_rentals
    GROUP BY district) 
	
SELECT n.district AS "state",
       n.customer_id,
       cu.last_name || ', ' || cu.first_name AS customer_name,
	   n.rentals
FROM num_rentals AS n
	JOIN morethan_2 AS mo ON n.district = mo.district
	JOIN customer AS cu ON n.customer_id = cu.customer_id
WHERE count >= 2
ORDER BY 1, 2;

