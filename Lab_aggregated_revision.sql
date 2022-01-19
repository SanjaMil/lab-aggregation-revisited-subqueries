use sakila;
-- Select the first name, last name, and email address of all the customers who have rented a movie.
SELECT * FROM customer;
SELECT * FROM rental;
SELECT * FROM payment;
SELECT * FROM film;
SELECT * FROM category;
SELECT * FROM inventory;


SELECT first_name, last_name, email FROM customer c
-- LEFT JOIN rental r ON c.customer_id = r.customer_id
WHERE c.customer_id IN (SELECT DISTINCT customer_id 
	FROM rental);
    
-- What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

SELECT c.customer_id, CONCAT(first_name, ' ', last_name) AS Full_name , avg(amount) FROM customer c
LEFT JOIN payment p ON c.customer_id = p.customer_id
GROUP BY 1,2;

-- Select the name and email address of all the customers who have rented the "Action" movies.


SELECT CONCAT(first_name, ' ', last_name) as Full_name, email, cat.name AS Category_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Action';

-- Write the query using multiple join statements
-- Write the query using sub queries with multiple WHERE clause and IN condition
SELECT * FROM customer;
SELECT * FROM film_category;

SELECT Full_name, email
FROM (
	SELECT CONCAT(first_name, ' ', last_name) as Full_name, email, customer_id
    FROM customer) c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id IN (SELECT category.category_id AS c_id FROM category
					WHERE category.name = 'Action');
	

-- Verify if the above two queries produce the same results or not
WITH query_1 AS (
SELECT CONCAT(first_name, ' ', last_name) as Full_name, email, cat.name AS Category_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Action')
SELECT COUNT(*) FROM query_1;


WITH query_2 AS (
SELECT Full_name, email
FROM (
	SELECT CONCAT(first_name, ' ', last_name) as Full_name, email, customer_id
    FROM customer) c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
WHERE fc.category_id IN (SELECT category.category_id AS c_id FROM category
					WHERE category.name = 'Action'))
SELECT COUNT(*) FROM query_2;
