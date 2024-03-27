create database if not exists WalmartSalesData; -- creating the database for walmart sales

create table if not exists sales(
	invoice_id varchar(30) NOT NULL PRIMARY KEY
  , branch varchar(10) NOT NULL
  , city varchar(40) NOT NULL
  , customer_type varchar(15) NOT NULL
  , gender varchar(15) NOT NULL
  , product_line varchar(40) NOT NULL
  , unit_price decimal(10, 2) NOT NULL
  , quantity int NOT NULL
  , tax float(6, 4) NOT NULL
  , total decimal(12, 4) NOT NULL
  , date datetime NOT NULL
  , times time NOT NULL
  , payment_method varchar(30) NOT NULL
  , cogs decimal(8, 4) NOT NULL
  , gross_margin_pct float(11, 9)
  , gross_income decimal(12, 5)
  , rating float(2, 1)
  );
  
  -- creating the columns in the sales table -----------------------------
  -- ---------------------------------------------------------------------
 select 
	*
		from
			sales;
-- -------------This if for me to see what all the columns look like------

        
       
-- -----------------------------Feature Engineering------------------------
        
        
select
	times
  , (case 
		when `times` between "00:00:00" and "12:00:00" then 'Morning'
        when `times` between "12:01:00" and "16:00:00" then 'Afternoon'
        when `times` between "16:01:00" and "20:00:00" then 'Evening'
        else 'Night'
	  end
        ) as time_of_day
	from
		sales;
	 -- Adding a column to the sales table to indicate time of day-----------------------
    alter table sales
		add column time_of_day varchar(20);
     -- ---------------------------------------------------------------------------------
        
-- Update time_of_day column to include the time of day after doing select --------------
	update sales 
    set time_of_day = (
    case 
		when `times` between "00:00:00" and "12:00:00" then 'Morning'
        when `times` between "12:01:00" and "16:00:00" then 'Afternoon'
        when `times` between "16:01:00" and "20:00:00" then 'Evening'
        else 'Night'
	  end
    );
    
-- ------------------------ adding the day name of purchase --------------------------------
select
	date
  , dayname(date) Day_Name
		from
        sales;
        
alter table sales
add column day_name varchar(12);

update sales
set day_name = dayname(date);
-- ---------------------- month name and the amount per each month --------------------------
select
	date
  , monthname(date) month_name
		from
			sales;
            
alter table sales
add column month_name varchar(15);

update sales
set month_name = monthname(date);            
-- ----------------------------------------------------------------------------------------

-- ----------------------------------------------------------------------------------------

-- --------------------------------------- Generic ----------------------------------------

-- ----------------------- How many unique cities does the data have? -----------------------

select distinct
	city
		from 
			sales;
            
select distinct
	branch
		from 
			sales;
-- In which city is each branch? ------------------------------------
select distinct
	city
  , branch
		from
			sales;
            
-- ------------------------------------------ Product ----------------------------------------

-- How many unique product lines does the data have? -----------------------------------------

select
	*
from
	sales;
    
select 
	  count(distinct product_line) number_of_products
from
	sales;
-- What is the most common payment method? ---------------------------------------
select
	*
from
	sales;
select
	payment_method
  , count(payment_method) as most_common_payment_method
from
	sales
    group by
		payment_method
			order by most_common_payment_method desc;
-- What is the most selling product line? ---------------------------------------
select
	*
from
	sales;
select
	product_line
  , count(product_line) as most_common_product_line
from
	sales
		group by
			product_line
				order by most_common_product_line desc;
-- What is the total revenue by month? --------------------------------------
select
	*
from
	sales;

select
	month_name
  , sum(gross_income) as total_revenue
  from
	sales
		group by month_name
			order by total_revenue desc;
-- What month had the largest COGS? --------------------------------------------------------
select
	*
from
	sales;
    
select
	month_name
  , sum(cogs) as total_cogs
from
	sales
		group by month_name
			order by total_cogs desc;
-- What product line had the largest revenue? --------------------------------------------------
select
	*
from
	sales;
    
select
	product_line
  , sum(gross_income) as total_revenue
from
	sales
		group by product_line
			order by total_revenue desc;
-- What is the city with the largest revenue? ----------------------------------------------------
select
	*
from
	sales;

select 
	city
  , branch
  , sum(gross_income) as total_revenue
from
	sales
		group by city, branch
			order by total_revenue desc;
-- What product line had the largest tax? -------------------------------------------------------------
select
	*
from
	sales;

select
	product_line
  , avg(tax) as average_tax
from
	sales
		group by
			product_line
				order by average_tax desc;
-- --------------- Indicating which product line is good or bad ----------------------------------------
select
	*
from
	sales;

select
	product_line
  , avg(quantity) as average_quantity_sold
from
	sales
		group by product_line
			order by average_quantity_sold desc;
-- the query above is to just get an idea of the averages of the quantity sold

select
	product_line
  , case
		when avg(quantity) < 6 then 'bad'
        else 'good'
        end as 'marking'
from
	sales
		group by product_line;
			
	
-- Which brand sold the most product than average product sold? ------------------------------------------
select
	*
from
	sales;

select
	branch
  , sum(quantity) as total_product_line
from
	sales
		group by branch
			having sum(quantity) > (select
										avg(quantity) 
											from
												sales
														) -- I included a nested query inside so that we can grab the average quanity and compare it to the sum
				order by total_product_line desc;

-- What is the most common product line by gender? -------------------------------------
select
	*
from
	sales;
select
	gender
  , product_line
  , count(gender) as total_gender_count
from
	sales
		group by gender , product_line
			order by total_gender_count desc;

-- What is the average rating of each product line? -------------------------------------
select
	*
from
	sales;

select
	product_line
  , ROUND(avg(rating), 2) as average_rating
from
	sales
		group by product_line
			order by average_rating desc;

-- ------------------------------- Sales ----------------------------------------------------

-- What is the number of sales made in each time of the day per weekday? --------------------
select
	*
from
	sales;

select
	time_of_day
  , count(*) as total_sales
from
	sales
		where day_name = 'Monday'
			group by time_of_day
				order by total_sales desc;

-- Which of the customer types brings the most revenue? ----------------------------------------
select
	*
from
	sales;
select
	customer_type
  , sum(total) as total_income
from
	sales
		group by customer_type
			order by total_income desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)? -------------------------------

select
	*
from
	sales;
    
select
	city
  , sum(tax) as total_tax
from
	sales
		group by city
			order by total_tax desc;
            
-- I wanted to include what the informaion would look like if we included both the sum and the average tax for the cities, proving that Naypyitaw pays more than the others.

select
	city
  , avg(tax) as average_tax
from
	sales
		group by city
			order by average_tax desc;

-- Which customer type pays the most in VAT? ----------------------------------------------------
select
	*
from
	sales;    
    
select
	customer_type
  , sum(tax) as total_customer_tax
from
	sales
		group by customer_type
			order by total_customer_tax desc;
            
-- I wanted to include what the informaion would look like if we included both the sum and the average tax for the members, proving that members pay more than normal customers.
select
	customer_type
  , avg(tax) as average_customer_tax
from
	sales
		group by customer_type
			order by average_customer_tax desc;

-- -------------------------------------- Customers -----------------------------------------------
-- How many unique customer types does the data have? ---------------------------------------------
select
	*
from
	sales;

select
	count(distinct (customer_type)) as unique_customers
from
	sales;
    
-- How many unique payment methods does the data have? ---------------------------------------------
select
	*
from
	sales;

select
	count(distinct (payment_method)) as unique_payment_method
from
	sales;

-- What is the most common customer type? ----------------------------------------------------------
select
	*
from
	sales;
    
select
	customer_type
  , count(customer_type) as total_customer_type
from
	sales
		group by customer_type
			order by total_customer_type desc;

-- Which customer type buys the most? ----------------------------------------------------------------
select
	*
from
	sales;
select
	customer_type
  , sum(quantity) as total_purchases
from
	sales
		group by customer_type
			order by total_purchases desc;
            
-- What is the gender of most of the customers? --------------------------------------------------------
select
	*
from
	sales;
select
	gender
 ,  count(customer_type) as total_customers
from
	sales
		group by gender
			order by total_customers desc;
            
-- What is the gender distribution per branch? ----------------------------------------------------------
select
	*
from
	sales;
    
select
	branch
  , gender
  , count(gender) as dist_gender
from
	sales
		group by branch, gender
			order by branch asc;

-- Which time of the day do customers give most ratings? --------------------------------------------------
select
	*
from
	sales;

select
	time_of_day
  , count(rating) as number_of_rating
from
	sales
		group by time_of_day
			order by number_of_rating;

-- Which time of the day do customers give most ratings per branch? ------------------------------------------
select
	*
from
	sales;

select
	time_of_day
  , branch
  , count(rating) as number_of_rating
from
	sales
		group by time_of_day , branch
			order by branch asc;
            
-- Which day of the week has the best avg ratings? -------------------------------------------------------------
select
	*
from
	sales;
    
select
	day_name
  , avg(rating) as average_rating
from
	sales
		group by day_name
			order by average_rating desc;
            
-- Which day of the week has the best average ratings per branch? -----------------------------------------------
select
	*
from
	sales;
    
select
	day_name
  , branch
  , avg(rating) as average_rating
from
	sales
		group by day_name , branch
			order by branch , average_rating desc;