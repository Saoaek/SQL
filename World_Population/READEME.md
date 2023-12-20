# World Population Analysis

## Project Overview
This project involves a thorough exploration of world population data, utilizing a range of SQL skills like Joins, CTEs, Temp Tables, Window Functions, Aggregate Functions, and the creation of Views.

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

## Data Analysis and Insights
The analysis phase covered a wide range of queries to extract meaningful insights:

- **Continental Overview**: Determined the number of continents and countries per continent, along with their total populations.
- **Population Extremes**: Identified the maximum and minimum population figures for each continent.
- **Decadal Population Change**: Focused on countries like Russia, whose populations have been decreasing over a decade.
- **Population Trends View Creation**: Created views to categorize countries based on their population trends between 2000 and 2010.

## Significant Findings
- **Population Distribution**: The Asian continent had the highest population in 2010, with significant contributions from China and India.
- **Population Increase**: A majority of countries (188 out of 212) experienced a population increase, with India recording the highest growth.
- **Population Decrease**: 24 countries saw a decrease in population, predominantly in Europe.
- **Population Rankings and Percentages**: Calculated and ranked countries based on their population in 2010 and their respective global population percentages.

## Conclusions
1. The Asian continent, led by China and India, dominates global population figures.
2. Most countries worldwide experienced population growth from 2000 to 2010, with India seeing the most significant increase.
3. A smaller group of countries, mainly in Europe, experienced population declines.
4. Russia's decreasing population trend over the decade was a notable exception among the major countries.
5. China held the highest population figure in Asia, while Niue had the lowest in Oceania.

This project provides crucial insights into global population dynamics, highlighting significant trends and variances across different continents and countries.
