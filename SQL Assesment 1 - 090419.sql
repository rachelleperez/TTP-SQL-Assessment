*** ALL QUESTIONS ***

--1 - Which DVDRENTAL employee handled the smallest amount of  transactions?
--2 Which R rated movie has the largest replacement cost?
​
--3 Get the customer ID’s of ALL customers who have spent more money than the average of all customers in the database
(PLEASE JUST WRITE THE QUERY FOR THIS ONE.)
​
--4 Return the customer IDs of customers who have spent less than $100 with the staff member who has an ID of 1.
(PLEASE JUST WRITE THE QUERY FOR THIS ONE.)
​
--5  Which store has made the most money from renting family-friendly films, (ie ratings of G, PG, or PG-13)?
​
--6 By actor id, which actor id has appeared in the most films?
​
--7 What is the total replacement cost for all films with rating NC-17?
​
--8 How many of the films are in japanese?
​
--9 What is the title of the longest documentary?
​xd
--10 what is the id of the comedy with the most actors in it?

-------------------------------------------------------------------------------------------------------------------------

--1 - Which DVDRENTAL employee handled the smallest amount of  transactions?

*** ANSWER ***

 staff_id | employee_name | number_of_transactions
----------+---------------+------------------------
        1 | Mike Hillyer  |                   8040

***  QUERY ***

SELECT
    staff.staff_id AS staff_id,
    staff.first_name || ' ' || staff.last_name AS employee_name,
    COUNT(rental.rental_id) AS number_of_transactions

FROM 
    staff
    INNER JOIN rental USING(staff_id)

GROUP BY 
    1, 2

ORDER BY number_of_transactions DESC

LIMIT 1;


--2 Which R rated movie has the largest replacement cost?

*** ANSWER ***

 film_id |        title        | replacement_cost
---------+---------------------+------------------
     138 | Chariots Conspiracy |            29.99
     199 | Cupboard Sinners    |            29.99
     309 | Feud Frogmen        |            29.99
     358 | Gilmore Boiled      |            29.99
     429 | Honey Ties          |            29.99
     480 | Jeepers Wedding     |            29.99
     525 | Loathing Legally    |            29.99
     707 | Quest Mussolini     |            29.99
     759 | Salute Apollo       |            29.99
     803 | Slacker Liaisons    |            29.99
(10 rows)


*** QUERY ***

SELECT 
    film_id,
    title,
    replacement_cost

FROM film

WHERE rating = 'R'

GROUP BY film_id, title

HAVING replacement_cost = (SELECT MAX(replacement_cost) FROM film)

ORDER BY replacement_cost DESC;

--3 Get the customer ID’s of ALL customers who have spent more money than the average of all customers in the database
(PLEASE JUST WRITE THE QUERY FOR THIS ONE.)

*** QUERY ***
WITH spent_per_customer AS (
    SELECT
        customer_id, 
        SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
    ORDER BY 1)


SELECT
    customer_id,
    total_spent
FROM
    spent_per_customer
GROUP BY 1, 2
HAVING
    total_spent > (SELECT AVG(total_spent) FROM spent_per_customer)
ORDER BY 1;

--4 Return the customer IDs of customers who have spent less than $100 with the staff member who has an ID of 1.

*** QUERY ***

SELECT
    customer_id,
    SUM(amount) as total_spent
FROM payment
WHERE staff_id = 1
GROUP BY customer_id
HAVING SUM(AMOUNT) < 100
ORDER BY customer_id;

--5  Which store has made the most money from renting family-friendly films, (ie ratings of G, PG, or PG-13)?

*** ANSWER ***

 store_id | spent_by_store
----------+----------------
        2 |       18741.92

*** QUERY ***

SELECT
store.store_id,
SUM(payment.amount) as spent_by_store
FROM store 
    INNER JOIN staff USING(store_id) 
    INNER JOIN payment USING(staff_id)
    INNER JOIN rental USING(rental_id)
    INNER JOIN inventory USING(inventory_id)
    INNER JOIN film USING (film_id)
WHERE film.rating = 'G' OR film.rating = 'PG' OR film.rating = 'PG-13'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--6 By actor id, which actor id has appeared in the most films?

*** ANSWER ***

 actor_id | count
----------+-------
      107 |    42

*** QUERY ***

SELECT
actor_id,
COUNT(film_id)
FROM film_actor
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--7 What is the total replacement cost for all films with rating NC-17?

*** ANSWER ***

 nc17_total_replacement
------------------------
               19128.56

*** QUERY ***

WITH nc17_film_replacement_cost AS (
    SELECT
        inventory.film_id AS film_id,
        film.replacement_cost,
        COUNT(inventory.inventory_id) AS film_count,
        film.replacement_cost * COUNT(inventory.inventory_id) AS film_replacement_cost
        FROM inventory INNER JOIN film USING(film_id)
        WHERE film.rating = 'NC-17'
        GROUP BY 1,2
        ORDER BY 1,2)

SELECT
    SUM(film_replacement_cost) AS nc17_total_replacement
FROM
    nc17_film_replacement_cost;

--8 How many of the films are in japanese?

*** ANSWER ***
 count_japanese_films
----------------------
                    0

*** QUERY ***

SELECT COUNT(film_id) AS count_japanese_films
FROM film LEFT JOIN language USING(language_ID)
WHERE language.name = 'japanese';

--9 What is the title of the longest documentary?

*** ANSWER ***

   title   | length
-----------+--------
 Wife Turn |    183

*** QUERY ***

SELECT 
    film.title, 
    film.length
FROM film
    LEFT JOIN film_category USING(film_id) 
    LEFT JOIN category USING(category_id)
WHERE category.name = 'Documentary'
ORDER BY film.length DESC
LIMIT 1;


--10 what is the id of the comedy with the most actors in it?


*** ANSWER ***

 film_id | actor_count
---------+-------------
     188 |          13

*** QUERY ***

SELECT 
    film_actor.film_id AS film_id,
    COUNT(actor_id) AS actor_count

FROM film_actor
    LEFT JOIN film_category USING(film_id) 
    LEFT JOIN category USING(category_id)
WHERE category.name = 'Comedy'
GROUP BY film_id
ORDER BY actor_count DESC
LIMIT 1;

