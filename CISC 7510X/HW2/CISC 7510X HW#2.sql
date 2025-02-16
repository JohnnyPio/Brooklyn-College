-- John Piotrowski - HW2 - 7510x
SET search_path = main, "$user", public;

-- 1.
-- I was a bit unclear about the wording of this question - I interpreted it as total users not distinct users.
select count(username)
from doorlog
where event = 'E'
	and doorid = 1

-- 2.
-- select count(username)
-- from doorlog
-- where event = 'E'