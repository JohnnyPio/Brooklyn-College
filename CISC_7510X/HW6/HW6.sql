--Create Table statements

create table junkyard(
	jid bigint not null,
	jname varchar(50) not null,
	street1 varchar(50) not null,
	street2 varchar(50) not null,
	city varchar(30) not null,
	state varchar(10) not null,
	zip varchar(10) not null,
	contact_fname varchar(30) not null,
	contact_lname varchar(30) not null,
	contact_email varchar(60) not null
);

create table car(
	cid bigint not null,
	jid bigint not null,
	vin varchar(30) not null,
	make varchar(30) not null,
	model varchar(30) not null,
	year int not null,
	color varchar(30) not null,
	make_model_year_start int not null,
	make_model_year_end int not null,
	inventoried_time timestamp
);

create table part(
	pid bigint not null,
	cid bigint not null,
	part_no varchar(50) not null,
	description varchar(100) not null,
	color varchar(30),
	sale_price_cents int,
	sale_time timestamp not null
);

create table price_history(
	phid bigint not null,
	pid bigint not null,
	price_cents int not null,
	start_time timestamp not null
);

-- query 'left side mirror from a white 2013 Ford Mustang'
with exact_car_matches as (
select cid
from car
where make = 'Ford'
	and model = 'Mustang' 
	and year = 2013
),
compatibile_car_matches as (
	select cid
	rom car
	where make = 'Ford'
	and model = 'Mustang' 
	and make_model_year_start <= 2013
	and make_model_year_end >= 2013
),
select *
from part a
left join exact_car_matches b on a.cid = b.cid
left join compatibile_car_matches c on a.cid = c.cid
where a.part_no = 'left side mirror'


-- add junkyard event

-- add car evnt

-- add part event

-- add price event

-- sell part event