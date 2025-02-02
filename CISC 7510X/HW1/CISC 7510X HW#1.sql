-- -- 1. 
-- select
-- 	description
-- from
-- 	store.product
-- where
-- 	product.productid=42

-- 2.
select
	fname,
	lname,
	street1,
	street2,
	city,
	state,
	zip
from
	store.customer
where
	customer.customerid=42