/* average number of G-rated films that each customer has rented */

WITH g_films_count AS (
	SELECT ad.district, cu.customer_id, COUNT(*) AS films
    FROM rental AS r
        JOIN inventory AS i ON r.inventory_id = i.inventory_id
        JOIN film AS f ON i.film_id = f.film_id
        JOIN customer AS cu ON r.customer_id = cu.customer_id 
        JOIN address AS ad ON cu.address_id = ad.address_id
        JOIN city AS ci ON ad.city_id = ci.city_id
        JOIN country AS co ON ci.country_id = co.country_id
    WHERE co.country = 'United States' AND f.rating = 'G'
    GROUP BY ad.district, cu.customer_id)
	
SELECT district AS "state", ROUND(AVG(films), 1) AS avg_films
FROM g_films_count
GROUP BY district
ORDER BY 2 DESC;
