with trading_hours_only as (
	select 
		symbol as ticker,
		bid,
		bidtim,
		tdate,
		date_trunc('minute', bidtim) as minute,
		split_part(symbol, '.', 1) as ticker_only,
		nullif(split_part(symbol, '.', 2), '') as venue_only
	from part
	where to_char(bidtim, 'hh24:mi') between '09:31' and '16:00'
	group by tdate, ticker_only, bid, bidtim, ticker
),
quotes_by_minute as (
	select *,
    row_number() over (partition by ticker, minute order by bidtim desc) as rn
	from trading_hours_only
),
latest_quotes_per_ticker as (
	select *
	from quotes_by_minute
	where rn = 1
	order by ticker_only, minute
),
matched_venue_counts as (
	select 
		a.tdate,
		a.ticker_only,
		a.minute,
		count(*) as venue_match_count
	from latest_quotes_per_ticker a
	join latest_quotes_per_ticker b on a.ticker_only = b.ticker_only and a.minute = b.minute and a.bid = b.bid
		and b.venue_only is null
		and a.venue_only is not null
	group by a.ticker_only, a.minute, a.tdate
)
select *
from matched_venue_counts
order by ticker_only, minute