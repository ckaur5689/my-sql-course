/*
Airports Exercise
 
Data source: https://ourairports.com/data/
Data dictionary: https://ourairports.com/help/data-dictionary.html
 
In this exercise we analyse the countries, airports and airports_frequencies table
These have  matching columns:
* airports.ident matches airport_frequencies.airport_ident
* countries.code matches airports.iso_country
*/
 
-- Show 10 sample rows of the airports table
SELECT  TOP 10 * FROM   countries c
Where c.continent = 'EU';
 
-- Show 10 sample rows of the airports table
SELECT  TOP 10 * FROM   airports a
WHere a.elevation_ft > 1000;
 
-- Show 10 sample rows of the airports_frequencies table
Select  TOP 10 * FROM airport_frequencies af
Where af.fequency_mhz between 120 and 130
order by af.fequency_mhz asc;
 
-- These are the more interesting columns of the airports table  that we use in this exercise
Select TOP 10
    a.ident
    , a.iata_code
    , a.name
    , a.[type]
    , a.latitude_deg
    , a.longitude_deg
    , a.elevation_ft
    , a.iso_country
From airports a;
 
-- How many airports are in the airports table?
 Select
 Distinct COUNT(a.ident) as CountofAirports
 From airports a;
 
-- How many frequencies are in the airport_frequencies table?
 Select 
 Distinct b.fequency_mhz, COUNT(b.fequency_mhz) as CountofFrequencies
 From airport_frequencies b
 Group by b.fequency_mhz
 Order by COUNT(b.fequency_mhz) desc;
 
-- How many airports of each type?
 Select 
 Distinct COUNT(a.[type]) as AirportType, a.[type]
 From airports a
 Group by a.[type];

-- Is the airport.ident column unique? i.e. there are no duplicate values
 Select
 a.ident, count(*)
 From airports a
 Group by a.ident
 Having count(*) >1
 Order by a.ident DESC;

/*
Do a data quality check on the airports_frequencies table
Are there any orphan rows (frequencies without a matching airports)?
You can do this is several ways: LEFT JOIN, NOT IN, NOT EXISTS,...
*/
-- left join approach
 
Select a.name, f.fequency_mhz 
From airport_frequencies f left join airports a 
on f.airport_ident  = a.ident
Where a.ident is null
Order by a.name;

-- Test the other way
Select a.name, f.fequency_mhz 
From airports a left join  airport_frequencies f 
on a.ident = f.airport_ident
Where f.airport_ident is null
Order by a.name;

-- NOT EXISTS approach  
 
Select a.name, a.ident
From airports a
WHERE NOT EXISTS 
(
    Select f.airport_ident
    from airport_frequencies f 
    Where a.ident = f.airport_ident
)
Order by a.name;

-- NOT IN approach  
SELECT  a.name, a.ident
FROM airports a
WHERE a.ident NOT IN (SELECT f.airport_ident FROM airport_frequencies f );

/*
1. List airports.  Show the following columns: ident, iata_code, name, latitude_deg, longitude_deg */

SELECT
    a.ident
    ,a.iata_code
    ,a.[name]
    ,a.latitude_deg
    ,a.longitude_deg
FROM
    airports a;

/*
2. Filter to those airports
  (a) of large_airport type   */

SELECT
    a.ident
    ,a.iata_code
    ,a.[name]
    ,a.[type]
    ,a.latitude_deg
    ,a.longitude_deg
FROM
    airports a
WHERE a.[type] = 'large_airport';

/* 2. Filter to those airports
    (b) in the United Kingdom or France (iso_country  GB, FR)
    [advanced - in Europe i.e., country.continent = 'EU'] */

SELECT
    a.ident
    ,a.iata_code
    ,a.[name]
    ,a.[type]
    ,a.iso_country
    ,a.continent
    ,a.latitude_deg
    ,a.longitude_deg
FROM
    airports a
WHERE 
    a.[type] = 'large_airport'
    AND
    (
        a.continent in ('EU')
    OR 
        a.[iso_country] in ('GB','FR') 
    )
    

 /* 2. Filter to those airports  
    (c) that have a latitude between 49 and 54 degrees */

SELECT
    a.ident
    ,a.iata_code
    ,a.[name]
    ,a.[type]
    ,a.iso_country
    ,c.continent -- from Countries table
    ,a.latitude_deg
    ,a.longitude_deg
FROM
    airports a LEFT JOIN countries c 
    on a.iso_country = c.code
WHERE 
    a.[type] = 'large_airport'
AND
    (
        c.continent in ('EU')
    AND 
        a.[iso_country] in ('GB','FR') 
    )
AND
    a.latitude_deg between 49 and 54  ;

/* avoiding a join by using subquery */
SELECT
    a.ident
    ,a.iata_code
    ,a.[name]
    ,a.[type]
    ,a.iso_country
    --,c.continent -- from Countries table
    ,a.latitude_deg
    ,a.longitude_deg
FROM
    airports a
WHERE a.[type] = 'large_airport' 
AND
 a.iso_country IN (SELECT c.code from countries c where c.continent = 'EU')
AND
    a.latitude_deg between 49 and 54  
AND 
        a.[iso_country] in ('GB','FR') ;

Select top 1000 *
from countries
Select top 1000 *
from airports

/*3. Order from the most northern airports to most southern airports */
SELECT
    a.ident
    ,a.iata_code
    ,a.[name]
    ,a.[type]
    ,a.iso_country
    ,a.continent
    ,a.latitude_deg
    ,a.longitude_deg
FROM
    airports a
ORDER BY a.longitude_deg desc;
  
/*
List the iso_country of the 5 countries with the most airports
List in order of number of airports (highest first)
*/
 SELECT Top 5 
    a.iso_country
    ,COUNT(a.iso_country) as Count
FROM
    airports a
GROUP BY a.iso_country
ORDER BY COUNT(a.iso_country) desc
 
/*
How many airports are in those 5 countries (with the most airports)?
Use three different approaches: temp table, CTE, subquery
*/
 
-- Write the temp table approach below here

SELECT
     a.iso_country
    ,COUNT(a.iso_country) as Count
INTO #TempTableCK
FROM
    airports a
GROUP BY a.iso_country
ORDER BY COUNT(a.iso_country) desc

Select Top 5 *
FROM #TempTableCK;
 
-- Write the CTE approach below here
;WITH CountriesWithAirports AS
(
    SELECT 
    a.iso_country
    ,COUNT(a.iso_country) as Count
    FROM
    airports a
    GROUP BY a.iso_country
)
 
SELECT TOP 5 *
FROM CountriesWithAirports ca
Order by ca.Count desc

-- Write the subquery approach below here
 
SELECT TOP 5 *
FROM
(
    SELECT  a.iso_country
    ,COUNT(a.iso_country) as Count
    FROM
    airports a
    GROUP BY a.iso_country
) t
ORDER BY t.Count desc



/*
List those large airports (if any) without a frequency
*/
 
 
/*
List airports (if any) that have missing (NULL) values for *both* latitude or longitude.
*/
 
/*
List airports (if any) that have missing (NULL) values for *either* latitude or longitude  but not both.
This may indicate some sort of data quality issue.
*/