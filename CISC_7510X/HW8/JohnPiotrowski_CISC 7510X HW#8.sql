-- John Piotrowski - 7510X - HW8

-- The run time of the below query in big-O notation is O(N*logN). By far the most time-consuming operation is the potential_violators self-join. However, now that we are joining on 
-- a key (i.e. the 3 region calculations) - it is no longer a nested loop join and is now a sort-merge, making the time of calculation shortened from O(N^2) to O(N*logN).

with airborne_cars as (
	select *
	from car
	where altitude >= 50
),
regions_of_cars as (
	select *,
		gps_lat*69*5280 as lat_ft,
		gps_long*69.172*5280*cos(gps_lat) as long_ft,
		floor((gps_lat*69*5280)/50) as lat_region_50ft,
		floor((gps_long*69.172*5280*cos(gps_lat))/50) as long_region_50ft,
		floor(altitude/50) as alt_region_50ft
	from airborne_cars 
),
potential_violators as (
	select 
		*,
		a.cid as a_cid,
		b.cid as b_cid,
		a.gps_timestamp as a_timestamp,
		sqrt((a.lat_ft-b.lat_ft)^2 + (a.long_ft - b.long_ft)^2 + (a.altitude - b.altitude)^2) as distance_between
	from regions_of_cars a
	inner join regions_of_cars b on a.gps_timestamp = b.gps_timestamp 
			and a.cid < b.cid
			and abs(a.lat_region_50ft - b.lat_region_50ft) <= 1
			and abs(a.long_region_50ft - b.long_region_50ft) <= 1
			and abs(a.alt_region_50ft - b.alt_region_50ft) <= 1
),
actual_violators as (
	select *
	from potential_violators 
	where distance_between <= 55
),
deduped_violations as (
    select 
        a_cid, 
        b_cid, 
        a_timestamp,
        distance_between,
        row_number() over (partition by a_cid, b_cid order by a_timestamp) as rn	-- only write 1 ticket for when 2 cars are too close, instead of 1 for every second they are too close
    from actual_violators
)
select *
from deduped_violations
where rn = 1