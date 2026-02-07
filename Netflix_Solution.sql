--Netflix project--


CREATE TABLE Netflix

(

show_id VARCHAR(10),
typess VARCHAR(15),
title VARCHAR(110),
director VARCHAR(250),
Casts VARCHAR(900), 
country VARCHAR(150),
date_added VARCHAR(30),
release_year INT ,
rating VARCHAR(20),
duration VARCHAR(30) ,
listed_in VARCHAR(100),
description VARCHAR(250)


);

--Project_Problems--

--Q1.Count the number of Movies vs TV shows.

SELECT 
     type,
	 COUNT(*) AS Total_content
FROM Netflix
GROUP BY 1;


--Q2.Find the most common rating for movies and TV Shows.


SELECT 
     type,
	 rating
FROM 
(
SELECT 
     type,
	 rating,
     COUNT(*),
	 RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
FROM Netflix
GROUP BY 1,2

) as t1
WHERE ranking = 1;


--Q3.List all movies released in a specific year (e.g. 2020).

SELECT * FROM Netflix
WHERE type = 'Movie'
AND release_year = '2020';


--Q4.Find the top 5 countries with the most content on Netflix.

SELECT 
     UNNEST(STRING_TO_ARRAY(country,',')) as country,
     COUNT(show_id) as content
FROM Netflix
GROUP BY 1
ORDER BY 1 DESC
LIMIT 5;


--Q5.Identify the longest movie or TV show duration.

SELECT * FROM Netflix
WHERE duration = (SELECT MAX(duration) FROM Netflix);


--Q6.Find content added in the last 5 years.

SELECT * FROM Netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';


--Q7.Find all the movies / TV Shows by director 'Rajiv Chilaka'.

SELECT
      *
FROM Netflix
WHERE director ILIKE '%Rajiv Chilaka%';


--Q8.List all TV Shows with more than 5 seasons.

SELECT * FROM Netflix
WHERE type = 'TV Show'
AND SPLIT_PART(duration, ' ', 1) :: numeric > 5;

--Q9.Count the number of content items in each genre. 

SELECT 
     UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	 COUNT(Show_id) as total_content 
FROM 
    Netflix
GROUP BY 1;


--Q10.Find the average release year for content produced in a specific country release by India on Netflix.
--return top 5 year with highest avg content release.

SELECT * FROM Netflix;

SELECT 
      EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
	  COUNT(*),
	  ROUND(COUNT(*):: numeric/(SELECT COUNT(*) FROM Netflix WHERE country = 'India'):: numeric  * 100,2) as avg_content_per_year
FROM Netflix
WHERE country = 'India'
GROUP BY 1;


--Q11.List all movies that are documentaries.

SELECT * FROM Netflix
WHERE type = 'Movie'
AND listed_in ILIKE '%Documentaries%';


--Q12.Find all content without a director.

SELECT * FROM Netflix
WHERE director IS NULL;


--Q13.Find how many movies actor 'Salman Khan' appeared in last 10 years.

SELECT * FROM Netflix
WHERE casts ILIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;



--Q14.Find the top 10 actors who have appearded in the highest number of movies produced in india.

SELECT 
     UNNEST(STRING_TO_ARRAY(casts, ',')) as actors,
	 COUNT(*) AS Total_content
FROM Netflix
WHERE country LIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 10;



--Q15.Categorize the content based on the presence of the keyword 'kill' and 'violence' in the description field. lablel content 
--containing these keywords as 'Bed' and all other content as 'Good'. Count how many items fall into each category.


WITH New_table 
AS
(
SELECT *,
     CASE 
	     WHEN
		      description ILIKE '%kills%' OR 
		      description ILIKE '%violence%' THEN 'Bad content'
			  ELSE 'Good content'
		 END category 
FROM 
    Netflix	
)
SELECT 
     category,
	 COUNT(*) AS Total_content
FROM New_table 
GROUP BY 1;
















