
SELECT * FROM album;
SELECT * FROM artist;
SELECT * FROM customer;
SELECT * FROM employee;
SELECT * FROM genre;
SELECT * FROM invoice;
SELECT * FROM invoice_line;
SELECT * FROM media_type;
SELECT * FROM playlist;
SELECT * FROM playlist_track;
SELECT * FROM track;

--1) Who is the senior most employee bases on job title?
SELECT * FROM employee
ORDER BY levels DESC LIMIT 1;

--2)Which countries have the most invoice?
SELECT billing_country, COUNT(billing_country) AS total_invoice FROM invoice
GROUP BY billing_country
ORDER BY total_invoice DESC;

--3)What are top 3 values of total invoice
SELECT total FROM invoice
ORDER BY total DESC limit 3;

--4)Which city has the best customers? We would like to throw a promotioinal Music Festival in the city we made the most money. Write a query that return one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
SELECT billing_city, SUM(total) AS Total_sale FROM invoice
GROUP BY billing_city
ORDER BY Total_sale DESC LIMIT 1;



--5)Find the customer who spent the most money. Return the customer name and total amount spent.
SELECT c.first_name,c.last_name,SUM(i.total) AS total_spend
FROM customer c
JOIN invoice i ON c.customer_id= i.customer_id
GROUP BY c.first_name,c.last_name
ORDER BY total_spend DESC
LIMIT 1;


--6) Write query to return the email, first name, last name, & Genre of all Rock Music listeners. Return your list ordered alphabetically by email starting with A.
SELECT DISTINCT c.first_name,c.last_name,c.email,g.name 
FROM Customer c
JOIN invoice i ON c.customer_id=i.customer_id
JOIN invoice_line l ON i.invoice_id=l.invoice_id
JOIN track t ON l.track_id=t.track_id
JOIN genre g ON t.genre_id=g.genre_id
WHERE g.name = 'Rock'
ORDER BY c.email;


--7)Find top 10 artists who wrote the most rock songs in the dataset, and show artist name with total track count.
SELECT a.name, COUNT(t.track_id) AS total_track
FROM artist a
JOIN album ab ON a.artist_id = ab.artist_id
JOIN track t ON ab.album_id = t.album_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY a.name
ORDER BY total_track DESC
LIMIT 10;

--8) Return all the track names that have a song length longer than the average song length. Return the Name and milliseconds for each track. Order by the song length with the longest songs listed first.
SELECT name,milliseconds FROM track
WHERE milliseconds>(SELECT AVG(milliseconds) FROM track)
ORDER BY milliseconds DESC;


--9) Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent.
SELECT c.first_name AS Customer_name,a.name AS Artist_name,SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i ON c.customer_id=i.customer_id
JOIN invoice_line il ON i.invoice_id=il.invoice_id
JOIN track t ON t.track_id=il.track_id
JOIN album al ON t.album_id=al.album_id
JOIN artist a ON al.artist_id=a.artist_id
GROUP BY c.customer_id, a.artist_id
ORDER BY total_spent DESC;


--10)Find the most popular music genre for each country based on highest purchases. Return country and top genre. If multiple genres have same highest purchases, return all.
WITH popular_genre AS (
SELECT i.billing_country AS Country,g.name AS Genre,COUNT(il.invoice_line_id) AS purchases,
RANK() OVER(PARTITION BY i.billing_country ORDER BY COUNT(il.invoice_line_id) DESC) AS rnk
FROM invoice i
JOIN invoice_line il ON i.invoice_id=il.invoice_id
JOIN track t ON il.track_id=t.track_id
JOIN genre g ON g.genre_id=t.genre_id
GROUP BY i.billing_country,g.name
)
SELECT country,genre,purchases from popular_genre
where rnk=1;


--11)Find the highest spending customer in each country.
WITH high_c AS (SELECT c.first_name AS name,i.billing_country AS country,SUM(i.total) AS total_spent,
RANK() OVER(PARTITION BY i.billing_country ORDER BY SUM(i.total) DESC) AS RNK
FROM customer c
JOIN invoice i ON c.customer_id=i.customer_id
GROUP BY c.first_name,i.billing_country
)
select name,country,total_spent
FROM high_c
WHERE RNK = 1;



