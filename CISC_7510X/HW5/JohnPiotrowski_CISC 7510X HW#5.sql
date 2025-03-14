-- John Piotrowski - HW5 - 7510x
-- SET search_path = public, "$user", public;

with december_2013 as (
	select *,
	COUNT(DISTINCT tdate) as total_trading_days
	from daily_prcnt
	where extract(year from tdate) = 2013
		and extract(month from tdate) = 12
		-- Filter out pink sheets and OTC Bulletin Board and other dashed symbols
		and symbol not like '%-%'
	group by tdate, symbol, prcnt
	having prcnt is not null
	order by tdate asc
),
daily_trades_greater_than_10mil as (
	select
		december_2013.tdate,
		december_2013.symbol,
		december_2013.prcnt
	from december_2013
	join cts on december_2013.symbol = cts.symbol and december_2013.tdate = cts.tdate
	group by december_2013.tdate, december_2013.symbol, december_2013.prcnt, cts.close, cts.volume
	having cts.close * cts.volume > 10000000	-- est. daily trading total
),
min_prcnt_calc as (
	select min(prcnt) as min_prcnt
	from daily_trades_greater_than_10mil
),
log_calcs as (
	select *,
	log(prcnt - (select min_prcnt from min_prcnt_calc) + 1) AS shifted_log_value --Doing this to handle negative and zero value prcnts
	from daily_trades_greater_than_10mil
	order by tdate asc, shifted_log_value desc
),
stock_pairs as (
	select
		s1.tdate as tdate,
		s1.symbol as stock_1,
		s2.symbol as stock_2,
		CONCAT(s1.symbol,':',s2.symbol) as pair_key,
		s1.shifted_log_value as s1_log,
		s2.shifted_log_value as s2_log
	from log_calcs s1
	left join log_calcs s2 on s1.tdate = s2.tdate and s1.symbol != s2.symbol
),
pearson_calcs as (
	select *
	corr(s1_log, s2_log) as pearson_monthly_coeff
	from stock_pairs
	where pair_key = 'AAPL:MSFT'
	group by stock_1, stock_2, tdate, s1_log, s2_log, pair_key
)
select *
-- from december_2013
-- from daily_trades_greater_than_10mil
-- from log_calcs
from pearson_calcs
-- LIMIT 100




