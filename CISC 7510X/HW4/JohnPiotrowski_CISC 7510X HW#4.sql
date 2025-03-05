-- John Piotrowski - HW4 - 7510x
-- SET search_path = public, "$user", public;

with cts as (
	select
		tdate as cts_tdate,
		symbol as cts_symbol,
		close as cts_close
	from cts
),
all_3_tables_combined as (
	select 
		*,
		lag(cts_close) over (partition by cts_symbol order by cts_tdate) as prev_close
	from cts
	left join dividend on cts_tdate = dividend.tdate and cts_symbol = dividend.symbol
	left join splits on cts_tdate = splits.tdate and cts_symbol = splits.symbol
)
select 
	cts_tdate as tdate,
	cts_symbol as symbol,
	case
		WHEN dividend is null and post is null THEN 100*((cts_close-prev_close)/prev_close)
		WHEN dividend is not null THEN 100*(cts_close/(prev_close-dividend)-1)
		WHEN post is not null THEN 100*((cts_close/(prev_close*((pre*1.0)/(post*1.0))))-1)
		else NULL
	end as prcnt
from all_3_tables_combined
where cts_tdate > '1990-01-01'
order by cts_tdate, cts_symbol