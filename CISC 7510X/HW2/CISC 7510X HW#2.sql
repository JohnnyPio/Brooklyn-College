-- John Piotrowski - HW2 - 7510x
SET search_path = main, "$user", public;

-- 1.
-- I was a bit unclear about the wording of this question - I interpreted it as total users not distinct users.
-- select count(username)
-- from doorlog
-- where event = 'E'
-- 	and doorid = 1;

-- 2.
-- with users_entering_2 as (
-- 	select count(username) as count_users
-- 	from doorlog
-- 	where event = 'E'
-- 		and doorid = 2
-- ),
-- users_exiting_2 as(
-- 	select count(username) as count_users
-- 	from doorlog
-- 	where event = 'X'
-- 		and doorid = 2
-- )
-- select users_entering_2.count_users - users_exiting_2.count_users
-- from users_entering_2, users_exiting_2;

-- 3.
-- with users_entering_frontandback as (
-- 	select count(username) as count_users
-- 	from doorlog
-- 	where event = 'E'
-- 		and doorid in (2, 3)
-- ),
-- users_exiting_frontandback as(
-- 	select count(username) as count_users
-- 	from doorlog
-- 	where event = 'X'
-- 		and doorid in (2, 3)
-- )
-- select users_entering_frontandback.count_users - users_exiting_frontandback.count_users
-- from users_entering_frontandback, users_exiting_frontandback;

-- 4.
-- with users_entering_frontandback as (
-- 	select count(username) as count_users
-- 	from doorlog
-- 	where event = 'E'
-- 		and doorid in (2, 3)
-- 		and tim <= '2024-07-04 22:00:00'
-- ),
-- users_exiting_frontandback as(
-- 	select count(username) as count_users
-- 	from doorlog
-- 	where event = 'X'
-- 		and doorid in (2, 3)
-- 		and tim <= '2024-07-04 22:00:00'
-- )
-- select users_entering_frontandback.count_users - users_exiting_frontandback.count_users
-- from users_entering_frontandback, users_exiting_frontandback;

-- 5.
-- @TODO fix
-- with all_days_2021 as (
-- 	select generate_series('2021-01-01'::date, '2021-12-31'::date, '1 day') as everyday
-- ),
-- users_entering_floor42 as (
-- 	select 
-- 		count(username) as count_users,
-- 		date(tim) as event_day
-- 	from doorlog
-- 	where event = 'E'
-- 		and doorid  = 7
-- 		and tim >= '2021-01-01 00:00:00'
-- 		and tim < '2022-01-01 00:00:00'
-- 	group by DATE(tim)
-- ),
-- users_exiting_floor42 as(
-- 	select 
-- 		count(username) as count_users,
-- 		date(tim) as event_day
-- 	from doorlog
-- 	where event = 'X'
-- 		and doorid  = 7
-- 		and tim >= '2021-01-01 00:00:00'
-- 		and tim < '2022-01-01 00:00:00'
-- 	group by DATE(tim)
-- )
-- select 
-- 	all_days_2021.everyday,
-- 	users_entering_floor42.count_users,
-- 	users_exiting_floor42.count_users,
-- 	coalesce(users_entering_floor42.count_users, 0) - coalesce(users_exiting_floor42.count_users, 0),
-- 	from all_days_2021
-- 	left join users_entering_floor42 on all_days_2021.everyday = users_entering_floor42.event_day
-- 	left join users_exiting_floor42 on all_days_2021.everyday = users_exiting_floor42.event_day

-- 6.


-- 7.
-- with all_users_entering_floor42 as (
-- 	select username
-- 	from doorlog
-- 	where event = 'E'
-- 		and doorid  = 2
-- ),
-- all_users as (
-- 	select username
-- 	from doorlog
-- )
-- select
-- 	100 * count(distinct all_users_entering_floor42.username)/count(distinct all_users.username)
-- from all_users
-- left join all_users_entering_floor42 on all_users.username = all_users_entering_floor42.username;

-- 8.
-- with users_entering_bathroom as (
-- 	select 
-- 		username,
-- 		tim
-- 	from doorlog
-- 	where event = 'E'
-- 		and doorid  = 2
-- ),
-- calculations as (
-- 	select 
-- 		cast(count(username) as decimal(18,8)) as total_users_dec,
-- 		cast(count(distinct username) as decimal(18,8)) as total_distinct_users_dec,
-- 		cast(count(distinct DATE(tim)) as decimal(18,8)) as total_distinct_dates_dec
-- 	from users_entering_bathroom
-- )
-- select cast(total_users_dec/total_distinct_users_dec/total_distinct_dates_dec as decimal(18,8))
-- from calculations;

-- 9.
with users_entering_frontandback as (
	select count(username) as count_users
	from doorlog
	where event = 'E'
		and doorid in (2, 3)
		and tim <= '2024-07-03 22:00:00'
),
users_exiting_frontandback_after_515 as(
	select count(username) as count_users
	from doorlog
	where event = 'X'
		and doorid in (2, 3)
		and tim >= '2024-07-03 17:15:00'
)
select users_entering_frontandback.count_users - users_exiting_frontandback_after_515.count_users
from users_entering_frontandback, users_exiting_frontandback_after_515;