-- John Piotrowski - HW5 - 7510x
-- SET search_path = public, "$user", public;

with allstocks_2013 as (
	select *
	from daily_prcnt
	where extract(year from tdate) = 2013
),
dec_symbols_only as (
	select symbol
	from allstocks_2013
	where extract(month from tdate) = 12
	group by symbol
),
cross_join as (
	select 
		s1.symbol,
		s2.symbol
	from dec_symbols_only s1
	cross join dec_symbols_only s2
),
min_max_trade_month_per_symbol as (
    select 
        symbol, 
        extract(month from min(tdate)) as first_trade_month,
        extract(month from max(tdate)) as last_trade_month
    from allstocks_2013
    group by symbol
),	
valid_2013_stocks as (
	select 
	tdate,
	allstocks_2013.symbol,
	prcnt
	from allstocks_2013
	join min_max_trade_month_per_symbol mm on allstocks_2013.symbol = mm.symbol
	where allstocks_2013.symbol not like '%-%' 			-- Filter out pink sheets and OTC Bulletin Board and other dashed symbols
		and allstocks_2013.prcnt is not null
		and first_trade_month = 1						-- Filter out stocks that weren't trading in Jan 2013 like 'ATHM'
		and last_trade_month = 12						-- Filter out stocks that weren't trading in Dec 2013
),
avg_daily_prcnt_dec2013 as (
	select 
		*, 
		avg(prcnt) as dec_avg_prcnt
	from allstocks_2013
	where extract(month from tdate) = 12
	group by symbol, tdate, prcnt
	having avg(prcnt) > 0.0 								-- Filter out stocks that lost money in dec
),
valid_dec_2013_stocks as (
	select 
		valid_2013_stocks.tdate as tdate,
		valid_2013_stocks.symbol as symbol,
		valid_2013_stocks.prcnt as prcnt
	from valid_2013_stocks
	join avg_daily_prcnt_dec2013 on avg_daily_prcnt_dec2013.symbol = valid_2013_stocks.symbol
	where extract(month from valid_2013_stocks.tdate) = 12
),
dec_trades_above_10mil as (
	select
		v.tdate,
		v.symbol,
		v.prcnt
	from valid_dec_2013_stocks v
	join cts on v.symbol = cts.symbol and v.tdate = cts.tdate
	group by v.tdate, v.symbol, v.prcnt, cts.close, cts.volume
	having cts.close * cts.volume > 10000000	-- est. daily trading total
)
-- min_prcnt_calc as (
-- 	select min(prcnt) as min_prcnt
-- 	from daily_trades_greater_than_10mil
-- ),
-- log_calcs as (
-- 	select *,
-- 	log(prcnt - min_prcnt + 1) AS shifted_log_value --Doing this to handle negative and zero value prcnts
-- 	from daily_trades_greater_than_10mil
-- 	cross join min_prcnt_calc
-- ),
-- stock_pairs_2013 as (
-- 	select
-- 		s1.tdate as tdate,
-- 		s1.symbol as stock_1,
-- 		s2.symbol as stock_2,
-- 		CONCAT(s1.symbol,':',s2.symbol) as stock_pair,	-- This should be moved out of this one
-- 		s1.shifted_log_value as s1_log,
-- 		s2.shifted_log_value as s2_log
-- 	from log_calcs s1
-- 	left join log_calcs s2 on s2.tdate = s1.tdate and s2.symbol < s1.symbol
-- 	-- where s1.symbol = 'MSFT' 
-- 	-- 	and s2.symbol = 'AAPL'
-- 	-- and s2.symbol = 'GOOG'
-- ),
-- pearson_calcs_2013 as (
-- 	select
-- 		stock_pair,
-- 		corr(s1_log, s2_log) as r
-- 	from stock_pairs_2013
-- 	group by stock_pair
-- 	having corr(s1_log, s2_log) is not null
-- ),
-- stock_pairs_dec2013 as (
-- 	select *
-- 	from stock_pairs_2013
-- 	where extract(month from tdate) = 12
-- ),
-- pearson_calcs_dec2013 as (
-- 	select
-- 		stock_pair,
-- 		corr(s1_log, s2_log) as r
-- 	from stock_pairs_dec2013
-- 	group by stock_pair
-- 	having corr(s1_log, s2_log) is not null
-- ),
-- num_trading_days_2013 as (
-- 	select count(distinct tdate) as yearly_trading_days
-- 	from valid_2013_stocks
-- ),
-- num_trading_days_dec2013 as (
-- 	select count(distinct tdate) as dec_trading_days
-- 	from valid_2013_stocks
-- 	where extract(month from tdate) = 12
-- ),
-- avg_daily_prcnt_2013 as (
-- 	select 
-- 		symbol, 
-- 		avg(prcnt) as year_avg_prcnt
-- 	from daily_trades_greater_than_10mil
-- 	group by symbol
-- ),
-- pairs_and_rs as (
-- 	select
-- 		pc.stock_pair as stock_pair,
-- 		split_part(pc.stock_pair, ':', 1) as stock_1,
-- 		split_part(pc.stock_pair, ':', 2) as stock_2,
-- 		pc.r as r_2013,
-- 		pcd.r as r_december
-- 	from pearson_calcs_2013 pc
-- 	join pearson_calcs_dec2013 pcd on pcd.stock_pair = pc.stock_pair
-- )
-- select
-- 	stock_pair,
-- 	r_2013,
-- 	r_december,
-- 	500000*(1+(ydp1.year_avg_prcnt/100)*252) + 500000*(1+(ydp2.year_avg_prcnt/100)*252) as invested_1mil_all2013,
-- 	500000*(1+(ddp1.dec_avg_prcnt/100)*22) + 500000*(1+(ddp2.dec_avg_prcnt/100)*22) as invested_1mil_dec2013
-- from pairs_and_rs
-- join avg_daily_prcnt_2013 ydp1 on ydp1.symbol = stock_1
-- join avg_daily_prcnt_dec2013 ddp1 on ddp1.symbol = stock_1
-- join avg_daily_prcnt_2013 ydp2 on ydp2.symbol = stock_2
-- join avg_daily_prcnt_dec2013 ddp2 on ddp2.symbol = stock_2
-- order by r_2013 desc
-- LIMIT 100

select *
-- from dec_symbols_only
from symbol_pair