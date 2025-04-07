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
--with recursive chain_of_managers as (
--	select *, 0 as levels_above
--	from employee
--	where empid = 42 or empid = 24
--	union all
--	select e.*, levels_above + 1
--	from employee e, chain_of_managers c
--	where e.empid = c.managerid
--)
--select *, count(empid) over (partition by empid) as cnt
--from chain_of_managers c
--where empid != 42 and empid != 24
--group by empid, c.fname, c.lname, c.managerid, c.departmentid, c.employee_rank, c.levels_above
--order by levels_above asc
--limit 1

-- 13.
with recursive chain_of_managers as (
	select *, 0 as levels_above
	from employee
	where empid = 42 or empid = 24
	union all
	select e.*, levels_above + 1
	from employee e, chain_of_managers c
	where e.empid = c.managerid
), 
most_immediate_manager as (
	select *, count(empid) over (partition by empid) as cnt
	from chain_of_managers c
	where empid != 42 and empid != 24
	group by empid, c.fname, c.lname, c.managerid, c.departmentid, c.employee_rank, c.levels_above
	order by levels_above asc
	limit 1
),
chain_of_managers_42 as (
	select *, 0 as levels_above_42
	from employee
	where empid = 42
	union all
	select e.*, levels_above_42 + 1
	from employee e, chain_of_managers_42 c
	where e.empid = c.managerid
)
select *
from chain_of_managers_42 c
cross join most_immediate_manager imm
where imm.empid = c.empid

--chain_of_managers_24 as (
--	select *, 0 as levels_above
--	from employee
--	where empid = 24
--	union all
--	select e.*, levels_above + 1
--	from employee e, chain_of_managers_24 c
--	where e.empid = c.managerid
--),
--most_immediate_manager as (
--	select *, count(empid) over (partition by empid) as cnt
--	from chain_of_managers c
--	where empid != 42 and empid != 24
--	group by empid, c.fname, c.lname, c.managerid, c.departmentid, c.employee_rank, c.levels_above
--	order by levels_above asc
--	limit 1
--)






--both_chains as (
--	select *
--	from chain_of_managers_42 c42
--	full outer join chain_of_managers_24 c24 on c42.empid = c24.empid
----	where c42.empid != 42 and c24.empid != 24
----	limit 1
--)
--select *
--from both_chains