SELECT *
  FROM ProjectProtfolio.dbo.CovidVacinations
  WHERE continent IS NOT NULL
  ORDER BY 3,4; 

-- Retriving data we are going to be using

SELECT location, date, total_cases, new_cases, total_deaths, population
  FROM ProjectProtfolio.dbo.CovidDeaths
 WHERE continent IS NOT NULL
 ORDER BY 1,2;

-- Total Cases vs. Total Deaths per location
-- Indicates the likelihood of dying if you contract COVID in your country

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercantage
  FROM ProjectProtfolio.dbo.CovidDeaths
 WHERE continent IS NOT NULL
 ORDER BY 1,2;

 -- Total cases vs. Total Population Per location
 -- Shows what percentage of the population has gotten COVID

 SELECT location, date, population, total_cases, (total_cases/population)*100 AS PercentagePopulationInfected
   FROM ProjectProtfolio.dbo.CovidDeaths
  WHERE continent IS NOT NULL
  ORDER BY 1,2;

 --Locations with Highest Infection Rate compared to Population from 2020 - 2021

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS PercentagePopulationInfected
  FROM ProjectProtfolio.dbo.CovidDeaths
 WHERE date BETWEEN '2020-01-01' AND '2021-12-31'
   AND continent IS NOT NULL
 GROUP BY location, population
 ORDER BY 4 DESC;

-- Shows Countries with Highest Death Count Per Population from 2020 - 2021

SELECT location, MAX(total_deaths) AS HighestDeathCount
  FROM ProjectProtfolio.dbo.CovidDeaths
 WHERE date BETWEEN '2020-01-01' AND '2021-12-31'
   AND continent IS NOT NULL
 GROUP BY location
 ORDER BY 2 DESC;

-- Let's break this down based on Continents
-- Shows Continents with Highest Death Count Per Population from 2020 - 2021

SELECT continent, MAX(total_deaths) AS HighestDeathCount
  FROM ProjectProtfolio.dbo.CovidDeaths
 WHERE date BETWEEN '2020-01-01' AND '2021-12-31'
   AND continent IS NOT NULL
 GROUP BY continent
 ORDER BY 2 DESC;

-- Global Numbers
-- Global Death rates per day from 2020 - 2021
SELECT date, SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, (SUM(new_deaths) / SUM(new_cases)*100) AS DeathPercentage
  FROM ProjectProtfolio.dbo.CovidDeaths
 WHERE date BETWEEN '2020-01-01' AND '2021-12-31'
   AND continent IS NOT NULL
 GROUP BY date
 ORDER BY 1;

-- Global Death rate from 2020 - 2021
 SELECT SUM(new_cases) AS TotalCases, SUM(new_deaths) AS TotalDeaths, (SUM(new_deaths) / SUM(new_cases)*100) AS DeathPercentage
   FROM ProjectProtfolio.dbo.CovidDeaths
  WHERE date BETWEEN '2020-01-01' AND '2021-12-31'
    AND continent IS NOT NULL;

-- Shows Total Population vs. Vaccinations
-- USE CTE

WITH PopvsVac (Continent, Location, Population, Date, New_Vaccinations, RollingPeopleVaccinated)
 AS
 (
   SELECT dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations, 
        SUM(vac.new_vaccinations) OVER(
                                        PARTITION BY vac.location
                                        ORDER BY vac.location, vac.date
                                      ) AS RollingPeopleVaccinated
   FROM ProjectProtfolio.dbo.CovidDeaths AS dea
   JOIN ProjectProtfolio.dbo.CovidVacinations AS vac 
     ON dea.location = vac.location 
    AND dea.date = vac.date
  WHERE dea.date BETWEEN '2020-01-01' AND '2021-12-31'
    AND dea.continent IS NOT NULL
  --ORDER BY 2,3
)
SELECT *, RollingPeopleVaccinated/Population*100 AS PopulationVaccinatedPercentage
  FROM PopvsVac;

-- TEMP TABLE

DROP TABLE IF EXISTS #PercentPeopleVaccinated 
CREATE TABLE #PercentPeopleVaccinated 
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPeopleVaccinated 
SELECT dea.continent, 
        dea.location, 
        dea.date, 
        dea.population, 
        vac.new_vaccinations, 
        SUM(vac.new_vaccinations) OVER(
                                        PARTITION BY vac.location
                                        ORDER BY vac.location, vac.date
                                      ) AS RollingPeopleVaccinated
   FROM ProjectProtfolio.dbo.CovidDeaths AS dea
   JOIN ProjectProtfolio.dbo.CovidVacinations AS vac 
     ON dea.location = vac.location 
    AND dea.date = vac.date
  WHERE dea.date BETWEEN '2020-01-01' AND '2021-12-31'
    AND dea.continent IS NOT NULL
  ORDER BY 2,3

-- Create a View to store data for later visualizations

CREATE VIEW PercentPeopleVaccinated 
AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(vac.new_vaccinations) OVER(
                                        PARTITION BY vac.location
                                        ORDER BY vac.location, vac.date
                                      ) AS RollingPeopleVaccinated
   FROM ProjectProtfolio.dbo.CovidDeaths AS dea
   JOIN ProjectProtfolio.dbo.CovidVacinations AS vac 
     ON dea.location = vac.location 
    AND dea.date = vac.date
  WHERE dea.date BETWEEN '2020-01-01' AND '2021-12-31'
    AND dea.continent IS NOT NULL

-- Queries used for Tableau
-- 1. Global Death rates from 2020 - 2021

SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercantage
  FROM ProjectProtfolio.dbo.CovidDeaths
 WHERE continent IS NOT NULL
   AND date BETWEEN '2020-01-01' AND '2021-12-31'
 ORDER BY 1,2;

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location

--SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases)*100 AS DeathPercantage
--  FROM ProjectProtfolio.dbo.CovidDeaths
-- WHERE location = 'World'
-- ORDER BY 1,2;

-- 2. Total Death Counts per location from 2020 -2021

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, SUM(new_deaths) AS TotalDeathCounts
  FROM ProjectProtfolio.dbo.CovidDeaths
 WHERE date BETWEEN '2020-01-01' AND '2021-12-31'
   AND continent IS NOT NULL
   AND location NOT IN ('World', 'European Union', 'International')
 GROUP BY location
 ORDER BY 2 DESC;

-- 3. Locations with Highest Infection Rate compared to Population from 2020 - 2021

SELECT location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS PercentagePopulationInfected
  FROM ProjectProtfolio.dbo.CovidDeaths
 WHERE date BETWEEN '2020-01-01' AND '2021-12-31'
   AND continent IS NOT NULL
 GROUP BY location, population
 ORDER BY 4 DESC;

-- 4. Locations with Highest Infection Rate per day compared to Population from 2020 - 2021

 SELECT location, date, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population)*100) AS PercentagePopulationInfected
   FROM ProjectProtfolio.dbo.CovidDeaths
  WHERE continent IS NOT NULL
    AND date BETWEEN '2020-01-01' AND '2021-12-31'
  GROUP BY location, population, date
  ORDER BY 5 DESC;