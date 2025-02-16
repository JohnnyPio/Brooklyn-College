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
with all_days_2021 as (
	select generate_series('2021-01-01'::date, '2021-12-31'::date, '1 day') as everyday
),
users_entering_floor42 as (
	select 
		count(username) as count_users,
		date(tim) as event_day
	from doorlog
	where event = 'E'
		and doorid  = 7
		and tim >= '2021-01-01 00:00:00'
		and tim < '2022-01-01 00:00:00'
	group by DATE(tim)
),
users_exiting_floor42 as(
	select 
		count(username) as count_users,
		date(tim) as event_day
	from doorlog
	where event = 'X'
		and doorid  = 7
		and tim >= '2021-01-01 00:00:00'
		and tim < '2022-01-01 00:00:00'
	group by DATE(tim)
)
select 
	all_days_2021.everyday,
	users_entering_floor42.count_users,
	users_exiting_floor42.count_users,
	coalesce(users_entering_floor42.count_users, 0) - coalesce(users_exiting_floor42.count_users, 0),
	from all_days_2021
	left join users_entering_floor42 on all_days_2021.everyday = users_entering_floor42.event_day
	left join users_exiting_floor42 on all_days_2021.everyday = users_exiting_floor42.event_day