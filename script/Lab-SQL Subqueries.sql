-- 1. How many copies of the film Hunchback Impossible exist in the inventory system.
select count(film_id) as No_of_Films from inventory
where film_id = (select film_id from film
				where title = "Hunchback Impossible");

-- 2. List all films whose length is longer than the average of all the films.
select film_id, title, length from film
where length > (select avg(length) from film);

-- 3. Use subqueries to display all actors who appear in the film Alone Trip.
select first_name, last_name from actor as a 
join film_actor as fa using(actor_id)
where film_id = (select film_id from film
				where title = "Alone Trip");

-- 4. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.
select title, name as Category from category 
join film_category using(category_id)
join film using(film_id)
where category_id = (select category_id from category
					where name = "Family");

/* 5.  Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, 
you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information*/

-- Using Subqueries
select concat(first_name, '  ', last_name) as Full_Name, email as Email from customer
where address_id in (select address_id from address 
			 where city_id in (
			 select city_id from city 
			 where country_id = (select country_id from country
			 where country = "Canada")));

-- Using Joins             
select concat(first_name, '  ', last_name) as Full_Name, email as Email from customer as c
join address as a using(address_id)
join city as ct using(city_id)
join country as co using(country_id)
where co.country = "Canada";

    
/* 6. Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. 
First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.*/


select film_id, title as Films from film as f
join film_actor as fa using(film_id)
where actor_id = ( select actor_id from (select actor_id, count(film_id) from film_actor
					group by actor_id
					order by count(film_id) desc
					limit 1) sub1
					);
                    
-- 7. Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments.
select film_id, title from inventory as i
join customer as c using(store_id)
join film as f using(film_id)
where customer_id = ( select customer_id from ( select customer_id, sum(amount) as Amount from payment
						group by customer_id
						order by Amount desc
						limit 1) sub1 
						)
group by film_id;

-- 8. Customers who spent more than the average payments.
select first_name, last_name, sum(amount) as Amount from payment
join customer using(customer_id)
where Amount > (select round(avg(amount),2) from payment
				where amount <> 0)
group by customer_id
order by Amount;

