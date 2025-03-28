-- John Piotrowski - HW2 - 7510x
-- (pgadmin vars) SET search_path = main, "$user", public;

-- 1.
-- I was a bit unclear about the wording of this question - I interpreted it as total users not distinct users.
select count(username)
from doorlog
where event = 'E'
	and doorid = 1;

-- 2.
--I assumed that I didn't need to filter the timestamp on the current day and could just use all-time numbers to get the final calcs.
with users_entering_2 as (
	select count(username) as count_users
	from doorlog
	where event = 'E'
		and doorid = 2
),
users_exiting_2 as(
	select count(username) as count_users
	from doorlog
	where event = 'X'
		and doorid = 2
)
select users_entering_2.count_users - users_exiting_2.count_users
from users_entering_2, users_exiting_2;

-- 3.
--I assumed that I didn't need to filter the timestamp on the current day and could just use all-time numbers to get the final calcs.
with users_entering_frontandback as (
	select count(username) as count_users
	from doorlog
	where event = 'E'
		and doorid in (1, 3)
),
users_exiting_frontandback as(
	select count(username) as count_users
	from doorlog
	where event = 'X'
		and doorid in (1, 3)
)
select users_entering_frontandback.count_users - users_exiting_frontandback.count_users
from users_entering_frontandback, users_exiting_frontandback;

-- 4.
assuming July 4th, 2024 
with users_entering_frontandback as (
	select count(username) as count_users
	from doorlog
	where event = 'E'
		and doorid in (1, 3)
		and tim <= '2024-07-04 22:00:00'
),
users_exiting_frontandback as(
	select count(username) as count_users
	from doorlog
	where event = 'X'
		and doorid in (1, 3)
		and tim <= '2024-07-04 22:00:00'
)
select users_entering_frontandback.count_users - users_exiting_frontandback.count_users
from users_entering_frontandback, users_exiting_frontandback;

-- 5.
-- Added exits in case of users occupying overnight
with all_days_2021 as (
	select generate_series('2021-01-01'::date, '2021-12-31'::date, '1 day') as everyday
),
users_entering_floor42 as (
	select 
		username,
		tim
	from doorlog
	where event = 'E'
		and doorid  = 7
		and tim >= '2021-01-01 00:00:00'
		and tim < '2022-01-01 00:00:00'
),
users_exiting_floor42 as(
	select 
		username,
		tim
	from doorlog
	where event = 'X'
		and doorid  = 7
		and tim >= '2021-01-01 00:00:00'
		and tim < '2022-01-01 00:00:00'
),
calculations as (
	select
	all_days_2021.everyday as all_days,
	(count(distinct users_entering_floor42.username)+count(distinct users_exiting_floor42.username))/2 as average_occupancy
	from all_days_2021
	left join users_entering_floor42 on all_days_2021.everyday = date(users_entering_floor42.tim)
	left join users_exiting_floor42 on all_days_2021.everyday = date(users_exiting_floor42.tim)	
	group by all_days
)
select all_days, average_occupancy
from calculations;
-- 6.
select 
	sum(average_occupancy)/count(all_days) as avg_daily_occupancy,
	stddev(average_occupancy)
from calculations;

-- 7.
with all_users_entering_floor42 as (
	select username
	from doorlog
	where event = 'E'
		and doorid  = 7
),
all_users as (
	select username
	from doorlog
),
calculations as (
	select
		cast(count(distinct all_users_entering_floor42.username) as decimal(18,8)) as distinct_floor_42_users,
		cast(count(distinct all_users.username) as decimal(18,8)) as all_users
	from all_users
	left join all_users_entering_floor42 on all_users.username = all_users_entering_floor42.username
)
select 100 * distinct_floor_42_users/all_users
from calculations;


-- 8.
with users_entering_bathroom as (
	select 
		username,
		tim
	from doorlog
	where event = 'E'
		and doorid  = 2
),
calculations as (
	select 
		cast(count(username) as decimal(18,8)) as total_users_dec,
		cast(count(distinct username) as decimal(18,8)) as total_distinct_users_dec,
		cast(count(distinct DATE(tim)) as decimal(18,8)) as total_distinct_dates_dec
	from users_entering_bathroom
)
select 
	cast(total_users_dec/total_distinct_users_dec/total_distinct_dates_dec as decimal(18,8)) as avg_bath_trips_per_day_per_person
from calculations;

-- 9.
with users_exiting_frontandback_after_515 as(
	select username
	from doorlog
	where event = 'X'
		and doorid in (1, 3)
		and tim > '2022-07-03 17:15:00'
		and tim < '2022-07-04 00:00:00'
),
calculations as (
	select 
		cast(count(distinct doorlog.username) as decimal(18,8)) as total_employees,
		cast(count(distinct users_exiting_frontandback_after_515.username) as decimal(18,8)) as total_employees_staying_late
	from doorlog
	full outer join users_exiting_frontandback_after_515 on doorlog.username = users_exiting_frontandback_after_515.username
)
select total_employees_staying_late/total_employees * 100
from calculations;

-- 10.
select 
	username
from doorlog
where event = 'X'
	and doorid in (7)
	and tim < '2022-07-03 17:30:00'
	and tim >= '2022-07-03 00:00:00';
