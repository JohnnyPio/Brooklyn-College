-- John Piotrowski - HW4 - 7510x
-- SET search_path = public, "$user", public;

with msft_cts as (
	select 
	tdate as cnt_tdate,
	symbol as cnt_symbol,
	*
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
select *,
lag(close) over (partition by cnt_symbol order by cnt_tdate) as day_before_close_price
from msft_cts
left join msft_dividend on msft_cts.tdate = msft_dividend.tdate
left join msft_splits on msft_cts.tdate = msft_splits.tdate
where msft_cts.tdate = '1987-01-05'
	or msft_cts.tdate = '2003-02-14'
	or msft_cts.tdate = '2004-11-12'
	or msft_cts.tdate = '2004-11-15'
	or msft_cts.tdate = '1987-09-18'
	or msft_cts.tdate = '1987-09-17'
	or msft_splits.tdate IS NOT NULL
	or msft_dividend.tdate IS NOT NULL
order by msft_cts.tdate asc
),
daily_prct_basic as (
	select 
		*,
		case
			WHEN dividend is null and post is null THEN 100*(close-open)/open
			WHEN dividend is not null THEN 100*(close/(day_before_close_price-dividend)-1)
			WHEN post is not null THEN 100*((close/(day_before_close_price*(pre/(post*1.0))))-1)
			else NULL
		end as daily_prct
	from all_3_combined
)
select *
from daily_prct_basic