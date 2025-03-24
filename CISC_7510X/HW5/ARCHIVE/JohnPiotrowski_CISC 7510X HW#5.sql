-- John Piotrowski - HW5 - 7510x
-- SET search_path = public, "$user", public;

with num_trading_days as (
    select 
		symbol, 
        count(distinct tdate) as yearly_trading_days,
        count(distinct case 
				when extract(month from tdate) = 12 
				then tdate 
				end) as dec_trading_days
    from daily_prcnt
    where extract(year from tdate) = 2013
    group by symbol
),
join_exp as (
	select
	s1.tdate,
	s1.symbol,
	s2.symbol
	from daily_prcnt s1
	join daily_prcnt s2 on s2.tdate = s1.tdate and s2.symbol < s1.symbol
	where extract(year from s1.tdate) = 2013
		and extract(month from s1.tdate) = 12
),
min_max_trade_month_per_symbol as (
    select 
        symbol, 
        extract(month from min(tdate)) as first_trade_month,
        extract(month from max(tdate)) as last_trade_month
    from daily_prcnt
    where extract(year from tdate) = 2013
    group by symbol
),	
valid_2013_stocks as (
	select 
		tdate,
		daily_prcnt.symbol,
		prcnt
	from daily_prcnt
	join min_max_trade_month_per_symbol on daily_prcnt.symbol = min_max_trade_month_per_symbol.symbol
	where extract(year from tdate) = 2013
		and daily_prcnt.symbol not like '%-%' 			-- Filter out pink sheets and OTC Bulletin Board and other dashed symbols
		and prcnt is not null							-- @TODO maybe we want to move this into daily_trades 
		and first_trade_month = 1						-- Filter out stocks that weren't trading in Jan 2013 like 'ATHM'
		and last_trade_month = 12						-- Filter out stocks that weren't trading in Dec 2013
		and daily_prcnt.symbol in ('MSFT', 'AAPL') 
),
daily_trades_greater_than_10mil as (
	select
		valid_2013_stocks.tdate,
		valid_2013_stocks.symbol,
		valid_2013_stocks.prcnt
	from valid_2013_stocks
	join cts on valid_2013_stocks.symbol = cts.symbol and valid_2013_stocks.tdate = cts.tdate
	group by valid_2013_stocks.symbol, valid_2013_stocks.tdate, valid_2013_stocks.prcnt, cts.close, cts.volume
	having cts.close * cts.volume > 10000000	-- est. daily trading total
),
daily_trades_dec2013 as (
	select *
	from daily_trades_greater_than_10mil
	where extract(month from daily_trades_greater_than_10mil.tdate) = 12
),
min_prcnt_calc as (
	select min(prcnt) as min_prcnt
	from daily_trades_dec2013
),
ranked_stocks as (
    select 
        tdate, 
        symbol, 
        prcnt,
        row_number() over (partition by tdate order by symbol) as row_num
    from daily_trades_dec2013
),
stock_pairs_dec_2013 as (
    select 
        s1.tdate, 
        s1.symbol as stock1, 
        s2.symbol as stock2, 
        s1.prcnt as stock1_prcnt, 
        s2.prcnt as stock2_prcnt
    from ranked_stocks s1
    join ranked_stocks s2 
        on s1.tdate = s2.tdate 
        and s1.row_num < s2.row_num  -- Ensures unique pairs (no duplicates)
)
-- stock_pairs_dec_2013 as (
-- 	select
-- 		s1.tdate as tdate,
-- 		s1.symbol as stock1,
-- 		s2.symbol as stock2,
-- 		s1.prcnt as stock1_prcnt,
-- 		s2.prcnt as stock2_prcnt
-- 	from daily_trades_dec2013 s1
-- 	join daily_trades_dec2013 s2 on s2.tdate = s1.tdate and s2.symbol < s1.symbol
-- 	where s1.symbol like '%MSFT%'
-- 	 	and s2.symbol like '%AAPL%'
-- ),
-- pairs_and_logs_dec_2013 as (
-- 	select *,
-- 		CONCAT(stock1,':',stock2) as stock_pair,
-- 		log(stock1_prcnt - min_prcnt + 1) AS stock1_shifted_log_value,
-- 		log(stock2_prcnt - min_prcnt + 1) AS stock2_shifted_log_value
-- 	from stock_pairs_dec_2013
-- 	cross join min_prcnt_calc
-- ),
-- pearson_calcs_dec2013 as (
-- 	select *,
-- 		corr(stock1_shifted_log_value, stock2_shifted_log_value) as r_dec
-- 	from pairs_and_logs_dec_2013
-- 	group by stock_pair, stock1, stock2, tdate, stock1_prcnt, stock2_prcnt, min_prcnt, stock1_shifted_log_value, stock2_shifted_log_value
-- 	having corr(stock1_shifted_log_value, stock2_shifted_log_value) is not null
-- )
select *
from join_exp

-- where stock1 = 'MSFT'
-- 	 and stock2 = 'AAPL'
-- select
-- 	stock_pair,
-- 	stock1,
-- 	stock1_shifted_log_value,
-- 	stock2,
-- 	stock2_shifted_log_value,
-- 	r_dec
-- from pearson_calcs_dec2013
-- order by r_dec desc
-- limit 50





-- avg_daily_prcnt_dec2013 as (
-- 	select 
-- 		stock_pair,
-- 		avg(stock1_prcnt) as stock1_dec_avg_prcnt,
-- 		avg(stock2_prcnt) as stock2_dec_avg_prcnt
-- 	from stock_pairs_dec_2013
-- 	group by stock_pair
-- ),
-- calculate_best_dec_investments as (
-- 	select *,
-- 		-- 500000*(1+(ydp1.year_avg_prcnt/100)*252) + 500000*(1+(ydp2.year_avg_prcnt/100)*252) as invested_1mil_all2013,
-- 		500000*(1+(adpd.stock1_dec_avg_prcnt/100)*22) + 500000*(1+(adpd.stock2_dec_avg_prcnt/100)*22) as invested_1mil_dec2013
-- 	from stock_pairs_dec_2013 spd
-- 	join avg_daily_prcnt_dec2013 adpd on adpd.stock_pair = spd.stock_pair
-- )
-- pearson_calcs_dec2013 as (
-- 	select
-- 		stock_pair,
-- 		corr(s1_log, s2_log) as r
-- 	from stock_pairs_dec_2013
-- 	group by stock_pair
-- 	having corr(s1_log, s2_log) is not null
-- )
-- log_calcs as (
-- 	log(prcnt - min_prcnt + 1) AS shifted_log_value 	-- Add handling for negative and zero value prcnts
-- 	from daily_trades_greater_than_10mil
-- 	cross join min_prcnt_calc
-- ),
-- -- Seems to hit the quantity problem here which makes sense, should use the Dec data first, then pull the 2013 data based on that data instead of the other way around
-- stock_pairs_all_2013 as (
-- 	select
-- 		s1.tdate as tdate,
-- 		s1.symbol as stock_1,
-- 		-- s2.symbol as stock_2,
-- 		-- CONCAT(s1.symbol,':',s2.symbol) as stock_pair,
-- 		s1.shifted_log_value as s1_log
-- 		-- s2.shifted_log_value as s2_log
-- 	from log_calcs s1
-- 	-- left join log_calcs s2 on s2.tdate = s1.tdate and s2.symbol < s1.symbol
-- )
-- select *
-- from calculate_best_dec_investments
-- order by invested_1mil_dec2013 desc
-- limit 50

-- pearson_calcs_dec2013 as (
-- 	select
-- 		stock_pair,
-- 		corr(s1_log, s2_log) as r
-- 	from stock_pairs_dec_2013
-- 	group by stock_pair
-- 	having corr(s1_log, s2_log) is not null
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
-- avg_daily_prcnt_2013 as (
-- 	select 
-- 		symbol, 
-- 		avg(prcnt) as year_avg_prcnt
-- 	from daily_trades_greater_than_10mil
-- 	group by symbol
-- ),
-- avg_daily_prcnt_dec2013 as (
-- 	select 
-- 		symbol, 
-- 		avg(prcnt) as dec_avg_prcnt
-- 	from daily_trades_greater_than_10mil
-- 	where extract(month from tdate) = 12
-- 	group by symbol
-- ),
-- pairs_and_rs as (
-- 	select
-- 		pcd.stock_pair as stock_pair,
-- 		split_part(pcd.stock_pair, ':', 1) as stock_1,
-- 		split_part(pcd.stock_pair, ':', 2) as stock_2,
-- 		pcd.r as r_december
-- 		-- pc.r as r_2013
-- 	from pearson_calcs_dec2013 pcd 
-- 	-- join pearson_calcs_2013 pc on pc.stock_pair = pcd.stock_pair
-- ),
-- calculate_investments as (
-- 	select
-- 		stock_pair,
-- 		500000*(1+(ydp1.year_avg_prcnt/100)*252) + 500000*(1+(ydp2.year_avg_prcnt/100)*252) as invested_1mil_all2013,
-- 		500000*(1+(ddp1.dec_avg_prcnt/100)*22) + 500000*(1+(ddp2.dec_avg_prcnt/100)*22) as invested_1mil_dec2013
-- 	from pairs_and_rs
-- 	join avg_daily_prcnt_2013 ydp1 on ydp1.symbol = stock_1
-- 	join avg_daily_prcnt_2013 ydp2 on ydp2.symbol = stock_2
-- 	join avg_daily_prcnt_dec2013 ddp1 on ddp1.symbol = stock_1
-- 	join avg_daily_prcnt_dec2013 ddp2 on ddp2.symbol = stock_2
-- )
-- select
-- 	prs.stock_pair,
-- 	stock_1,
-- 	stock_2,
-- 	-- r_2013,
-- 	r_december,
-- 	ci.invested_1mil_all2013,
-- 	ci.invested_1mil_dec2013
-- 	from pairs_and_rs prs
-- 	join calculate_investments ci on ci.stock_pair = prs.stock_pair
-- 	order by ci.invested_1mil_dec2013 desc
-- 	limit 50


-- -- from pearson_calcs_2013
-- -- from valid_2013_stocks
-- from num_trading_days