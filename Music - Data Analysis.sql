USE musical_industry;

# Set1 - Easy
# 1. Who is the senior most employee based on job title?
select * from employee where title = "General Manager";
# 2. Which countries have the most Invoices?
select billing_country, count(*) as num_of_invoices from invoice
group by billing_country
order by num_of_invoices desc limit 3;
# 3.  What are top 3 values of total invoice?
select * from invoice order by total desc limit 3;
# 4. Which city has the best customers? 
select i.billing_city,count(*) as city_total from customer as c 
join invoice as i
on c.customer_id=i.customer_id 
group by i.billing_city
order by city_total desc limit 1;
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


