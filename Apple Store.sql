--Exploring Data

SELECT *
FROM [Portfolio Project]..[APPLE STORE]

SELECT *
FROM [Portfolio Project]..[Apple Store Description]

--Check The Number of Unique Apps in Both Tables

SELECT COUNT(id) AS Unique_app_ids
FROM [Portfolio Project]..[APPLE STORE]

SELECT COUNT(id) AS Unique_app_ids
FROM [Portfolio Project]..[Apple Store Description]

--Check For Missing Values

SELECT COUNT(*) AS Missing_Values
FROM [Portfolio Project]..[APPLE STORE]
WHERE track_name IS NULL OR prime_genre IS NULL OR user_rating IS NULL

SELECT COUNT(*) AS Missing_Values
FROM [Portfolio Project]..[Apple Store Description]
WHERE track_name IS NULL OR app_desc IS NULL

--Find The Number of Apps per Genre

SELECT DISTINCT(prime_genre), COUNT(prime_genre)
FROM [Portfolio Project]..[APPLE STORE]
GROUP BY prime_genre
ORDER BY 2 DESC

--Get an Overview of Apps Rating

SELECT MIN(user_rating) AS Min_Rating,
       AVG(user_rating) AS Avg_Rating,
	   MAX(user_rating) AS Max_Rating
FROM [Portfolio Project]..[APPLE STORE]

--Data Analysis

--Determine Whether Paid Apps Have Higher Rating Than Free Apps

SELECT CASE
           WHEN price > 0 THEN 'Paid'
		   ELSE 'Free'
		   END AS App_Type,
       AVG(user_rating) AS Avg_Rating
FROM [Portfolio Project]..[APPLE STORE]
GROUP BY (CASE
           WHEN price > 0 THEN 'Paid'
		   ELSE 'Free'
		   END) 

--Check if Apps With More Supported Languages Have Higher Rating

SELECT CASE
           WHEN lang_num < 10 THEN '< 10 Languages'
		   WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Languages'		  
		   ELSE '> 30 Languages'
		   END AS Languages_backet,
       AVG(user_rating) AS Avg_Rating
FROM [Portfolio Project]..[APPLE STORE]
GROUP BY CASE
           WHEN lang_num < 10 THEN '< 10 Languages'
		   WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 Languages'		  
		   ELSE '> 30 Languages'
		   END
ORDER BY AVG(user_rating) DESC

--Check Genre With Low Rating

SELECT prime_genre, AVG(user_rating) AS Avg_Rating
FROM [Portfolio Project]..[APPLE STORE]
GROUP BY prime_genre
ORDER BY Avg_Rating ASC

--Check if There is Correlation Between the Length of The App Description and The User Rating

SELECT CASE
           WHEN LEN(B.app_desc) < 500 THEN 'Short'
		   WHEN LEN(B.app_desc) BETWEEN 500 AND 1000 THEN 'Meduim'
		   ELSE 'Long'
		   END AS Description_length_backet,
         AVG(A.user_rating) AS Avg_Rating
FROM [Portfolio Project]..[Apple Store] AS A
JOIN [Portfolio Project]..[Apple Store Description] AS B
ON A.id = B.id
GROUP BY CASE
           WHEN LEN(B.app_desc) < 500 THEN 'Short'
		   WHEN LEN(B.app_desc) BETWEEN 500 AND 1000 THEN 'Meduim'
		   ELSE 'Long'
		   END
ORDER BY AVG(user_rating) DESC

--Check The Top Rated App For Each Genre

SELECT prime_genre, track_name, user_rating
FROM (
       SELECT prime_genre, 
	          track_name, 
			  user_rating,
			  RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
			  FROM [Portfolio Project]..[Apple Store]
			  ) AS A
WHERE A.rank = 1