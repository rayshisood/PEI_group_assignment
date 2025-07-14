--1. the total amount spent and the country for the Pending delivery status for each country

select c.country,
	   sum(f.amount) as total_amount_spent
  from fact_order f
  join dim_customer c
    on f.customer_id = c.customer_id
  join dim_shipping_status s
    on f.shipping_status_id = s.shipping_status_id
  where s.status_label = 'pending'
  group by c.country;

--2. the total number of transactions, total quantity sold, and total amount spent for each customer, along with the product details.

select c.customer_id,
       c.full_name,
       p.item_name,
       count(distinct f.order_id) as total_transactions,
       sum(f.quantity) as total_quantity,
       sum(f.amount) as total_amount_spent
  from fact_order f
  join dim_customer c
    on f.customer_id = c.customer_id
  join dim_product p
    on f.product_id = p.product_id
  group by c.customer_id,
           c.full_name,
           p.item_name;
		   
--3. the maximum product purchased for each country.

with cte_product_counts as
(
select c.country,
       p.item_name,
       count(*) as purchase_count,
       rank() over (partition by c.country order by count(*) desc) as rank_pos
  from fact_order f
  join dim_customer c
    on f.customer_id = c.customer_id
  join dim_product p 
    on f.product_id = p.product_id
  group by c.country,
           p.product_name
)
select country,
       item_name,
       purchase_count
  from cte_product_counts
  where rank_pos = 1;
  
--4. the most purchased product based on the age category less than 30 and above 30.

with cte_age_product_counts as (
select c.age_group,
       p.item_name,
       count(*) as purchase_count,
       rank() over (partition by c.age_group order by count(*) desc) as rank_pos
  from fact_order f
  join dim_customer c
    on f.customer_id = c.customer_id
  join dim_product p
    on f.product_id = p.product_id
  group by c.age_group,
           p.item_name
)
select age_group,
       item_name,
       purchase_count
  from cte_age_product_counts
  where rank_pos = 1;
  
--5. the country that had minimum transactions and sales amount.

with cte_country_summary as (
select c.country,
       count(f.order_id) as transaction_count,
       sum(f.amount) as total_sales
  from fact_order f
  join dim_customer c
    on f.customer_id = c.customer_id
  group by c.country
)
select country,
       transaction_count,
       total_sales
  from cte_country_summary
  order by transaction_count,
           total_sales
  limit 1;



