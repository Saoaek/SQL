# Netflix Content Analysis Project

## Project Overview
This project aims to analyze the extensive database of movies and TV shows available on Netflix. They have over 8000 movies or tv shows available on their platform, as of mid-2021, they have over 200M Subscribers globally. This analysis provides insights into content trends, preferences, and analysis of movie and TV show durations.

## Dataset Description
The dataset includes listings of all movies and TV shows on Netflix, with details like cast, directors, ratings, release year, and duration.

## Data Cleaning and Transformation
The project begins with extensive data cleaning and preparation, including:
- **Director, Cast, and Country Columns**: Cleaning of null and blank values, and rectifying misspellings.
- **Date Added**: Transformation of the 'date_added' column into a sortable 'YYYY-MM-DD' format.
- **Rating and Duration**: Cleaning and correcting errors in the 'rating' and 'duration' columns, and splitting 'duration' into 'duration_min' for movies and 'duration_season' for TV shows.

## Key SQL Queries
The analysis includes various SQL queries to uncover insights into Netflix's content strategy. Key queries involve:
- Counting the total number of movies and series.
- Analyzing the length of titles and the distribution of content types (movies vs. TV shows).
- Trend analysis of content added each year, with a focus on content ratings and types.
- Detailed examination of the content added each year, highlighting the focus on Movies over TV Shows.
- Top 10 countries producing the most content.
- Analysis of movie and TV show durations, especially focusing on TV-MA rated content.

## Findings and Insights
- There is a notable increase in content addition since 2016, with a significant focus on movies.
- TV-MA rating dominates the content added between 2016 and 2021.
- The United States leads in the number of productions.
- Movies with a TV-MA rating tend to have varied durations, while TV shows have more consistent seasonal durations.

## Conclusions
This analysis sheds light on Netflix's evolving content strategy and its focus areas. The shift towards movies, particularly with TV-MA ratings, indicates a strategic direction aimed at catering to a specific audience demographic. The insights gleaned from this analysis can inform content producers and marketers alike.
