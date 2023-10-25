

# Lab | SQL Data Aggregation and Transformation


## Challenge 1

1. You need to use SQL built-in functions to gain insights relating to the duration of movies:
	- 1.1 Determine the **shortest and longest movie durations** and name the values as `max_duration` and `min_duration`.
	- 1.2. Express the **average movie duration in hours and minutes**. Dont use decimals.
      - *Hint: Look for floor and round functions.*
2. You need to gain insights related to rental dates:
	- 2.1 Calculate the **number of days that the company has been operating**.
      - *Hint: To do this, use the `rental` table, and the `DATEDIFF()` function to subtract the earliest date in the `rental_date` column from the latest date.*
	- 2.2 Retrieve rental information and add two additional columns to show the **month and weekday of the rental**. Return 20 rows of results.
	- 2.3 *Bonus: Retrieve rental information and add an additional column called `DAY_TYPE` with values **'weekend' or 'workday'**, depending on the day of the week.*
      - *Hint: use a conditional expression.*
3. You need to ensure that customers can easily access information about the movie collection. To achieve this, retrieve the **film titles and their rental duration**. If any rental duration value is **NULL, replace** it with the string **'Not Available'**. Sort the results of the film title in ascending order.
    - *Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.*
    - *Hint: Look for the `IFNULL()` function.*

4. *Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. To achieve this, you need to retrieve the **concatenated first and last names of customers**, along with the **first 3 characters of their email** address, so that you can address them by their first name and use their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make it easier to use the data.*

## Challenge 2

1. Next, you need to analyze the films in the collection to gain some more insights. Using the `film` table, determine:
	- 1.1 The **total number of films** that have been released.
	- 1.2 The **number of films for each rating**.
	- 1.3 The **number of films for each rating, sorting** the results in descending order of the number of films.
	This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
2. Using the `film` table, determine:
   - 2.1 The **mean film duration for each rating**, and sort the results in descending order of the mean duration. Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
	- 2.2 Identify **which ratings have a mean duration of over two hours** in order to help select films for customers who prefer longer movies.
3. *Bonus: determine which last names are not repeated in the table `actor`.*

USE sakila;
SELECT *
FROM film;
SELECT length
#1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
FROM sakila.film;
SELECT MAX(length) AS 'longest_movie_duration',  MIN(length) AS 'shortest_movie_duration'
FROM sakila.film;

#1.2. Express the average movie duration in hours and minutes. Don't use decimals
SELECT 
    CONCAT(
        FLOOR(AVG(length) / 60), ' hours ',
        AVG(length) % 60, ' minutes'
    ) AS average_duration
FROM 
    sakila.film;
#2.1 Calculate the number of days that the company has been operating
SELECT DATEDIFF(MAX(rental_date), MIN(rental_date)) AS days_operating
FROM sakila.rental;
# company has been operating for 266 days

#2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
SELECT rental_id,rental_date,EXTRACT(MONTH FROM rental_date) AS rental_month,EXTRACT(DAY FROM rental_date) AS weekday_rental
FROM rental
LIMIT 20;

#You need to ensure that customers can easily access information about the movie collection. 
#To achieve this, retrieve the film titles and their rental duration. 
#If any rental duration value is NULL, replace it with the string 'Not Available'. Sort the results of the film title in ascending order.
SELECT SUM(ISNULL(rental_duration))
FROM sakila.film; #Nulls verification

#3You need to ensure that customers can easily access information about the movie collection. 
#To achieve this, retrieve the film titles and their rental duration. Sort the results of the film title in ascending order.
# If any rental duration value is NULL, replace it with the string 'Not Available
#Sort the results of the film title in ascending order

SELECT title AS film_title,IFNULL(rental_duration, 'Not Available') AS 'rental_duration'
FROM sakila.film
ORDER BY rental_duration ASC;

#CHALLENGE 2
#1.1 The total number of films that have been released.
SELECT COUNT(*) AS 'total_films_released'
FROM film;
#1.2 The number of films for each rating.
SELECT rating, COUNT(*) AS number_of_films_for_each_rating
FROM sakila.film
GROUP BY rating;
#1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
#This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
SELECT rating, COUNT(*) AS 'number_of_films_for_each_rating'
FROM sakila.film
GROUP BY rating
ORDER BY COUNT(*) DESC;

#2 Using the film table, determine
#2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 
#Round off the average lengths to two decimal places. This will help identify popular movie lengths for each category.
SELECT rating, ROUND(AVG(length),2) AS 'average_film_duration'
FROM sakila.film
GROUP BY rating
ORDER BY COUNT(*) DESC;

#2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.
SELECT rating, ROUND(AVG(length),2) AS 'average_film_duration'
FROM sakila.film
GROUP BY rating 
HAVING ROUND(AVG(length),2) > 120;