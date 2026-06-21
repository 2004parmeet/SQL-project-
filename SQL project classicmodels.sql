
-- 1. Customers with no orders.

use classicmodels ;
select c.customername , o.ordernumber from customers c
left join orders o on 
c.customernumber = o.customernumber
where ordernumber is null ;

-- 2. Second-highest sales customer.

select o1.customernumber , sum(o.priceeach * o.quantityordered) as total_amount 
from orderdetails o
join orders o1 on o.ordernumber = o1.ordernumber
group by o1.customernumber
order by sum(o.priceeach) 
desc limit 1
offset 1;

-- 3. Monthly sales trend.

select month(paymentdate) ,year(paymentdate), sum(amount) from payments 
group by year(paymentdate) , month(paymentdate)
order by year(paymentdate) , month(paymentdate) ;

-- 4. Top 3 product lines by revenue.

select p.productline, sum(quantityordered*priceeach) as revenue 
from orderdetails o 
left join products p
on o.productcode = p.productcode
group by p.productline
order by revenue desc
limit 3 ;

-- 5. Employee-manager hierarchy 

select e.firstname as manager, 
m.firstname as employee 
from employees e join employees m
on m.reportsto= e.employeenumber;

-- 6. Running total of sales using window functions. 

select quantityordered * priceeach as sales ,
sum(quantityordered*priceeach) over (order by ordernumber) as running_total 
from orderdetails;

-- 7. Rank customers by revenue. 

select c.customernumber , c.customername ,sum(o1.quantityordered*priceeach) as sales,
dense_rank() over(order by sum(o1.quantityordered*priceeach) desc) as rnk
from orders o join
customers c on o.customernumber = c.customernumber
join orderdetails o1
on o.ordernumber = o1.ordernumber
group by c.customernumber , c.customername ;

-- 8.  Orders above average order value.

with cte as 
(select ordernumber, sum(quantityordered * priceeach) 
as order_value from orderdetails
group by ordernumber)
select * from cte where order_value > (select avg(order_value) from cte);


-- 9. Find duplicate records.  

select customername , count(*) as duplicates from customers
group by customername having count(*) > 2;

-- 10. Find total quantity sold for each product.
 
 select p.productname,
 sum(quantityordered) as total_quantity_sold
 from products as p join orderdetails as o
 on p.productcode=o.productcode
 group by p.productname;


