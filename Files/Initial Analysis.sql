--1. Checking for accuracy, completeness, and reliability

--CUSTOMER TABLE:
--checking if age is in valid range
select min(age) as min_age, max(age) as max_age
from customer;
--o/p : valid(18, 80)

--checking if any age is null or negative
select age
from customer
where age is null or age < 0;
--o/p : none

--checking if any field has nulls
select * 
from customer
where customer_id is null or first is null or last is null or age is null or country is null;
--o/p : none

--checking for duplicate customer based on customer_id
select customer_id, count(*)
from customer
group by customer_id
having count(*) > 1;
--O/P: none


--ORDER TABLE:
--checking if any field has nulls
select *
from 'order'
where order_id is null or item is null or amount is null or customer_id is null
--o/p : none

--checking for duplicate orders based on order_id
select order_id, count(*)
from 'order'
group by order_id
having count(*)>1
--o/p : none

--checking for invalid amounts (if any)
select * 
from 'order'
where amount <= 0
--o/p : none


--SHIPPING TABLE:
--validating shipping status
select distinct status
from shipping
--o/p: pending, delivered

--checking for nulls in any fields
select * 
from shipping
where shipping_id is null or customer_id is null or status is null;
--o/p : none

--checking for duplicate shipments based on shipping_id
select shipping_id, count(*)
from shipping
group by shipping_id
having count(*)>1
--o/p : none


--REFERENTIAL INTEGRITY CHECKS:
--checking customer ids in orders which are not in customers
select distinct o.customer_id
from 'order' o
left join customer c 
on o.customer_id = c.customer_id
where c.customer_id is null;
--o/p : none

--checking customer ids in shipping which are not in customers
select distinct s.customer_id
from shipping s 
left join customer c 
on s.customer_id = c.customer_id
where c.customer_id is null;
--o/p : none

--INCONSISTECY CHECK
--customers who have Shipping records but no orders
select s.customer_id
from shipping s
left join 'order' o on s.customer_id = o.customer_id
where o.customer_id is null;

-- number of customers who have Shipping records but no orders
select count(s.customer_id)
from shipping s
left join 'order' o on s.customer_id = o.customer_id
where o.customer_id is null;
--O/P : 98

--customers who have orders but no shipping records
select o.customer_id
from 'order' o
left join shipping s on o.customer_id = s.customer_id
where s.customer_id is null;

--number of customers who have orders but no shipping records
select count(o.customer_id)
from 'order' o
left join shipping s on o.customer_id = s.customer_id
where s.customer_id is null;
--O/P : 94


