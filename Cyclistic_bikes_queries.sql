--selecting data from each database
select *
From dbo.Divvy_Trips_2020_Q1;

select  *
From dbo.Divvy_Trips_2019_Q2;

select  *
From dbo.Divvy_Trips_2019_Q3;

select  *
From dbo.Divvy_Trips_2019_Q4;

-- Rename columns to make them consistent with Q1_2020
select from dbo.Divvy_Trips_2019_Q4
sp_rename 'Divvy_Trips_2019_Q4.trip_id','ride_id';
sp_rename 'Divvy_Trips_2019_Q4.start_time','started_at';
sp_rename 'Divvy_Trips_2019_Q4.end_time','ended_at';
sp_rename 'Divvy_Trips_2019_Q4.from_station_id','start_station_id';
sp_rename 'Divvy_Trips_2019_Q4.from_station_name','start_station_name';
sp_rename 'Divvy_Trips_2019_Q4.to_station_id','end_station_id';
sp_rename 'Divvy_Trips_2019_Q4.to_station_name','end_station_name';
sp_rename 'Divvy_Trips_2019_Q4.usertype','member_casual';

sp_rename 'Divvy_Trips_2019_Q2.column1','ride_id';
sp_rename 'Divvy_Trips_2019_Q2.column2','started_at';
sp_rename 'Divvy_Trips_2019_Q2.column3','ended_at';
sp_rename 'Divvy_Trips_2019_Q2.column6','start_station_id';
sp_rename 'Divvy_Trips_2019_Q2.column7','start_station_name';
sp_rename 'Divvy_Trips_2019_Q2.column8','end_station_id';
sp_rename 'Divvy_Trips_2019_Q2.column9','end_station_name';
sp_rename 'Divvy_Trips_2019_Q2.column10','member_casual';
sp_rename 'Divvy_Trips_2019_Q2.column11','gender';
sp_rename 'Divvy_Trips_2019_Q2.column12','birthyear';

sp_rename 'Divvy_Trips_2019_Q3.trip_id','ride_id';
sp_rename 'Divvy_Trips_2019_Q3.start_time','started_at';
sp_rename 'Divvy_Trips_2019_Q3.end_time','ended_at';
sp_rename 'Divvy_Trips_2019_Q3.from_station_id','start_station_id';
sp_rename 'Divvy_Trips_2019_Q3.from_station_name','start_station_name';
sp_rename 'Divvy_Trips_2019_Q3.to_station_id','end_station_id';
sp_rename 'Divvy_Trips_2019_Q3.to_station_name','end_station_name';
sp_rename 'Divvy_Trips_2019_Q3.usertype','member_casual';

--Removing a unwanted row

Delete from dbo.Divvy_Trips_2019_Q2
where member_casual='User Type';

--Droping Unwanted columns

Alter table dbo.Divvy_Trips_2020_Q1
Drop column rideable_type,start_lat,start_lng,end_lat,end_lng;

Alter table dbo.Divvy_Trips_2019_Q2
Drop column column4,column5,gender,birthyear;

Alter table dbo.Divvy_Trips_2019_Q3
Drop column bikeid,tripduration,gender,birthyear;

Alter table dbo.Divvy_Trips_2019_Q4
Drop column bikeid,tripduration,gender,birthyear;

--There are a few problems we will need to fix:
--In the "member_casual" column, there are two names for members ("member" and "Subscriber") and 
--two names for casual riders ("Customer" and "casual"). We will need to consolidate that from four to two labels.

--In the "member_casual" column, replace "Subscriber" with "member" and "Customer" with "casual"

update dbo.Divvy_Trips_2019_Q2
set member_casual='member'
where member_casual='Subscriber';

update dbo.Divvy_Trips_2019_Q2
set member_casual='casual'
where member_casual='Customer';

update dbo.Divvy_Trips_2019_Q3
set member_casual='member'
where member_casual='Subscriber';

update dbo.Divvy_Trips_2019_Q3
set member_casual='casual'
where member_casual='Customer';

update dbo.Divvy_Trips_2019_Q4
set member_casual='member'
where member_casual='Subscriber';

update dbo.Divvy_Trips_2019_Q4
set member_casual='casual'
where member_casual='Customer';

--Updating the ride_id datatype to make them consistent with other database columns
-----------------------------------------------------

ALTER TABLE dbo.Divvy_Trips_2019_Q4
ADD ride_id1 nvarchar(50);

update dbo.Divvy_Trips_2019_Q4
set ride_id1=cast(ride_id as nvarchar(50));


Alter table dbo.Divvy_Trips_2019_Q4
drop column ride_id;

sp_rename 'Divvy_Trips_2019_Q4.ride_id1','ride_id';
-----------------------------------------------------

ALTER TABLE dbo.Divvy_Trips_2019_Q3
ADD ride_id1 nvarchar(50);

update dbo.Divvy_Trips_2019_Q3
set ride_id1=cast(ride_id as nvarchar(50));


Alter table dbo.Divvy_Trips_2019_Q3
drop column ride_id;

sp_rename 'Divvy_Trips_2019_Q3.ride_id1','ride_id';
-----------------------------------------------

convert(date,[started_at]) as start_date,
convert(time,[started_at]) as start_time,
convert(time,[ended_at]) as end_time,
DATENAME(month,started_at) as month,
YEAR(started_at)as year,
Day(started_at)as date,
DATENAME(WEEKDAY,started_at) as weekday,
DATEDIFF(MINUTE, started_at , ended_at) AS ride_in_minutes
-------------------------------------------------


-----Extracting date, time, ridelength, month, year, weekday from started_at & ended_at column
select ride_id,
started_at,
ended_at,
member_casual,
convert(date,[started_at]) as start_date,
convert(time,[started_at]) as start_time,
convert(time,[ended_at]) as end_time,
DATENAME(month,started_at) as month,
YEAR(started_at)as year,
Day(started_at)as date,
DATENAME(WEEKDAY,started_at) as weekday,
DATEDIFF(MINUTE, started_at , ended_at) AS ride_in_minutes
from dbo.Divvy_Trips_2020_Q1
----------------------------------------------------
--Just updated the extracted month, date and others fields into the database

Alter table dbo.Divvy_Trips_2020_Q1
Add month nvarchar(50);

update dbo.Divvy_Trips_2020_Q1
set month=DATENAME(month,started_at);

Alter table dbo.Divvy_Trips_2020_Q1
Add weekday nvarchar(50);

update dbo.Divvy_Trips_2020_Q1
set weekday=DATENAME(WEEKDAY,started_at);

Alter table dbo.Divvy_Trips_2020_Q1
add ride_length int;

update dbo.Divvy_Trips_2020_Q1
set ride_length=DATEDIFF(MINUTE, started_at , ended_at);

Alter table dbo.Divvy_Trips_2020_Q1
add year nvarchar(50);

update dbo.Divvy_Trips_2020_Q1
set year=YEAR(started_at);

Alter table dbo.Divvy_Trips_2020_Q1
drop column ride_length_min;

Alter table dbo.Divvy_Trips_2020_Q1
add ride_length_min bigint;

update dbo.Divvy_Trips_2020_Q1
set ride_length_min=ride_length*60;
----------------------------------------------------------

select ride_id,
started_at,
ended_at,
member_casual,
convert(date,[started_at]) as start_date,
convert(time,[started_at]) as start_time,
convert(time,[ended_at]) as end_time,
DATENAME(month,started_at) as month,
YEAR(started_at)as year,
Day(started_at)as date,
DATENAME(WEEKDAY,started_at) as weekday,
DATEDIFF(MINUTE, started_at , ended_at) AS ride_in_minutes
from dbo.Divvy_Trips_2019_Q2

Alter table dbo.Divvy_Trips_2019_Q2
Add month nvarchar(50);

update dbo.Divvy_Trips_2019_Q2
set month=DATENAME(month,started_at);

Alter table dbo.Divvy_Trips_2019_Q2
Add weekday nvarchar(50);

update dbo.Divvy_Trips_2019_Q2
set weekday=DATENAME(WEEKDAY,started_at);

Alter table dbo.Divvy_Trips_2019_Q2
add ride_length int;

Alter table dbo.Divvy_Trips_2019_Q2
drop column ride_length_min;

update dbo.Divvy_Trips_2019_Q2
set ride_length=DATEDIFF(MINUTE, started_at , ended_at);

Alter table dbo.Divvy_Trips_2019_Q2
add ride_length_min bigint;

update dbo.Divvy_Trips_2019_Q2
set ride_length_min=ride_length*60;

Alter table dbo.Divvy_Trips_2019_Q2
add year nvarchar(50);

update dbo.Divvy_Trips_2019_Q2
set year=YEAR(started_at);
-----------------------------------------

select ride_id,
started_at,
ended_at,
member_casual,
convert(date,[started_at]) as start_date,
convert(time,[started_at]) as start_time,
convert(time,[ended_at]) as end_time,
DATENAME(month,started_at) as month,
YEAR(started_at)as year,
Day(started_at)as date,
DATENAME(WEEKDAY,started_at) as weekday,
DATEDIFF(MINUTE, started_at , ended_at) AS ride_in_minutes
from dbo.Divvy_Trips_2019_Q3

Alter table dbo.Divvy_Trips_2019_Q3
Add month nvarchar(50);

update dbo.Divvy_Trips_2019_Q3
set month=DATENAME(month,started_at);

Alter table dbo.Divvy_Trips_2019_Q3
Add weekday nvarchar(50);

update dbo.Divvy_Trips_2019_Q3
set weekday=DATENAME(WEEKDAY,started_at);

Alter table dbo.Divvy_Trips_2019_Q3
add ride_length int;

update dbo.Divvy_Trips_2019_Q3
set ride_length=DATEDIFF(MINUTE, started_at , ended_at);

Alter table dbo.Divvy_Trips_2019_Q3
add year nvarchar(50);

update dbo.Divvy_Trips_2019_Q3
set year=YEAR(started_at);

Alter table dbo.Divvy_Trips_2019_Q3
drop column ride_length_min;

Alter table dbo.Divvy_Trips_2019_Q3
add ride_length_min bigint;

update dbo.Divvy_Trips_2019_Q3
set ride_length_min=ride_length*60;

select *
from dbo.Divvy_Trips_2019_Q3;
-----------------------------------------------------

select ride_id,
started_at,
ended_at,
member_casual,
convert(date,[started_at]) as start_date,
convert(time,[started_at]) as start_time,
convert(time,[ended_at]) as end_time,
DATENAME(month,started_at) as month,
YEAR(started_at)as year,
Day(started_at)as date,
DATENAME(WEEKDAY,started_at) as weekday,
DATEDIFF(MINUTE, started_at , ended_at) AS ride_in_minutes
from dbo.Divvy_Trips_2019_Q4

Alter table dbo.Divvy_Trips_2019_Q4
Add month nvarchar(50);

update dbo.Divvy_Trips_2019_Q4
set month=DATENAME(month,started_at);

Alter table dbo.Divvy_Trips_2019_Q4
Add weekday nvarchar(50);

update dbo.Divvy_Trips_2019_Q4
set weekday=DATENAME(WEEKDAY,started_at);

Alter table dbo.Divvy_Trips_2019_Q4
add ride_length int;


update dbo.Divvy_Trips_2019_Q4
set ride_length=DATEDIFF(MINUTE, started_at , ended_at);

Alter table dbo.Divvy_Trips_2019_Q4
add year nvarchar(50);

update dbo.Divvy_Trips_2019_Q4
set year=YEAR(started_at);

Alter table dbo.Divvy_Trips_2019_Q4
drop column ride_length_min;


Alter table dbo.Divvy_Trips_2019_Q4
add ride_length_min bigint;

update dbo.Divvy_Trips_2019_Q4
set ride_length_min=ride_length*60;

select *
from dbo.Divvy_Trips_2019_Q4;
------------------------------------------------------------


-----combining the four tables----------
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2020_Q1
UNION
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2019_Q2
UNION 
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2019_Q3
UNION
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2019_Q4;
----------------------------------------------------------

-----creating the temp table

create table #tripstemptables
(ride_id nvarchar(50),
started_at datetime2(7),
ended_at datetime2(7),
member_casual nvarchar(50),
year nvarchar(50),
month nvarchar(50),
weekday nvarchar(50),
ride_length_min bigint
);

-----Inserting the values into temp table

Insert into #tripstemptables
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2020_Q1
UNION
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2019_Q2
UNION 
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2019_Q3
UNION
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2019_Q4;

select *
from #tripstemptables;

-----Creating a view for the final cleaned data
Create View tripstemptables as
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2020_Q1
UNION
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2019_Q2
UNION 
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2019_Q3
UNION
select ride_id,started_at,ended_at,member_casual,year,month,weekday,ride_length_min
from dbo.Divvy_Trips_2019_Q4;

select * 
from tripstemptables;

select Avg(ride_length_min) as avg_ride_length
from tripstemptables;

select count(ride_id) as no_of_rides
from tripstemptables;

select distinct month
from tripstemptable;