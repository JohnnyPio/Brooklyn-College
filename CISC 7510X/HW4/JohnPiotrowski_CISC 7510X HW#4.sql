-- John Piotrowski - HW4 - 7510x
-- SET search_path = public, "$user", public;

with msft_cts as (
	select *,
		tdate as cnt_tdate
	from cts
	where cts.symbol = 'MSFT'
),
msft_dividend as (
	select *
	from dividend
	where dividend.symbol = 'MSFT'
),
msft_splits as (
	select *
	from splits
	where splits.symbol = 'MSFT'
),
all_3_combined as (
select *
from msft_cts
left join msft_dividend on msft_cts.tdate = msft_dividend.tdate
left join msft_splits on msft_cts.tdate = msft_splits.tdate
where msft_cts.tdate = '1987-01-05'
	or msft_cts.tdate = '2004-11-12'
	or msft_cts.tdate = '2004-11-15'
	or msft_splits.tdate IS NOT NULL
	or msft_dividend.tdate IS NOT NULL
order by msft_cts.tdate asc
),
daily_prct_basic as (
	select 	*,
		-- there will need to be another column for a windowing function returning the last day's close value for div and split
		case
			WHEN dividend is null and post is null THEN (all_3_combined.close-all_3_combined.open)/all_3_combined.open
			-- WHEN dividend is not null THEN 
			-- WHEN post is not null THEN 
			else NULL
		end as daily_prct
	from all_3_combined
)
select *
	
from daily_prct_basic