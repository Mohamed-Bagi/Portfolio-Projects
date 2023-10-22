--**Exploring Data**

SELECT *
FROM [Portfolio Project]..[Absenteeism at Work]

SELECT *
FROM [Portfolio Project]..[Reasons]

SELECT *
FROM [Portfolio Project]..[compensation]

----Check The Number of Unique IDs in Both Tables

SELECT COUNT(ID)
FROM [Portfolio Project]..[Absenteeism at Work]

SELECT COUNT(ID)
FROM [Portfolio Project]..[compensation]

--Check For Missing Values

SELECT COUNT(*) AS Missing_Values
FROM [Portfolio Project]..[Absenteeism at Work]
WHERE ID IS NULL OR [Reason for absence] IS NULL

SELECT COUNT(*) AS Missing_Values
FROM [Portfolio Project]..[Reasons]
WHERE Reason IS NULL

SELECT COUNT(*) AS Missing_Values
FROM [Portfolio Project]..[compensation]
WHERE ID IS NULL OR comp_hr IS NULL


--Create a Join Table

SELECT *
FROM [Portfolio Project]..[Absenteeism at Work] A
JOIN [Portfolio Project]..[compensation] B
ON A.ID = B.ID
JOIN [Portfolio Project]..[Reasons] C
ON A.[Reason for absence] = C.Number

-- Find the Healthiest

SELECT *
FROM [Portfolio Project]..[Absenteeism at Work]
WHERE [Social smoker] = 0 AND [Social drinker] = 0 AND [Body mass index] < 25

-- Compensation rate increase for non smokers / budget is $983,221 so 0.68 increase per hour

SELECT COUNT(*) AS Non_Smokers
FROM [Portfolio Project]..[Absenteeism at Work]
WHERE [Social smoker] = 0

--optimize this query for the dashboard

SELECT A.ID, C.Reason, [Month of absence], [Body mass index],
CASE
    WHEN [Month of absence] IN (12,1,2) THEN 'Winter'
	WHEN [Month of absence] IN (3,4,5) THEN 'Spring'
	WHEN [Month of absence] IN (6,7,8) THEN 'Summer'
	WHEN [Month of absence] IN (9,10,11) THEN 'Fall'
	ELSE 'Unknown' END AS Season_Name,
CASE
    WHEN [Body mass index] < 18.5 THEN 'Underweight'
	WHEN [Body mass index] BETWEEN 18.5 AND 24.9 THEN 'Healthy Weight'
	WHEN [Body mass index] BETWEEN 25 AND 30 THEN 'Overweight'
	WHEN [Body mass index] > 30 THEN 'Obese'
	ELSE 'Unknown' END AS BMI_Category,
	Seasons,[Day of the week],[Transportation expense],Education,[Social drinker],
	[Social smoker],Age,[Work load Average/day],[Absenteeism time in hours],[Disciplinary failure],Son,Pet
FROM [Portfolio Project]..[Absenteeism at Work] A
JOIN [Portfolio Project]..[compensation] B
ON A.ID = B.ID
JOIN [Portfolio Project]..[Reasons] C
ON A.[Reason for absence] = C.Number