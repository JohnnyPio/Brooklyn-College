-- TODO: Check JOINs
-- Look at 8

-- -- 1. 
-- select description
-- from store.product
-- where product.productid=42

-- 2.
-- select
-- 	fname,
-- 	lname,
-- 	street1,
-- 	street2,
-- 	city,
-- 	customer.state,
-- 	zip
-- from store.customer
-- where customer.customerid=42

-- 3.
-- select productid
-- from store.purchase_items
-- join store.purchase on purchase.purchaseid = purchase_items.purchaseid
-- where purchase.customerid=42

-- 4.
-- select customerid
-- from store.purchase
-- join store.purchase_items on purchase_items.purchaseid = purchase.purchaseid
-- where purchase_items.productid=24

-- 5. 
-- select concat(fname,' ',lname)
-- from store.customer
-- where store.customer.customerid not in (select distinct store.purchase.customerid from store.purchase)

-- 6.
-- select description
-- from store.product
-- where store.product.productid not in (select distinct store.purchase_items.productid from store.purchase_items)

-- 7.
-- select productid
-- from store.purchase_items
-- join store.purchase on purchase.purchaseid = purchase_items.purchaseid
-- join store.customer	on customer.customerid = purchase.customerid
-- where customer.zip='10001'

-- 8.
-- select
-- 	100 * count(distinct 
-- 		case 
-- 			when purchase_items.productid = 42 then customer.customerid 
-- 		end)/
-- 	count(customer.customerid)
-- from store.purchase_items
-- join	store.purchase on purchase_items.purchaseid = purchase.purchaseid
-- join	store.customer on customer.customerid = purchase.customerid

-- 9.
-- I used ChatGPT for this one. ChatGPT prompt: For the below example 'store' schema: 
-- product(productid,description,listprice)
-- customer(customerid,username,fname,lname,street1,street2,city,state,zip)
-- purchase(purchaseid,purchasetimestamp,customerid)
-- purchase_items(itemid,purchaseid,productid,quantity,price)
-- Write a SQL query that answers this question: 
-- Of customers who purchased productid=42, what percentage also purchased productid=24?
	
-- with CustomersWhoPurchased42 as (
--     select distinct customerid
--     from store.purchase_items
--     join store.purchase on purchase_items.purchaseid = purchase.purchaseid
--     where productid = 42
-- ),
-- CustomersWhoAlsoPurchased24 as (
--     select distinct customerid
--     from store.purchase_items
--     join store.purchase on purchase_items.purchaseid = purchase.purchaseid
--     where productid = 24
--     and customerid in (select customerid from CustomersWhoPurchased42)
-- )
-- select
--     (count(*) * 100) / (select count(*) from CustomersWhoPurchased42)
-- from CustomersWhoAlsoPurchased24;

-- 10. 
-- select productid
-- from store.purchase_items
-- join store.purchase on purchase_items.purchaseid = purchase.purchaseid
-- join store.customer on purchase.customerid = customer.customerid
-- where customer.state = 'NY'
-- group by productid
-- order by count(productid) desc
-- limit 1

-- 11. 
-- select productid
-- from store.purchase_items
-- join store.purchase on purchase_items.purchaseid = purchase.purchaseid
-- join store.customer on purchase.customerid = customer.customerid
-- where customer.state in ('NJ','NY','CT')
-- group by productid
-- order by count(productid) desc
-- limit 1

-- 12. 
-- select customerid
-- from store.purchase
-- join store.purchase_items on purchase_items.purchaseid = purchase.purchaseid
-- where purchase_items.productid=24
-- and purchase.purchasetimestamp < '2020-07-04'

-- 13. Note even close
-- with LastPurchases as (
--     select
-- 		customerid,
-- 		max(purchasetimestamp)
--     from store.purchase
--     group by customerid
-- )
-- select
-- 	customer.customerid,
-- 	purchase_items.productid
-- from store.customer
-- join LastPurchases on customer.customerid = LastPurchases.customerid
-- join store.purchase on customer.customerid = purchase.customerid
-- join store.purchase_items on purchase.purchaseid = purchase_items.purchaseid


-- 15.
select concat(fname,' ',lname)
from store.customer
join store.purchase on customer.customerid = purchase.customerid 
join store.purchase_items on purchase.purchaseid = purchase_items.purchaseid
where purchase_items.productid = '42'
	and purchasetimestamp >= current_date - interval '3 months'