-- ===========================================
-- DATABASE SETUP & TABLE INSPECTION
-- ===========================================
CREATE DATABASE covid_project;
USE covid_project;

-- Load data using MySQL wizard (not shown)
SHOW TABLES;  -- Verify tables exist
DESC covid_deaths;
DESC covid_vaccination;

-- ===========================================
-- DATA UNDERSTANDING & CLEANING
-- ===========================================
-- Inspect sample data
SELECT * FROM covid_vaccination LIMIT 10;
SELECT * FROM covid_deaths LIMIT 10;

-- Check date ranges
SELECT MIN(date), MAX(date) FROM covid_vaccination;
SELECT MIN(date), MAX(date) FROM covid_deaths;

-- Check NULL values
SELECT 
    SUM(CASE WHEN total_cases IS NULL THEN 1 ELSE 0 END) AS null_total_cases,
    SUM(CASE WHEN total_deaths IS NULL THEN 1 ELSE 0 END) AS null_total_deaths
FROM covid_deaths;

-- Safe calculations for death rate
SELECT 
    total_deaths,
    total_cases,
    COALESCE(ROUND(total_deaths / NULLIF(total_cases,0)*100,2),0) AS safe_death_rate
FROM covid_deaths;

-- ===========================================
-- GLOBAL SUMMARIES
-- ===========================================

-- Global overview

SELECT 
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    ROUND(SUM(new_deaths) / SUM(new_cases) * 100, 2) AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL;


-- ===========================================
-- COUNTRY-LEVEL ANALYSIS
-- ===========================================

-- Infection rates 

SELECT 
    location,
    population,
    MAX(total_cases) AS highest_cases,
    ROUND((MAX(total_cases) / population) * 100, 2) AS infection_rate
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY infection_rate DESC;

-- Death/fatality rates

SELECT 
    location,
    MAX(total_cases) AS total_cases,
    MAX(total_deaths) AS total_deaths,
    ROUND((MAX(total_deaths) / MAX(total_cases)) * 100, 2) AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY death_percentage DESC;