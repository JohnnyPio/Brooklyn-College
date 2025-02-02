-- -- 1. 
-- select
-- 	description
-- from
-- 	store.product
-- where
-- 	product.productid=42

-- 2.
-- select
-- 	fname,
-- 	lname,
-- 	street1,
-- 	street2,
-- 	city,
-- 	state,
-- 	zip
-- from
-- 	store.customer
-- where
-- 	customer.customerid=42

-- 3.
-- select
-- 	productid
-- from
-- 	store.purchase_items
-- join
-- 	store.purchase
-- 	on
-- 	purchase.purchaseid = purchase_items.purchaseid
-- where
-- 	purchase.customerid=42

-- 4.
-- select
-- 	customerid
-- from
-- 	store.purchase
-- join
-- 	store.purchase_items
-- 	on
-- 	purchase_items.purchaseid = purchase.purchaseid
-- where
-- 	purchase_items.productid=42

-- 5. 
-- select
-- 	fname,
-- 	lname
-- from 
-- 	store.customer
-- where
-- 	store.customer.customerid not in (select distinct store.purchase.customerid from store.purchase)

-- 6.
select
	description
from 
	store.product
where
	store.product.productid not in (select distinct store.purchase_items.productid from store.purchase_items)

