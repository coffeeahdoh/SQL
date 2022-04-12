/* rental and return dates; film rented and from what store address; and customer name, email, and address. */

SELECT r.rental_date, 
       r.return_date, 
	   r.return_date - r.rental_date AS difference,
       (CASE WHEN r.return_date - r.rental_date > INTERVAL '3 days, 12 hours' 
		    THEN TRUE 
		    ELSE FALSE
		    END) AS is_overdue,
	   r.inventory_id,
       f.title AS film_title, 
       a1.address AS store_address, 
       c.last_name || ', ' || c.first_name AS customer_name, 
       c.email AS customer_email, 
       a2.address AS customer_address
FROM rental AS r 
        LEFT JOIN inventory AS i ON r.inventory_id = i.inventory_id
		LEFT JOIN film AS f ON i.film_id = f.film_id
        LEFT JOIN store AS s ON i.store_id = s.store_id
                LEFT JOIN address AS a1 ON s.address_id = a1.address_id 
        LEFT JOIN customer AS c ON r.customer_id = c.customer_id
                LEFT JOIN address AS a2 ON c.address_id = a2.address_id
WHERE r.return_date IS NOT NULL
ORDER BY r.rental_date DESC;
