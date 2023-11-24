USE musical_industry;

# Set1 - Easy
# 1. Who is the senior most employee based on job title?
select employee_id, CONCAT(first_name,' ',last_name) as Name, title as Title, levels, email from employee 
order by levels desc limit 1;
# 2. Which countries have the most Invoices?
select billing_country, count(*) as num_of_invoices from invoice
group by billing_country
order by num_of_invoices desc limit 3;
# 3.  What are top 3 values of total invoice?
select * from invoice order by total desc limit 3;
# 4. Which city has the best customers? 
select i.billing_city,count(*) as No_of_customers from customer as c 
join invoice as i
on c.customer_id=i.customer_id 
group by i.billing_city
order by No_of_customers desc limit 1;
# 5. returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals
select * from invoice;
select billing_city as City, sum(total) as Sum_of_invoice from invoice
group by billing_city
order by Sum_of_invoice desc limit 1;
# 6. Who is the best customer?  Write a query that returns the person who has spent the most money
select * from customer;
select concat(c.first_name," ",c.last_name) as BestCustomer_Name, sum(i.total) as Total from customer c 
join invoice i on c.customer_id=i.customer_id
group by BestCustomer_Name
order by Total desc limit 1;

#Set2 - Moderate
# 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
# Return your list ordered alphabetically by email starting with A
select * from customer;
select * from genre;
select c.first_name, c.last_name, c.email from customer c 
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join genre g on t.genre_id=g.genre_id
where g.name='rock'
order by c.email ; 
# 2. Let's invite the artists who have written the most rock music in our dataset. 
# Write a query that returns the Artist name and total track count of the top 10 rock bands. 
select a.name as Artist_Name, count(a.artist_id) as Rock_Track from artist a 
join album ab on a.artist_id=ab.artist_id
join track t on ab.album_id=t.album_id
join genre g on t.genre_id=g.genre_id
where g.name='rock'
group by Artist_Name
order by Rock_Track desc
limit 10;
# 3. Return all the track names that have a song length longer than the average song length. 
# Return the Name and Milliseconds for each track. 
# Order by the song length with the longest songs listed first
select * from track;
select avg(milliseconds) as Avg_Song_Length from track;
select name, milliseconds from track
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;

# Set3 - Advance
# 1. Find how much amount spent by each customer on artists? 
# Write a query to return customer name, artist name and total spent
select CONCAT(c.first_name,' ',c.last_name) as Customer_Name, 
ar.name as Artist_name, i.total as Total_Spent from customer c 
join invoice i on c.customer_id=i.customer_id
join invoice_line il on i.invoice_id=il.invoice_id
join track t on il.track_id=t.track_id
join album a on t.album_id=a.album_id
join artist ar on a.artist_id=ar.artist_id;

# 2. We want to find out the most popular music Genre for each country. 
# We determine the most popular genre as the genre with the highest amount of purchases. 
# Write a query that returns each country along with the top Genre. 
# For countries where the maximum number of purchases is shared return all Genres
with pmg as (
select c.country as Country, COUNT(il.invoice_id) as Purchases, g.name as Genre_Name,
rank() over (partition by c.country order by count(il.invoice_id) desc) as PurchaseRank
from customer c 
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join genre g on t.genre_id = g.genre_id
group by c.country, g.name
)
select Country, Purchases, Genre_Name from pmg
where PurchaseRank = 1;

# 3.query that determines the customer that has spent the most on music for each country. 
# Write a query that returns the country along with the top customer and how much they spent. 
# For countries where the top amount spent is shared, provide all customers who spent this amount
with customer_spending as (
select c.country as Country, c.customer_id as Customer_ID,CONCAT(c.first_name,' ',c.last_name) as Customer_Name,
sum(i.total) as Total_Spending from customer c
join invoice i on c.customer_id = i.customer_id
group by Country, Customer_ID, Customer_Name
)
select Country, Customer_Name,Total_Spending from (
select Country, Customer_Name, Total_Spending, 
rank() over (partition by Country order by Total_Spending desc) as rnk
from customer_spending
) ranked
WHERE rnk = 1;