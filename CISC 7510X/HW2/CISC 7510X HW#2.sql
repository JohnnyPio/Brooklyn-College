-- John Piotrowski - HW2 - 7510x
SET search_path = main, "$user", public;

-- 1.
-- I was a bit unclear about the wording of this question - I interpreted it as total users not distinct users.
-- select count(username)
-- from doorlog
-- where event = 'E'
-- 	and doorid = 1

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
-- from users_entering_2, users_exiting_2

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
-- from users_entering_frontandback, users_exiting_frontandback

-- 4.
with users_entering_frontandback as (
	select count(username) as count_users
	from doorlog
	where event = 'E'
		and doorid in (2, 3)
		and tim <= '2024-07-04 22:00:00'
),
users_exiting_frontandback as(
	select count(username) as count_users
	from doorlog
	where event = 'X'
		and doorid in (2, 3)
		and tim <= '2024-07-04 22:00:00'
)
select users_entering_frontandback.count_users - users_exiting_frontandback.count_users
from users_entering_frontandback, users_exiting_frontandback