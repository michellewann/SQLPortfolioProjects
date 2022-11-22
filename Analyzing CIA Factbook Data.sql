/*  Data exploration */

-- Looking at the first 5 in facts table

SELECT *
  FROM facts
 LIMIT 5; 
 
 -- Summary Statistics
 
 SELECT MIN(population) AS MinPopulation, 
        MAX(population) AS MaxPopulation, 
		MIN(population_growth) AS MinPopulationGrowth,
		MAX(population_growth) AS MaxPopulationGrowth
   FROM facts;

-- Exploring Outliers

SELECT name, 
       MIN(population) AS MinPopulation, 
       MAX(population) AS MaxPopulation
  FROM facts
 WHERE population = (SELECT MIN(population)
                       FROM facts);
					  
SELECT name, 
       MIN(population) AS MinPopulation, 
       MAX(population) AS MaxPopulation
  FROM facts
 WHERE population = (SELECT MAX(population)
					   FROM facts);
													  
-- Exploring Average Population and area

SELECT MIN(population) AS MinPopulation, 
       MAX(population) AS MaxPopulation, 
	   MIN(population_growth) AS MinPopulationGrowth,
	   MAX(population_growth) AS MaxPopulationGrowth,
	   AVG(population) AS AveragePopulation,
	   AVG(area) AS AverageArea
  FROM facts
 WHERE name NOT LIKE 'World'; 
 
-- Finding Densely Populated Countries

SELECT name, population, area
  FROM facts
 WHERE population > (SELECT AVG(population)
                       FROM facts
					  WHERE name NOT LIKE 'World') AND area < (SELECT AVG(area)
					                                             FROM facts
																WHERE name NOT LIKE 'World')
 ORDER BY population DESC, area; 
 
--  Finding country with highest population and growth rate

SELECT name, population, population_growth
  FROM facts
 WHERE population = (SELECT MAX(population)
                       FROM facts
					  WHERE name NOT LIKE 'World');
 
SELECT name, population, population_growth
  FROM facts
 WHERE population_growth = (SELECT MAX(population_growth)
                              FROM facts
							 WHERE name NOT LIKE 'World');

-- Finding Countries with the highest ratios of water to land and countries with more water area

SELECT name, 
       area_water, 
	   area_land, 
	   ROUND(CAST(area_water AS FLOAT) / CAST(area_land AS FLOAT),4) AS WaterLandRatio
  FROM facts
 WHERE name NOT LIKE 'World' AND WaterLandRatio > 1
 ORDER BY WaterLandRatio DESC;

-- Countries that will add the most people to their population next year

SELECT name, 
       ROUND(CAST(population as float) * 0.001 * birth_rate,2) AS new_births,
	   ROUND(CAST(population as float) * 0.001 * death_rate,2) AS new_deaths,
	   ROUND(CAST(population as float) * 0.001 * migration_rate,2) AS PeopleMigrating,
       ROUND(CAST(population as float) * 0.001 * birth_rate,2) - ROUND(CAST(population as float) * 0.001 * death_rate,2) - ROUND(CAST(population as float) * 0.001 * migration_rate,2) AS PeopleAdded
  FROM facts
 WHERE name IS NOT 'World'
 ORDER BY PeopleAdded DESC;
 
-- Looking at countries with higher death rates than birth rates

SELECT name, death_rate, birth_rate
  FROM facts
 WHERE death_rate > birth_rate AND name NOT LIKE 'World'
 ORDER BY name; 
 
-- Finding countries with highest population/area ratio

SELECT name,
       population,
	   area,
       ROUND(CAST(population AS FLOAT) / area,2) AS PopulationAreaRatio
  FROM facts
 WHERE name NOT LIKE 'World'
 ORDER BY PopulationAreaRatio DESC;
  