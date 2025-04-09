-- John Piotrowski - HW7 - 7510x

-- 1.
--with manager_id as (
--	select managerid
--	from employee
--	where empid = 42
--)
--select empid, fname, lname
--from employee
--inner join manager_id m on empid = m.managerid 

-- 2. 
--select empid, fname, lname
--from employee
--where managerid = 42

-- 3.
--with recursive chain_of_reports as (
--	select empid, fname, lname
--	from employee
--	where managerid = 42
--	union all
--	select e.empid, e.fname, e.lname
--	from employee e, chain_of_reports
--	where e.managerid = chain_of_reports.empid
--)
--select *
--from chain_of_reports

-- 4.
--with recursive chain_of_reports as (
--	select empid, fname, lname
--	from employee
--	where managerid = 42
--	union all
--	select e.empid, e.fname, e.lname
--	from employee e, chain_of_reports
--	where e.managerid = chain_of_reports.empid
--)
--select count(*)
--from chain_of_reports

-- 5.
--with recursive chain_of_managers as (
--	select *
--	from employee
--	where empid = 42
--	union all
--	select e.*
--	from employee e, chain_of_managers
--	where e.empid = chain_of_managers.managerid
--)
--select *
--from chain_of_managers
--where empid != 42

-- 6.
--with recursive chain_of_managers as (
--	select *, 0 as levels_above
--	from employee
--	where empid = 42
--	union all
--	select e.*, levels_above + 1
--	from employee e, chain_of_managers
--	where e.empid = chain_of_managers.managerid
--)
--select *
--from chain_of_managers
--where employee_rank = 'SVP'
--order by levels_above asc
--limit 1

-- 7.
--with recursive chain_of_managers as (
--	select *, 0 as levels_above
--	from employee
--	where empid = 42
--	union all
--	select e.*, levels_above + 1
--	from employee e, chain_of_managers
--	where e.empid = chain_of_managers.managerid
--)
--select levels_above
--from chain_of_managers
--where employee_rank = 'SVP'
--order by levels_above asc
--limit 1

-- 8.
--with recursive chain_of_managers as (
--	select *, 0 as levels_above
--	from employee
--	where empid = 42
--	union all
--	select e.*, levels_above + 1
--	from employee e, chain_of_managers
--	where e.empid = chain_of_managers.managerid
--)
--select levels_above
--from chain_of_managers
--where employee_rank = 'CEO' 	--assuming only one CEO at this company, which is typical

-- 9.
--with recursive chain_of_reports as (
--	select *, 1 as levels_below
--	from employee
--	where managerid = 42
--	union all
--	select e.*, levels_below + 1
--	from employee e, chain_of_reports
--	where e.managerid = chain_of_reports.empid
--)
--select coalesce(max(levels_below),0)
--from chain_of_reports

-- 10.
--with recursive chain_of_managers as (
--	select *, 0 as levels_above
--	from employee
--	where empid = 42
--	union all
--	select e.*, levels_above + 1
--	from employee e, chain_of_managers
--	where e.empid = chain_of_managers.managerid
--	and chain_of_managers.employee_rank != 'CEO'	--Stop recursion at CEO title
--)
--select *
--from chain_of_managers

-- 11.
--with recursive chain_of_managers as (
--	select *, 0 as levels_above
--	from employee
--	where empid = 42
--	union all
--	select e.*, levels_above + 1
--	from employee e, chain_of_managers c
--	where e.empid = c.managerid
--	and (c.fname,c.lname) != ('John', 'Doe')
--)
--select *
--from chain_of_managers

-- 12.
with recursive chain_of_managers_42 as (
	select *, 0 as levels_above_42
	from employee
	where empid = 42
	union all
	select e.*, levels_above_42 + 1
	from employee e, chain_of_managers_42 c
	where e.empid = c.managerid
),
chain_of_managers_24 as (
	select *, 0 as levels_above_24
	from employee
	where empid = 24
	union all
	select e.*, levels_above_24 + 1
	from employee e, chain_of_managers_24 c
	where e.empid = c.managerid
)
select man42.empid, man42.fname, man42.lname
from chain_of_managers_42 man42
inner join chain_of_managers_24 man24 on man42.empid = man24.empid
order by levels_above_42 asc
limit 1

-- 13.
with recursive chain_of_managers_42 as (
	select *, 0 as levels_above_42
	from employee
	where empid = 42
	union all
	select e.*, levels_above_42 + 1
	from employee e, chain_of_managers_42 c
	where e.empid = c.managerid
),
chain_of_managers_24 as (
	select *, 0 as levels_above_24
	from employee
	where empid = 24
	union all
	select e.*, levels_above_24 + 1
	from employee e, chain_of_managers_24 c
	where e.empid = c.managerid
),
most_immediate_common_manager as (
	select man42.empid as empid, man42.fname as fname, man42.lname as lname, levels_above_42, levels_above_24
	from chain_of_managers_42 man42
	inner join chain_of_managers_24 man24 on man42.empid = man24.empid
	order by levels_above_42 asc
	limit 1
),
up_from_42 as (
	select empid, fname, lname, levels_above_42
	from chain_of_managers_42
	where levels_above_42 < (select levels_above_42 from most_immediate_common_manager)		-- only show the top-level manager on the way down so '<' not '<='
),
down_to_24 as (
	select empid, fname, lname, 0 as levels_below_common_manager
	from employee
	where empid = (select empid from most_immediate_common_manager)
	union all
	select e.empid, e.fname, e.lname, levels_below_common_manager + 1
	from employee e, down_to_24
	where e.managerid = down_to_24.empid
	and exists (			-- This acts as a way to prune irrelevant branches that don't traverse to empid 24
        select *
        from chain_of_managers_24 c
        where c.empid = e.empid
    )
),
stitch_together_paths as (
	select empid, fname, lname
	from up_from_42
	union all
	select empid, fname, lname
	from down_to_24
)
select *
from stitch_together_paths 
