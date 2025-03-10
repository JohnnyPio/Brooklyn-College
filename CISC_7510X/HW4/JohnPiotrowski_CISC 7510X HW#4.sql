-- John Piotrowski - HW4 - 7510x
-- SET search_path = public, "$user", public;

 CREATE TABLE public.daily_prcnt
(
    tdate date,
    symbol varchar(20),
    prcnt decimal(18,8)
);

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
), 
select 
	cts_tdate as tdate,
	cts_symbol as symbol,
	case
		-- For the full dataset, I kept getting "divide by zero" errors for each THEN statement so I added NULLIFs which slowed down the query but lets it finish. One could likely speed it up by filtering out 'prev_close' = 0 and removing the NULLIFs.
		WHEN dividend is null and post is null THEN 100*((cts_close-prev_close)/NULLIF(prev_close,0))
		WHEN dividend is not null and post is null THEN 100*((cts_close/NULLIF(prev_close-dividend,0))-1)
		WHEN post is not null and dividend is null THEN 100*(cts_close/(NULLIF((prev_close*((pre*1.0)/(post*1.0))),0))-1)
		else NULL
	end as prcnt
from all_3_tables_combined
order by cts_tdate, cts_symbol