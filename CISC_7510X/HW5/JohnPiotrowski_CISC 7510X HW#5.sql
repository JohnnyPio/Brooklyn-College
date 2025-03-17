-- John Piotrowski - HW5 - 7510x
SET search_path = public, "$user", public;

with num_trading_days_2013 as (
	select count(distinct tdate) as yearly_trading_days
	from daily_prcnt
	where extract(year from tdate) = 2013
),
num_trading_days_dec2013 as (
	select count(distinct tdate) as dec_trading_days
	from daily_prcnt
	where extract(year from tdate) = 2013
	and extract(month from tdate) = 12
),
valid_2013_stocks as (
	select *
	from daily_prcnt
	where extract(year from tdate) = 2013
		and symbol not like '%-%' 			-- Filter out pink sheets and OTC Bulletin Board and other dashed symbols
		and prcnt is not null
	group by tdate, symbol, prcnt
	having extract(month from min(tdate)) = '01'		-- Filter out stocks that weren't trading in January 2013 like 'ANTH'
),
daily_trades_greater_than_10mil as (
	select
		valid_2013_stocks.tdate,
		valid_2013_stocks.symbol,
		valid_2013_stocks.prcnt
	from valid_2013_stocks
	join cts on valid_2013_stocks.symbol = cts.symbol and valid_2013_stocks.tdate = cts.tdate
	cross join num_trading_days_2013
	group by valid_2013_stocks.tdate, valid_2013_stocks.symbol, valid_2013_stocks.prcnt, cts.close, cts.volume
	having cts.close * cts.volume > 10000000	-- est. daily trading total
),
min_prcnt_calc as (
	select min(prcnt) as min_prcnt
	from daily_trades_greater_than_10mil
),
log_calcs as (
	select *,
	log(prcnt - min_prcnt + 1) AS shifted_log_value --Doing this to handle negative and zero value prcnts
	from daily_trades_greater_than_10mil
	cross join min_prcnt_calc
),
stock_pairs_2013 as (
	select
		s1.tdate as tdate,
		s1.symbol as stock_1,
		s2.symbol as stock_2,
		CONCAT(s1.symbol,':',s2.symbol) as stock_pair,
		s1.shifted_log_value as s1_log,
		s2.shifted_log_value as s2_log
	from log_calcs s1
	left join log_calcs s2 on s2.tdate = s1.tdate and s2.symbol < s1.symbol
	-- where s1.symbol like '%ATHM%' 
	-- 	-- and s2.symbol like '%AAPL%'
),
pearson_calcs_2013 as (
	select
		stock_pair,
		corr(s1_log, s2_log) as r
	from stock_pairs_2013
	group by stock_pair
	having corr(s1_log, s2_log) is not null
),
stock_pairs_dec2013 as (
	select *
	from stock_pairs_2013
	where extract(month from tdate) = 12
),
pearson_calcs_dec2013 as (
	select
		stock_pair,
		corr(s1_log, s2_log) as r
	from stock_pairs_dec2013
	group by stock_pair
	having corr(s1_log, s2_log) is not null
),
avg_daily_prcnt_2013 as (
	select 
		symbol, 
		avg(prcnt) as year_avg_prcnt
	from daily_trades_greater_than_10mil
	group by symbol
),
avg_daily_prcnt_dec2013 as (
	select 
		symbol, 
		avg(prcnt) as dec_avg_prcnt
	from daily_trades_greater_than_10mil
	where extract(month from tdate) = 12
	group by symbol
),
pairs_and_rs as (
	select
		pc.stock_pair as stock_pair,
		split_part(pc.stock_pair, ':', 1) as stock_1,
		split_part(pc.stock_pair, ':', 2) as stock_2,
		pc.r as r_2013,
		pcd.r as r_december
	from pearson_calcs_2013 pc
	inner join pearson_calcs_dec2013 pcd on pcd.stock_pair = pc.stock_pair
),
calculate_investments as (
	select
		stock_pair,
		500000*(1+(ydp1.year_avg_prcnt/100)*yearly_trading_days) + 500000*(1+(ydp2.year_avg_prcnt/100)*yearly_trading_days) as invested_1mil_all2013,
		500000*(1+(ddp1.dec_avg_prcnt/100)*dec_trading_days) + 500000*(1+(ddp2.dec_avg_prcnt/100)*dec_trading_days) as invested_1mil_dec2013
	from pairs_and_rs
	join avg_daily_prcnt_2013 ydp1 on ydp1.symbol = stock_1
	join avg_daily_prcnt_dec2013 ddp1 on ddp1.symbol = stock_1
	join avg_daily_prcnt_2013 ydp2 on ydp2.symbol = stock_2
	join avg_daily_prcnt_dec2013 ddp2 on ddp2.symbol = stock_2
	cross join num_trading_days_2013
	cross join num_trading_days_dec2013
)
select
	prs.stock_pair,
	stock_1,
	stock_2,
	r_2013,
	r_december,
	ci.invested_1mil_all2013,
	ci.invested_1mil_dec2013
	from pairs_and_rs prs
	join calculate_investments ci on ci.stock_pair = prs.stock_pair
	order by ci.invested_1mil_dec2013 desc
	limit 10
