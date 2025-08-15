drop table if exists retail_sales;
create table retail_sales(
transactions_id int,	
sale_date date,
sale_time time,
customer_id int,
gender varchar(15),
age int,
category varchar(15),
quantity int,
price_per_unit float,
cogs float,
total_sale float
);
select count(*) from retail_sales

--data cleaning
select * from retail_sales
limit 10
where transactions_id is null
OR
sale_date is null
or 
sale_time is null
or
gender is null
or 
category is null
or 
quantiy is null
or 
cogs is null
or 
total_sale is null
--deleted null rows to clean data
delete from retail_sales
where transactions_id is null
OR
sale_date is null
or 
sale_time is null
or
gender is null
or 
category is null
or 
quantiy is null
or 
cogs is null
or 
total_sale is null

--data exploration

--how many sales do we have
select count(*) as total_sale from retail_sales

--how many unique customers do we have
select count(distinct customer_id) as total_sale from retail_sales

--what are the unique categories we have
select distinct category as categories from retail_sales

--Data Analysis and Business Key Problems
-- Q.1 Write an SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write an SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write an SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write an SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write an SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write an SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write an SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write an SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write an SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write an SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

--Solutions
-- Q.1 Write an SQL query to retrieve all columns for sales made on '2022-11-05
--Sol.1
select * from retail_sales 
where sale_date='2022-11-05'

--Q.2 Write an SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than equal to 4 in the month of Nov-2022
select *
from retail_sales
where category='Clothing'
and 
TO_CHAR(sale_date,'YYYY-MM')='2022-11'
and quantity>=4

-- Q.3 Write an SQL query to calculate the total sales (total_sale) for each category.
select 
category,
sum(total_sale) as total_sales,
count(*) as total_orders
from retail_sales
group by category
order by sum(total_sale) desc

-- Q.4 Write an SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select round(avg(age),2) as avg_age
from retail_sales
where category='Beauty'

--Q.5 Write an SQL query to find all transactions where the total_sale is greater than 1000.
select * from retail_sales
where total_sale>1000

-- Q.6 Write an SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select 
category,
gender,
count(*) as total_trans
from retail_sales
group by category, gender
order by total_trans desc

-- vv imp Q.7 Write an SQL query to calculate the average sale for each month. Find out best selling month in each year.
select year,
month,
avg_sale
from 
(	select 
	extract(year from sale_date) as year,
	extract(month from sale_date) as month,
	avg(total_sale) as avg_sale,
	--window function being used for partitioning by year and ordering by the avg sales, so that the month in the respective year having max avg gets the highest rank 
	rank() over(partition by extract(year from sale_date) order by avg(total_sale) desc ) as rank
	from retail_sales
	group by year,month
) 
as t1
where rank=1

---- Q.8 Write an SQL query to find the top 5 customers based on the highest total sales 
--Sol.
select 
customer_id as customer_id,
sum(total_sale) as total_sale
from retail_sales
group by customer_id
order by total_sale desc
limit 5 

-- Q.9 Write an SQL query to find the distinct number of buyers for each category
--Sol.
select 
category,
count(distinct customer_id) as buyers
from retail_sales
group by category


-- Q.10 Write an SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sales
as
(select *,
	case
		when extract (hour from sale_time)<12 then 'Morning'
		when extract (hour from sale_time)between 12 and 17 then 'Afternoon' 
		else 'Evening'
	end as shift
from retail_sales)
select 
shift,
count(transactions_id) as orders
from hourly_sales
group by shift






