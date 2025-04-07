-- John Piotrowski - HW7 - 7510x

-- 1.
--with manager_id as (
--	select managerid
--	from employee
--	where empid=42
--)
--select empid, fname, lname
--from employee
--inner join manager_id m on empid = m.managerid 

-- 2. 
--select empid, fname, lname
--from employee
--where managerid = 42

-- 3.
with recursive all_reports as (
	select empid, fname, lname
	from employee
	where managerid = 42
	union all
	select e.empid, e.fname, e.lname
	from employee e, all_reports
	where e.managerid = all_reports.empid
)
select *
from all_reports