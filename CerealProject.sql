/* Exploratory analysis of 77 different cereals nutrition data*/

/* Start by viewing the entire dataset to ensure data is cleaned and verify the data is accurate */

SELECT *
from portfolioprojects.dbo.cereal

/* Let's take a look at the cereals with the highest and lowest ratings */

SELECT top 5 name, rating
FROM dbo.cereal
ORDER BY rating

-- This tells us the lowest rated cereals: Cap'n'Crunch, Cinnamon Toast Crunch, Honey Graham Ohs, Count Chocula, Cocoa Puffs

SELECT top 5 name, rating
FROM dbo.cereal
ORDER BY rating DESC

-- This tells us the highest rated cereals: All-Bran with Extra Fiber, Shredded Wheat 'n'Bran, Shredded Wheat spoon size, 100% Bran, Shredded Wheat

/* Let's look at the cereal ratings compared with their manufactures*/

SELECT *
from dbo.cereal

-- I want to fill in column 'mfr' with the full name instead of just an abbreviation

SELECT mfr
	,CASE
		WHEN mfr = 'N' THEN 'Nabisco'
		WHEN mfr = 'A' THEN 'American Home Food Products'
		WHEN mfr = 'G' THEN 'General Mills'
		WHEN mfr = 'K' THEN 'Kelloggs'
		WHEN mfr = 'P' THEN 'Post'
		WHEN mfr = 'Q' THEN 'Quaker Oats'
		WHEN mfr = 'R' THEN 'Ralston Purina'
		ELSE 'n/a'
	END as Fullmfr
from dbo.cereal

-- I will replace the old mfr column with the new column
UPDATE dbo.cereal
SET mfr =
	(CASE WHEN mfr = 'N' THEN 'Nabisco'
		WHEN mfr = 'A' THEN 'American Home Food Products'
		WHEN mfr = 'G' THEN 'General Mills'
		WHEN mfr = 'K' THEN 'Kelloggs'
		WHEN mfr = 'P' THEN 'Post'
		WHEN mfr = 'Q' THEN 'Quaker Oats'
		WHEN mfr = 'R' THEN 'Ralston Purina'
		ELSE 'n/a'
        END)


SELECT mfr, AVG(rating) as mfr_avg_rating, COUNT (mfr) as Number_of_cereals
from dbo.cereal
GROUP BY mfr
ORDER BY mfr_avg_rating DESC

-- It looks like Nabisco (68%) has the highest avg rating while General Mills (34%) has the lowest avg rating

/* Let's continue to look at ratings, but this time compare ratings with sugar content */

SELECT mfr, AVG(rating) as mfr_avg_rating, COUNT (mfr) as Number_of_cereals, AVG (sugars) as sugar_avg
from dbo.cereal
GROUP BY mfr
ORDER BY mfr_avg_rating DESC

-- It appears that the mfr with the highest rating has the lowest average sugar content, while the lowest rating has the highest
-- avg sugar content

/* Let's replace sugars with fiber this time */

SELECT mfr, AVG(rating) as mfr_avg_rating, COUNT (mfr) as Number_of_cereals, AVG (fiber) as fiber_avg
from dbo.cereal
GROUP BY mfr
ORDER BY mfr_avg_rating DESC

-- The mfr with the highest avg rating also has the highest avg fiber content in their cereals

SELECT mfr, AVG(rating) as mfr_avg_rating, COUNT (mfr) as Number_of_cereals, AVG (calories) as calorie_avg
from dbo.cereal
GROUP BY mfr
ORDER BY mfr_avg_rating DESC

-- The mfr with the highest ratings also had fewer calories on average than the other mfr's

/* This exploratory analysis of 77 different cereals gave us some nutritional insight on cereal in general and specific
cereal manufactures. We found the top/bottom 5 rated cereals, as well as the average rating of each manufacture's products. We used
a case statement to make the data more readable and easier to work with. We compared each manufacturer's average rating with their
product's sugar, fiber, and calorie content. Nabisco, the highest rated cereal manufacturer in the dataset, produces cereal with
a higher fiber content and lower sugar/caloric content than their competition.
