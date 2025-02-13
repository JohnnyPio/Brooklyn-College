-- John Piotrowski - HW1 - 7510x
-- (needed this to test my pgadmin dummy database) SET search_path = store, "$user", public;

-- 1. 
select description
from product
where product.productid=42;

-- 2.
select
	fname,
	lname,
	street1,
	street2,
	city,
	customer.state,
	zip
from customer
where customer.customerid=42;

-- 3.
select productid
from purchase_items
join purchase on purchase.purchaseid = purchase_items.purchaseid
where purchase.customerid=42;

-- 4.
select customerid
from purchase
join purchase_items on purchase_items.purchaseid = purchase.purchaseid
where purchase_items.productid=24;

-- 5. 
select concat(fname,' ',lname)
from customer
where customer.customerid not in (select distinct purchase.customerid from purchase);

-- 6.
select description
from product
where product.productid not in (select distinct purchase_items.productid from purchase_items);

-- 7.
select productid
from purchase_items
join purchase on purchase.purchaseid = purchase_items.purchaseid
join customer on customer.customerid = purchase.customerid
where customer.zip='10001';

-- 8.
select
	100 * count(distinct 
		case 
			when purchase_items.productid = 42 then customer.customerid 
		end)/
	count(distinct customer.customerid)
from purchase_items
join purchase on purchase_items.purchaseid = purchase.purchaseid
right join customer on customer.customerid = purchase.customerid;

-- 9.
-- I used ChatGPT to help with this one so I want to credit it. ChatGPT prompt: For the below example 'store' schema: 
-- product(productid,description,listprice)
-- customer(customerid,username,fname,lname,street1,street2,city,state,zip)
-- purchase(purchaseid,purchasetimestamp,customerid)
-- purchase_items(itemid,purchaseid,productid,quantity,price)
-- Write a SQL query that answers this question: 
-- Of customers who purchased productid=42, what percentage also purchased productid=24?
	
with CustomersWhoPurchased42 as (
    select distinct customerid
    from purchase_items
    join purchase on purchase_items.purchaseid = purchase.purchaseid
    where productid = 42
),
CustomersWhoAlsoPurchased24 as (
    select distinct customerid
    from purchase_items
    join purchase on purchase_items.purchaseid = purchase.purchaseid
    where productid = 24
    and customerid in (select customerid from CustomersWhoPurchased42)
)
select
    (count(*) * 100) / (select count(*) from CustomersWhoPurchased42)
from CustomersWhoAlsoPurchased24;

-- 10. 
select productid
from purchase_items
join purchase on purchase_items.purchaseid = purchase.purchaseid
join customer on purchase.customerid = customer.customerid
where customer.state = 'NY'
group by productid
order by count(productid) desc
limit 1;

-- 11. 
select productid
from purchase_items
join purchase on purchase_items.purchaseid = purchase.purchaseid
join customer on purchase.customerid = customer.customerid
where customer.state in ('NJ','NY','CT')
group by productid
order by count(productid) desc
limit 1;

-- 12. 
select customerid
from purchase
join purchase_items on purchase_items.purchaseid = purchase.purchaseid
where purchase_items.productid=24
and purchase.purchasetimestamp < '2020-07-04';

-- 13.
with LatestPurchase as (
	select customerid, 
	max(purchasetimestamp) as last_purchase_time
	from purchase
	group by customerid
)
select LatestPurchase.customerid, purchase_items.productid
from LatestPurchase
join purchase on LatestPurchase.last_purchase_time = purchase.purchasetimestamp
join purchase_items on purchase.purchaseid = purchase_items.purchaseid;

-- 14. Credit to Adil in the BC Spring 2025 Whatsapp on this one :) 
with CustomerPurchasesPartitionedbyID as (
    select 
        p.customerid, 
        p.purchaseid, 
        pi.productid, 
        pr.description,
        row_number() over (partition by p.customerid order by p.purchasetimestamp desc) as rownum
    from purchase p
    join purchase_items pi on p.purchaseid = pi.purchaseid
    join product pr on pi.productid = pr.productid
)
select customerid, productid, description, rownum
from CustomerPurchasesPartitionedbyID
where rownum <= 10
order by customerid asc, rownum asc;

-- 15.
select concat(fname,' ',lname)
from customer
join purchase on customer.customerid = purchase.customerid 
join purchase_items on purchase.purchaseid = purchase_items.purchaseid
where purchase_items.productid = '42'
	and purchasetimestamp >= current_date - interval '3 months'