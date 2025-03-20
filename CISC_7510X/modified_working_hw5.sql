-- John Piotrowski - HW5 - 7510x
-- SET search_path = public, "$user", public;

with valid_stocks_2013 as (
	select *
	from daily_prcnt
	where extract(year from tdate) = 2013
		and symbol not like '%-%' 			-- Filter out pink sheets and OTC Bulletin Board and other dashed symbols
		and prcnt is not null
),
valid_stocks_dec as (
	select * 
	from valid_stocks_2013 v
	where extract(month from tdate) = 12
),
trades_above_10mil_2013 as (
	select
		valid_stocks_2013.tdate,
		valid_stocks_2013.symbol,
		valid_stocks_2013.prcnt
	from valid_stocks_2013
	join cts on valid_stocks_2013.symbol = cts.symbol and valid_stocks_2013.tdate = cts.tdate
	group by valid_stocks_2013.tdate, valid_stocks_2013.symbol, valid_stocks_2013.prcnt, cts.close, cts.volume
	having cts.close * cts.volume > 10000000	-- est. daily trading total
),
trades_above_10mil_dec as (
	select *
	from trades_above_10mil_2013 
	where extract(month from tdate) = 12
),
min_prcnt_calc_dec as (
	select min(prcnt) as min_prcnt_dec
	from valid_stocks_dec
),
log_calcs_dec as (
	select *,
	log(prcnt - min_prcnt_dec + 1) AS shifted_log_value --Doing this to handle negative and zero value prcnts
	from trades_above_10mil_dec
	cross join min_prcnt_calc_dec
),
stock_pairs_2013 as (
	select
		s1.tdate as tdate,
		s1.symbol as stock_1,
		s2.symbol as stock_2,
		CONCAT(s1.symbol,':',s2.symbol) as stock_pair,
		s1.shifted_log_value as s1_log,
		s2.shifted_log_value as s2_log
	from log_calcs_dec s1
	left join log_calcs_dec s2 on s2.tdate = s1.tdate and s2.symbol < s1.symbol
--	 where s1.symbol = 'MSFT' 
--	 	and s2.symbol in ('AAPL','ATHM','GOOG')
),
stock_pairs_dec as (
	select *
	from stock_pairs_2013
	where extract(month from tdate) = 12
),
pearson_calcs_dec as (
	select
		stock_pair,
		corr(s1_log, s2_log) as r
	from stock_pairs_dec
	group by stock_pair
	having corr(s1_log, s2_log) is not null
),
avg_daily_prcnt_dec as (
	select 
		symbol, 
		avg(prcnt) as dec_avg_prcnt
	from trades_above_10mil_dec
	group by symbol
),
pairs_and_rs_dec as (
	select
		stock_pair as stock_pair,
		split_part(stock_pair, ':', 1) as stock_1,
		split_part(stock_pair, ':', 2) as stock_2,
		r as r_dec
	from pearson_calcs_dec
	where stock_pair not like '%ATHM%'		-- This stock only started trading mid-December (@TODO find a better way to filter this)
),
investment_calcs_dec as (
	select
		stock_pair,
		stock_1,
		stock_2,
		r_dec,
		500000*(1+(ddp1.dec_avg_prcnt/100)*22) + 500000*(1+(ddp2.dec_avg_prcnt/100)*22) as invested_1mil_dec2013
	from pairs_and_rs_dec
	join avg_daily_prcnt_dec ddp1 on ddp1.symbol = stock_1
	join avg_daily_prcnt_dec ddp2 on ddp2.symbol = stock_2
	order by invested_1mil_dec2013 desc, r_dec desc
	limit 10
),
best_stocks_2013 as (     
    select stock_1 as stock from investment_calcs_dec
    union 
    select stock_2 as stock from investment_calcs_dec
    order by stock
),
min_prcnt_calc_2013 as (
	select
		min(prcnt) as min_prcnt_2013
	from valid_stocks_2013 v
	join best_stocks_2013 best on best.stock = v.symbol
),
log_calcs_2013 as (
	select *,
	log(prcnt - min_prcnt_2013 + 1) AS shifted_log_value --Doing this to handle negative and zero value prcnts
	from trades_above_10mil_2013 t
	join best_stocks_2013 best on best.stock = t.symbol
	cross join min_prcnt_calc_2013
),
pearson_calcs_2013 as (
	select
		sp.stock_pair,
		corr(s1_log, s2_log) as r_2013
	from stock_pairs_2013 sp
	join investment_calcs_dec icd on icd.stock_pair = sp.stock_pair
	group by sp.stock_pair
	having corr(s1_log, s2_log) is not null
),
avg_daily_prcnt_2013 as (
	select 
		symbol, 
		avg(prcnt) as year_avg_prcnt
	from trades_above_10mil_2013
	group by symbol
),
investment_calcs_2013 as (
	select
		icd.stock_pair,
		stock_1,
		stock_2,
		r_dec,
		invested_1mil_dec2013,
		r_2013,
		500000*(1+(ydp1.year_avg_prcnt/100)*252) + 500000*(1+(ydp2.year_avg_prcnt/100)*252) as invested_1mil_all2013
	from investment_calcs_dec icd
	join pearson_calcs_2013 pc on pc.stock_pair = icd.stock_pair
	join avg_daily_prcnt_2013 ydp1 on ydp1.symbol = stock_1
	join avg_daily_prcnt_2013 ydp2 on ydp2.symbol = stock_2
	order by invested_1mil_dec2013 desc, r_dec desc
	limit 50
)
select *
from investment_calcs_2013 
