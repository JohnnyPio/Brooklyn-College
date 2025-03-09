-- Last classes: 
sql: ddl, dml
ddl: create table statements...
dml: crud operations, insert/select/update/delete

select f1,f2,f3 from blah -- projection
select * from blah where f1-'whatever' --selection (filtering)

--union (combine output of both queries)  
select f1,f2 from blah 
union 
select f1,f2 from glah; 

-- difference (set difference)
select f1,f2 from blah 
except 
select f1,f2 from glah

--sets: {1,2,3} union {2,3,4} => {1,2,3,4}
-- "union" is expensive to do b/c you need to eliminate dups so there's "union all" 				***

--internal logic to eliminate dups:
--store unique values in hash table, and output hash keys.
--sort the data, eliminate consecutive dups.

-- difference (set difference)
select f1,f2 from blah 
except 
select f1,f2 from glah

-- another way to implement is via join:
select a.f1,a.f2
from blah a
	left outer join glah b
	on a.f1=b.f1 and a.f2=b.f2
where b.f1 is null and b.f2 is null

-- JOINS

rel1(a,b,c)
	join
rel2(c,d,e,f)

result => rel3(a,b,c,c,d,e,f)

-- join types: 
inner join (default), left outer join, right outer join, full outer join

-- CTEs: useful for breaking up big queries into smaller steps (eliminating inner joins)
-- 			also, eliminates need for sub-queries
with blah as(
	select ... from glah
)
select *
from blah;
)

-- Subqueries
-- Subqueries are ugly and gets hard to decipher
select count(*)
from (
	select f1,f2 from glah
	inner join something
)

-- ** "I prefer to isolate sql code into .sql files"


-----------------
--today's class, we want to look at a new kind of relation
-----------------
/*
we already related records (row)
we want to relate DIFFERENT records (different rows)
e.g. get me the record before like lead() and lag (see Gdoc)

Windowing functions are aggregate functions that operate on a window
Defined by counting records before and after
Defined by taking the current timestamp and subtracting 20 mins
	This was defined in 2003, this is "new"
	Enables you to take rolling totals

In trad SQL, there is no ordering of the tuples
With relations, order does matter */

select a.*,
	min(price) over (partition by tdate,symbol 
		order by tim 
		rows between unbounded preceding and current row),
	max(price) over (partition by tdate,symbol 
		order by tim 
		rows between unbounded preceding and current row) 
from test_trades a 
where tdate='2010-01-01' 
order by 1,2,3;

--
quotes
trades

with q1 as (
	select a.*,
		lead(tim) over (partittion by tdate,symbol order by tim) next_quote_tim
	from quote a
),
t1 as (
select a.*, b.bid, b.ofr
from trades a 
	inner join q1 b					-- this inner join became a problem when electronic trading became commonplace and it was too much volume
	on a.tdate = b.tdate
	and a.tim >= q.tim 
	and a.tim < coalesce(q.next_quote_tim, 99999)
)
-- Flag if price is below or above quote price
select *
from t1
where price < bid || price > offer

-- So instead of join (n^2 problems), they used last_value which is a windowing function and was orders of magnitude faster

----------------- BREAK

/* 
MATCH_RECOGNIZE in trino is VERY cool. It provides for regex matching on a sequence of rows.
regexp_match is a projection
*/

-- last 10 products for each customer
with purchases as (
select a.*,
	row_number() over (partition by cid order by tim desc) rn  
from purchase a
)
select a.*
from purhcase a
where rn <= 10    -- last 10 purchases


--- occupancy
+1 	1
+1	2
+1	3
+1 	4
-1	3	
-1	2 		-- at this time there were 2 people
with tots as (
select a.*,
	sum(case when typ='E' thne 1 when typ="X" then -1 else 0 end)
		over(partittion by doorid order by tim) tot
from doorlog a
where doorid = 47
)
select cast(tim as date) tdate,
	max(tot) maxtot
from tots
group by tdate

-- will have a midterm in 3-4 classes 
it will be multiple choice