-- John Piotrowski - HW5 - 7510x
-- SET search_path = public, "$user", public;

with valid_2013_stocks as (
	select *
	from daily_prcnt
	where extract(year from tdate) = 2013
		and extract(month from tdate) = 12
		and symbol not like '%-%' 			-- Filter out pink sheets and OTC Bulletin Board and other dashed symbols
	group by tdate, symbol, prcnt
	having prcnt is not null
),
daily_trades_greater_than_10mil as (
	select
		valid_2013_stocks.tdate,
		valid_2013_stocks.symbol,
		valid_2013_stocks.prcnt
	from valid_2013_stocks
	join cts on valid_2013_stocks.symbol = cts.symbol and valid_2013_stocks.tdate = cts.tdate
	group by valid_2013_stocks.tdate, valid_2013_stocks.symbol, valid_2013_stocks.prcnt, cts.close, cts.volume
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
		CONCAT(s1.symbol,':',s2.symbol) as stock_pair,
		s1.shifted_log_value as s1_log,
		s2.shifted_log_value as s2_log
	from log_calcs s1
	left join log_calcs s2 on s2.tdate = s1.tdate and s2.symbol < s1.symbol
	where s1.symbol like '%MSFT%'
),
pearson_calcs as (
	select
		stock_pair,
		corr(s1_log, s2_log) as pearson_monthly_coeff
	from stock_pairs
	group by stock_pair
	having corr(s1_log, s2_log) is not null
	order by pearson_monthly_coeff desc
)
	select *
	from pearson_calcs
