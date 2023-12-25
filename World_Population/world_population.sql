/*
World population Data Exploration 

Skills used: Joins, Temp Tables, Windows Functions, Aggregate Functions

*/

** Data Cleaning **

-- Check for the duplicate values in countries table
SELECT COUNT(id),
	COUNT(DISTINCT name)
FROM countries

-- Check for the duplicate values in population_years table
SELECT *
FROM population_years

SELECT year, COUNT(*)
FROM population_years
GROUP BY year

SELECT country_id, COUNT(*)
FROM population_years
GROUP BY country_id

SELECT country_id, COUNT(*)
FROM population_years
GROUP BY country_id
HAVING COUNT(*) != 11


-- Check the number of unique id in countries table and country_id in population_years table, It must be the same value
SELECT COUNT(id)
FROM countries;

SELECT COUNT(DISTINCT country_id)
FROM population_years;


-- Check for any missing values in key fields
SELECT COUNT(*) AS missingvalues
FROM countries
WHERE id IS NULL OR name IS NULL OR continent IS NULL

-- Check for any missing values in key fields
SELECT COUNT(*) AS missingvalues
FROM population_years
WHERE id IS NULL OR population IS NULL OR year IS NULL OR country_id IS NULL

SELECT *
FROM population_years
WHERE id IS NULL OR population IS NULL OR year IS NULL OR country_id IS NULL


-- Check for additional details for country_id 62 & 210
SELECT *
FROM population_years
WHERE country_id IN (62,210)

-- Join 2 tables to gain a better understanding
SELECT *
FROM countries cou
LEFT JOIN population_years pop
	ON cou.id = pop.country_id
WHERE pop.country_id IS NULL OR pop.population IS NULL OR pop.year IS NULL


-- Drop Missing VALUES
DELETE FROM countries
WHERE id IS 35;

DELETE FROM population_years
WHERE country_id IS 62;

DELETE FROM countries
WHERE id IS 62;


-- Update values
UPDATE population_years
SET population = CASE
  WHEN year = 2000 THEN 0.87836
  WHEN year = 2001 THEN 0.89300
  WHEN year = 2002 THEN 0.90963
  ELSE population
  END
 WHERE country_id = 210;
 

** Exploratory Data Analysis **
-- How many continents are there in the 'countries' table, and what are they?
SELECT DISTINCT continent
FROM countries

-- Find out the number of countries per continent and the total population for the latest year (2010) in this dataset.
SELECT continent, 
	COUNT(*) AS num_of_country,
	SUM(pop.population) AS total_pop_2010
FROM countries cou
JOIN population_years pop
	ON cou.id = pop.country_id
WHERE year = 2010
GROUP BY continent
ORDER BY total_pop_2010 DESC


-- Get an overview of maximum population for each continent
SELECT cou.continent,
	cou.name,
	pop.year,
	ROUND(MAX(population),5) As max_population
FROM countries cou
JOIN population_years pop
	ON cou.id = pop.country_id
GROUP BY cou.continent
ORDER BY max_population DESC

-- Get an overview of minimum population for each continent
SELECT cou.continent,
	cou.name,
	pop.year,
	ROUND(MIN(population),5) As min_population
FROM countries cou
JOIN population_years pop
	ON cou.id = pop.country_id
GROUP BY cou.continent
ORDER BY min_population


-- It seem like all maximum population come from 2010, except for Russia.
-- Russia's population has been decreasing year over year from 2000 to 2010
SELECT cou.name,
	pop.year,
	pop.population
FROM countries cou
JOIN population_years pop
	ON cou.id = pop.country_id
WHERE name = 'Russia'

-- Are there any other countries whose populations have been decreasing year over year from 2000 to 2010?
SELECT cou.continent,
    cou.name,
    pop.year,
    pop.population,
    ROUND(pop.population - LAG(pop.population) OVER(PARTITION BY cou.name),5) AS pop_2000_2010_dif
  FROM countries cou
  JOIN population_years pop
    ON cou.id = pop.country_id
  WHERE pop.year IN (2000, 2010)
  

-- Create a table to calculate the population for the years 2000 (1st year in the data) and 2010 (latest year in the data).
CREATE table pop_diff AS 
SELECT cou.continent,
	cou.name,
    pop.year,
    pop.population,
    ROUND(pop.population - LAG(pop.population) OVER(PARTITION BY cou.name),5) AS pop_2000_2010_dif
FROM countries cou
JOIN population_years pop
	ON cou.id = pop.country_id
WHERE pop.year IN (2000, 2010);

-- Create a table for countries with a pop_2000_2010_dif less than 0, indicating a likely population decrease trend.
CREATE table pop_diff_dec AS
SELECT *
FROM pop_diff
WHERE pop_2000_2010_dif < 0;

-- Create a table for countries with a pop_2000_2010_dif greater than 0, indicating a likely population increase trend
CREATE VIEW pop_diff_inc AS
SELECT *
FROM pop_diff
WHERE pop_2000_2010_dif > 0


-- All country that has a pop_2000_2010_dif < 0

SELECT *
FROM pop_diff_dec

-- From which continent do the countries with a population decrease originate?
SELECT continent, 
	COUNT(*) AS no_of_country
FROM pop_diff_dec
GROUP BY continent
ORDER BY 2 DESC


-- Top 5 countries with the most significant population decrease.
SELECT *
FROM pop_diff_dec
ORDER BY pop_2000_2010_dif
LIMIT 5;

SELECT AVG(pop_2000_2010_dif)
FROM pop_diff_dec


-- All country that has a pop_2000_2010_dif > 0
SELECT *
FROM pop_diff_inc

-- From which continent do the countries with a population increase originate??
SELECT continent, COUNT(*) AS no_of_country
FROM pop_diff_inc
GROUP BY continent
ORDER BY 2 DESC

-- Top 5 countries with the most significant population increase.
SELECT *
FROM pop_diff_inc
ORDER BY pop_2000_2010_dif DESC
LIMIT 5;

SELECT AVG(pop_2000_2010_dif)
FROM pop_diff_inc

SELECT SUM(pop_2000_2010_dif)
FROM pop_diff_inc

-- Country that the population increase is greater than the overall average population increase.
SELECT COUNT(*)
FROM pop_diff_inc
WHERE pop_2000_2010_dif >= (SELECT AVG(pop_2000_2010_dif)
							FROM pop_diff_inc)
ORDER BY pop_2000_2010_dif DESC


-- Sort the data of each country by population in descending order and assign a rank to each country based on its population
SELECT cou.continent,
	cou.name,
    pop.year,
    pop.population,
	RANK() OVER(PARTITION BY name ORDER BY population DESC) AS pop_rank
FROM countries cou
JOIN population_years pop
	ON cou.id = pop.country_id
ORDER BY cou.continent, cou.name


-- Find out the population percentage of each country in relation to the total population.
SELECT name,
	population AS pop_2010,
	ROUND(100*population / (SELECT SUM(population) FROM population_years
	WHERE year = 2010),5) || '%' AS pop_percentage
FROM countries cou
JOIN population_years pop
	ON cou.id = pop.country_id
WHERE year = 2010
ORDER BY population DESC;

SELECT SUM(population)
FROM population_years
WHERE year = 2010;
	

** Conclusion **
1. "The Asian continent had the highest population with 4,133 million out of a total population of 6,842 million in 2010."

2. "China and India together accounted for the majority of the world's population, with China at 19% and India at 17%, totaling 36% of the 6,842 million total population in 2010."

3. "From 212 countries, there are 188 countries where the population had increased, and 24 countries where the population had decreased from 2000 to 2010."

4. "In 188 countries, the average population increase from 2000 to 2010 was 4.16 million, with India experiencing the highest population increase of 166 million."

5. "Only 36 out of 188 countries have an average population increase higher than the overall average (4.16 million)."

6. "In 24 countries, the population has decreased, with an average decline of 0.5 million, and 14 of these countries are located in Europe."

7. "The highest population for each continent came from the latest year, which was 2010, except for Russia in 2000."

8. "Russia's population has been decreasing year over year, from 146 million in 2000 to 139 million in 2010."

9. "China, in Asia, had the highest population with 1,330 million, while Niue, in Oceania, had the lowest population at 0.002 million."