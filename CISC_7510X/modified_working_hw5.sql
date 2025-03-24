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
	from valid_stocks_2013
	where extract(month from tdate) = 12
	and symbol in ('TSEM','PATH','CALI','BGMD','ELMD','ALIM','OCLS')
),
min_trade_month_per_symbol as (
    select 
        symbol, 
        extract(month from min(tdate)) as first_trade_month
    from valid_stocks_2013
    group by symbol
),	
trades_above_10mil_dec as (
	select 
		v.tdate,
		v.symbol,
		v.prcnt
	from valid_stocks_dec v
	join cts on v.symbol = cts.symbol and v.tdate = cts.tdate
	join min_trade_month_per_symbol mtm on mtm.symbol = v.symbol
	where first_trade_month = 1					-- filter stocks like ATHM that didn't exist in Jan 2013
	group by v.tdate, v.symbol, v.prcnt, cts.close, cts.volume
	having cts.close * cts.volume > 10000000	-- est. daily trading total
),
avg_daily_prcnt_dec as (
	select 
		symbol, 
		avg(prcnt) as dec_avg_prcnt
	from trades_above_10mil_dec
	group by symbol
	order by dec_avg_prcnt desc
	limit 25
),
best_10_stock_pairs_dec as (
	select	
		s1.symbol as stock_1,
		s2.symbol as stock_2,
		CONCAT(s1.symbol,':',s2.symbol) as stock_pair,
		500000*(1+(s1.dec_avg_prcnt/100)*22) + 500000*(1+(s2.dec_avg_prcnt/100)*22) as invested_1mil_dec2013
	from avg_daily_prcnt_dec s1
	left join avg_daily_prcnt_dec s2 on s1.symbol < s2.symbol
	where s1.symbol is not null
		and s2.symbol is not null
	order by invested_1mil_dec2013 desc
	limit 10
),
best_stocks_as_list_dec as (     
    select stock_1 as stock from best_10_stock_pairs_dec
    union 
    select stock_2 as stock from best_10_stock_pairs_dec
    order by stock
),
filtered_prcnt as (
	select *
	from valid_stocks_dec v
	join best_stocks_as_list_dec l on v.symbol = l.stock
),
min_prcnt_calc_dec as (
	select 
	min(prcnt) as min_prcnt_dec
	from filtered_prcnt
),
log_calcs_dec as (
	select *,
	log(prcnt - min_prcnt_dec + 1) AS shifted_log_value --Doing this to handle negative and zero value prcnts
	from filtered_prcnt
	cross join min_prcnt_calc_dec
),
stock_pairs_logs_dec as (
	select
		s1.tdate,
		s2.tdate,
		stock_1,
		stock_2,
		stock_pair,
		invested_1mil_dec2013,
		s1.shifted_log_value as s1_log,
		s2.shifted_log_value as s2_log
	from best_10_stock_pairs_dec best
	join log_calcs_dec s1 on stock_1 = s1.symbol
	join log_calcs_dec s2 on stock_2 = s2.symbol
	where s1.tdate = s2.tdate
),
pearson_calcs_dec as (
	select
		stock_1,
		stock_2,
		stock_pair,
		corr(s1_log, s2_log) as r_dec
	from stock_pairs_logs_dec
	group by stock_pair, stock_1, stock_2
	having corr(s1_log, s2_log) is not null
),
investment_calcs_dec as (
	select
		best.stock_pair,
		best.stock_1,
		best.stock_2,
		best.invested_1mil_dec2013,
		pcs.r_dec
	from best_10_stock_pairs_dec best
	left join pearson_calcs_dec pcs on pcs.stock_pair = best.stock_pair
	order by invested_1mil_dec2013 desc
)
select * from investment_calcs_dec



-- 2013 onlys
--stock_pairs_2013 as (
--	select
--		s1.tdate as tdate,
--		s1.symbol as stock_1,
--		s2.symbol as stock_2,
--		CONCAT(s1.symbol,':',s2.symbol) as stock_pair,
--		s1.shifted_log_value as s1_log,
--		s2.shifted_log_value as s2_log
-- not configed for 2013 vv
--	from log_calcs_dec s1
--	join log_calcs_dec s2 on s2.tdate = s1.tdate and s2.symbol < s1.symbol
--),
--trades_above_10mil_2013 as (
--	select
--		valid_stocks_2013.tdate,
--		valid_stocks_2013.symbol,
--		valid_stocks_2013.prcnt
--	from valid_stocks_2013
--	join cts on valid_stocks_2013.symbol = cts.symbol and valid_stocks_2013.tdate = cts.tdate
--	group by valid_stocks_2013.tdate, valid_stocks_2013.symbol, valid_stocks_2013.prcnt, cts.close, cts.volume
--	having cts.close * cts.volume > 10000000	-- est. daily trading total
--),
--min_prcnt_calc_2013 as (
--	select
--		min(prcnt) as min_prcnt_2013
--	from valid_stocks_2013 v
--	join best_pairs_dec best on best.stock = v.symbol
--),
--log_calcs_2013 as (
--	select *,
--	log(prcnt - min_prcnt_2013 + 1) AS shifted_log_value --Doing this to handle negative and zero value prcnts
--	from trades_above_10mil_2013 t
--	join best_pairs_dec best on best.stock = t.symbol
--	cross join min_prcnt_calc_2013
--),
--pearson_calcs_2013 as (
--	select
--		sp.stock_pair,
--		corr(s1_log, s2_log) as r_2013
--	from stock_pairs_2013 sp
--	join investment_calcs_dec icd on icd.stock_pair = sp.stock_pair
--	group by sp.stock_pair
--	having corr(s1_log, s2_log) is not null
--),
--avg_daily_prcnt_2013 as (
--	select 
--		symbol, 
--		avg(prcnt) as year_avg_prcnt
--	from trades_above_10mil_2013
--	group by symbol
--),
--investment_calcs_2013 as (
--	select
--		icd.stock_pair,
--		stock_1,
--		stock_2,
--		r_dec,
--		invested_1mil_dec2013,
--		r_2013,
--		500000*(1+(ydp1.year_avg_prcnt/100)*252) + 500000*(1+(ydp2.year_avg_prcnt/100)*252) as invested_1mil_all2013
--	from investment_calcs_dec icd
--	join pearson_calcs_2013 pc on pc.stock_pair = icd.stock_pair
--	join avg_daily_prcnt_2013 ydp1 on ydp1.symbol = stock_1
--	join avg_daily_prcnt_2013 ydp2 on ydp2.symbol = stock_2
--	order by invested_1mil_dec2013 desc, r_dec desc
--	limit 10
--)

