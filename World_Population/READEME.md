# World Population Analysis

## Project Overview
Today, the world's population is constantly increasing, and understanding the drivers behind these changes is crucial. This project involves an in-depth exploration of world population data, focusing on examining the trends of population growth in each country or region. Such an analysis can aid in preparing for the challenges that countries face both today and in the future.

## Exploratory Data Analysis
The initial phase involved checking for duplicates and missing values in the 'countries' and 'population_years' tables. This process helped ensure the integrity and reliability of the dataset for further analysis.

- **Duplicate Check**: Performed in both 'countries' and 'population_years' tables to ensure uniqueness.
- **Missing Values**: Identified and assessed missing values in key fields of both tables.
- **Country Details**: Additional inspection was conducted for specific country_ids, notably 62 & 210.
- **Joining Tables**: A left join between 'countries' and 'population_years' provided a more comprehensive view of the data.

## Data Cleaning
The next step involved cleaning the dataset, which included:

- **Deleting Missing Values**: Records with missing IDs or critical fields were removed.
- **Updating Values**: Population data for specific years and countries were updated for accuracy.

## SQL Queries

The analysis phase encompassed a variety of queries to derive meaningful insights:

- **Continental Overview:** This query determined the number of continents, the number of countries in each continent, and their total populations.
- **Population Extremes:** This part identified the highest and lowest population figures for each continent.
- **Decadal Population Change:** Focused on countries like Russia, examining population decreases over the past decade.

## Key Findings
- **Population Distribution**: The Asian continent had the highest population in 2010, with significant contributions from China and India.
- **Population Increase**: A majority of countries (188 out of 212) experienced a population increase, with India recording the highest growth.
- **Population Decrease**: A total of 24 countries, mainly in Europe, observed a decrease in their population.
- **Population Rankings and Percentages**: This part of the analysis involved calculating and ranking countries based on their 2010 populations, as well as determining their percentages of the global population.

## Conclusions
1. The Asian continent, primarily driven by the populations of China and India, holds a commanding lead in global population numbers.
2. Most countries worldwide experienced population growth from 2000 to 2010, with India seeing the most significant increase.
3. A smaller group of countries, mainly in Europe, experienced population declines.
4. Russia stood out as a major country with a declining population trend throughout the decade
5. China held the highest population figure in Asia, while Niue had the lowest in Oceania.

This project provides crucial insights into global population dynamics, highlighting significant trends and variances across different continents and countries.
