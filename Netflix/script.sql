**Data Cleaning**

-- Get an overview of the data set
	```
	SELECT * 
	FROM netflix;
	```
-------------------------------------------------------------------------------

-- Cleaning the director column

-- This section focuses on cleaning the 'director' column by replacing blank values with NULL.
   ```
   SELECT director
	FROM netflix
	GROUP BY 1

	SELECT director
	FROM netflix
	WHERE length(director) = 0

	UPDATE netflix
	SET	director = 
	CASE
		WHEN length(director) = 0 THEN NULL
		ELSE director
	END;
    ```
-------------------------------------------------------------------------------  

-- Cleaning the cast column
    ```
	SELECT "cast"
	FROM netflix
	GROUP BY 1

	SELECT "cast"
	FROM netflix
	WHERE length("cast") = 0

	UPDATE netflix
	SET	"cast" = 
	CASE
		WHEN length("cast") = 0 THEN NULL
		ELSE "cast"
	END;
	```
	-- Finished cleaning blank value
	
	```
	SELECT "cast",
		show_id
	FROM netflix
	GROUP BY 1
	
	UPDATE netflix
	SET "cast" = replace("cast", "'", "")
	WHERE show_id = 's2103'
    ```
	-- Finished cleaning misspellings
-------------------------------------------------------------------------------  

-- Cleaning the country column:
    ```
	SELECT country
	FROM netflix
	GROUP BY 1

	UPDATE netflix
	SET country = 
	CASE
		WHEN length(country) = 0 THEN NULL
		ELSE country
	END;
	```
	-- Finished cleaning blank value

-- Finding show_id for misspelling in the country
	```
	SELECT show_id,
	 country
	FROM netflix
	WHERE country IN(", France, Algeria", ", South Korea");

	UPDATE netflix
	SET country = trim(replace(country, substr(country,1,1), ''))
	WHERE show_id IN ('s366','s194');
	```
	-- Finished cleaning misspellings
	
-------------------------------------------------------------------------------

-- Cleaning the date_added column
	```
	SELECT date_added
	FROM netflix
	GROUP BY 1

	UPDATE netflix
	SET date_added = CASE
	WHEN length(date_added) = 0 THEN NULL
	ELSE date_added
	END;
	```
 
-------------------------------------------------------------------------------

-- Cleaning the rating colum

	```
	SELECT rating
	FROM netflix
	GROUP BY 1

	SELECT 
	show_id,
	title,
	type,
	rating
	FROM netflix
	WHERE length(rating) = 0
	GROUP BY 1
	```
	
-- Update value	
	```
	UPDATE netflix
	SET rating = 
    CASE 
		WHEN show_id = "s5990" THEN "PG"
		WHEN show_id = "s6828" THEN "TV-14"
		WHEN show_id = "s7313" THEN "TV-G"
		WHEN show_id = "s7538" THEN "PG-13"
		ELSE rating 
	END;
	```	
	
-- It seems that there are errors in the 'rating' column, possibly due to data from the 'duration' column being entered incorrectly."
	```
	SELECT rating
	FROM netflix
	GROUP BY 1 
	
	SELECT show_id,
	title,
	duration,
	rating
	FROM netflix
	WHERE rating IN ("66 min", "74 min", "84 min")
	```
	
-- Update 
	```
	UPDATE netflix
	SET duration = 
	CASE 
		WHEN show_id = "s5542" THEN "74 min"
		WHEN show_id = "s5795" THEN "84 min"
		WHEN show_id = "s5814" THEN "66 min"
		ELSE duration
	END;
 
	UPDATE netflix
	SET rating = 
	CASE 
		WHEN show_id IN ("s5542", "s5795", "s5814") THEN "TV-MA"
		ELSE rating
	END;
	```
	-- Finished cleaning section --
----------------------------------------------------------------------  

**Data Transformation**

-- It appears that the 'date_added' column is messy and cannot be sorted, so it needs to be transformed into the 'YYYY-MM-DD' format.
	```
	SELECT date_added
	FROM netflix
	WHERE date_added IS NOT NULL
	ORDER BY date_added;
	```
	
-- Some rows have spaces and need to be trimmed.
	```
	UPDATE netflix
	SET date_added = TRIM(date_added);
	```
	
-- Add new column 
	```
	ALTER TABLE netflix
	ADD COLUMN new_date DATE
	```
	
-- Update value
	```
	UPDATE netflix
	SET new_date = substr(date_added, -4) || '-' || 
   CASE
    WHEN substr(date_added, 1, 3) = 'Jan' THEN '01'
    WHEN substr(date_added, 1, 3) = 'Feb' THEN '02'
    WHEN substr(date_added, 1, 3) = 'Mar' THEN '03'
    WHEN substr(date_added, 1, 3) = 'Apr' THEN '04'
    WHEN substr(date_added, 1, 3) = 'May' THEN '05'
    WHEN substr(date_added, 1, 3) = 'Jun' THEN '06'
    WHEN substr(date_added, 1, 3) = 'Jul' THEN '07'
    WHEN substr(date_added, 1, 3) = 'Aug' THEN '08'
    WHEN substr(date_added, 1, 3) = 'Sep' THEN '09'
    WHEN substr(date_added, 1, 3) = 'Oct' THEN '10'
    WHEN substr(date_added, 1, 3) = 'Nov' THEN '11'
    WHEN substr(date_added, 1, 3) = 'Dec' THEN '12'
   END
  || '-' 
  || CASE 
    WHEN instr(date_added, ",") - instr(date_added, " ") = 2 THEN '0' || substr(date_added, instr(date_added, " ") + 1, 1)
    ELSE substr(date_added, instr(date_added, " ") + 1, 2)
  END;
  ```
  
	```
	SELECT new_date
	FROM netflix
	```
		
----------------------------------------------------------------------
		
-- Split the 'duration' column into 'duration_min' and 'duration_season'
	```
	SELECT duration   
	FROM netflix
	GROUP BY 1;
	```

-- Create column duration_min 
	```
	ALTER TABLE netflix
	ADD COLUMN duration_min INT;
	```
	
-- Update
	```
	UPDATE netflix
	SET duration_min = 
	CASE
		WHEN duration LIKE '%min%' THEN substr(duration, 1, instr(duration, " ")-1)
		ELSE NULL
	END;

	SELECT duration_min,
	duration
	FROM netflix
	WHERE duration_min IS NOT NULL
	```

-- Create column duration_season
	```
	ALTER TABLE netflix
	ADD COLUMN duration_season INT;
	```

-- Update
	```
	UPDATE netflix
	SET duration_season = 
	CASE
		WHEN duration LIKE '%S%' THEN substr(duration, 1, instr(duration, " ")-1)
		ELSE NULL
	END;
	
	SELECT duration_season,
	duration
	FROM netflix
	WHERE duration_season IS NOT NULL;
	```
	
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 

**Exploratory data analysis**

-- Counting the number of movies in the dataset
   ```
   SELECT show_id
   FROM netflix;
   ```
---------------------------------------------------------------------- 

-- Analyzing the length of titles
   ```
   SELECT length(title) AS title_char_length,
	COUNT(*) AS total,
	ROUND((SELECT AVG(length(title))
   FROM netflix)) AS avg_of_char_lenghth
   FROM netflix
   GROUP BY 1
   ORDER BY 2 DESC;
   ```
---------------------------------------------------------------------- 

-- Total number of movies and series
   ```
   SELECT type,
	COUNT(*) AS total
   FROM netflix
   GROUP by type;
   ```
---------------------------------------------------------------------- 

-- Since 2016, Netflix has added a lot of movies and TV shows to their platform.
   ```
   SELECT strftime('%Y',new_date) AS year,
	COUNT(*) AS num,
	SUM(COUNT(*)) OVER(ORDER BY strftime('%Y',new_date)) AS total_num
   FROM netflix
   WHERE strftime('%Y',new_date) IS NOT NULL
   GROUP BY 1
    ```
---------------------------------------------------------------------- 

-- It seems that Netflix plans to release content every 1st of the month.
	```
	SELECT strftime('%d',new_date) AS day,
	 COUNT(*) AS num
	FROM netflix
    WHERE strftime('%d',new_date) IS NOT NULL
    GROUP BY 1
	ORDER BY 2 DESC
	```
---------------------------------------------------------------------- 

-- Netflix has more focus on Movies than TV Shows
   ```
   SELECT strftime('%Y',new_date) AS year,
	type,
	COUNT(*) AS num
   FROM netflix
   WHERE strftime('%Y',new_date) IS NOT NULL
   GROUP BY 1,2
   ```
---------------------------------------------------------------------- 

-- The content added each year(2016-2021), TV-MA rating has the highest number.
   ``` 
   SELECT strftime('%Y',new_date) AS year,
	rating,
	COUNT(*) AS total
   FROM netflix
   WHERE strftime('%Y',new_date) IS NOT NULL AND strftime('%Y',new_date) BETWEEN '2016' AND '2021'
   GROUP BY 1,2
   ORDER BY 1,3 DESC;
   ```
---------------------------------------------------------------------- 

-- The number of TV shows for each rating.
	``` 
	SELECT type,
	 rating,
	 COUNT(*) AS num
	FROM netflix
	WHERE type = "TV Show"
	GROUP BY 1,2
	ORDER BY 3 DESC;
	``` 

----------------------------------------------------------------------

-- The number of Movie for each rating.
	``` 
	SELECT type,
	 rating,
	 COUNT(*) As num
	FROM netflix
	WHERE type = "Movie"
	GROUP BY 1,2
	ORDER BY 3 DESC;
	``` 

----------------------------------------------------------------------

-- The Top 10 country with the most produced Movie / Tv show content
	```
	SELECT 	country,
	 COUNT(*) AS num
	FROM netflix
	WHERE country IS NOT NULL
	GROUP BY country
	ORDER BY 2 DESC
	LIMIT 10;
	```
----------------------------------------------------------------------

-- Analysis of movie durations
	```
	SELECT type,
	 duration_min,
	 COUNT(*) AS total
	FROM netflix
	WHERE duration_min IS NOT NULL
	GROUP BY 1,2
	ORDER BY 3 DESC;
    ```
	
-- Counting movies with a TV-MA rating and their durations
	```
	SELECT type,
		rating,
		duration_min,
		COUNT(*) AS num
	FROM netflix
	WHERE type = 'Movie' AND rating = 'TV-MA'
	GROUP BY duration_min
	ORDER BY 4 DESC;
	```	
----------------------------------------------------------------------

-- Analysis of tv show durations
	```
	SELECT type,
	 duration_season,
	 COUNT(*) AS total
	FROM netflix
	WHERE duration_season IS NOT NULL
	GROUP BY 1,2
	ORDER BY 3 DESC;
	```
	
-- Counting Tv show with a TV-MA rating and their durations
	```
	SELECT type,
		rating,
		duration_season,
		COUNT(*) AS num
	FROM netflix
	WHERE type = 'TV Show' AND rating = 'TV-MA'
	GROUP BY duration_season
	ORDER BY 4 DESC;
	```
----------------------------------------------------------------------

-- List of directors and their movies
	```
	SELECT director,
	 type,
	 COUNT(*) AS num
	FROM netflix
	WHERE director IS NOT NULL
	GROUP BY 1
	ORDER BY 3 DESC;
	```
