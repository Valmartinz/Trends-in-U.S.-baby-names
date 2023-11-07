--Task1
--Find names that have been given to over 5,000 babies of either sex every year for the 101 years from 1920 through 2020; recall that names only show up in our dataset when at least 5,000 babies have been given that name in a year.
SELECT first_name,
        SUM(num)
FROM baby_names
GROUP BY first_name
HAVING COUNT(year) = 101
ORDER BY SUM(num) DESC;

--Task2
--Classify each name's popularity according to the number of years that the name appears in the dataset.
SELECT first_name, SUM(num),
        CASE WHEN COUNT(year) > 80 THEN 'Classic'
            WHEN COUNT(year) > 50 THEN 'Semi-classic'
            WHEN COUNT(year) > 20 THEN 'Semi-trendy'
            ELSE 'Trendy' END AS popularity_type
FROM baby_names
GROUP BY first_name
ORDER BY first_name;

--Task3
--Let's take a look at the ten highest-ranked American female names in our dataset.
SELECT 
      RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank,
      first_name, SUM(num)
FROM baby_names
WHERE sex = 'F'
GROUP BY first_name
LIMIT 10;

--Task4
--Return a list of first names which meet this friend's baby name criteria.
SELECT first_name
FROM baby_names
WHERE sex = 'F' AND year > 2015
AND first_name LIKE '%a'
GROUP BY first_name
ORDER BY SUM(num) DESC;

--Task5
--Find the cumulative number of babies named Olivia over the years since the name first appeared in our dataset.
SELECT year, first_name, num,
        SUM(num) OVER (ORDER BY year) AS cumulative_olivias
FROM baby_names
WHERE first_name = 'Olivia'
ORDER BY year;

--Task6
--Write a query that selects the year and the maximum num of babies given any male name in that year.
SELECT year, MAX(num) AS max_num
FROM baby_names
WHERE sex = 'M'
GROUP BY year;

--Task7
--Using the previous task's code as a subquery, look up the first_name that corresponds to the maximum number of babies given a specific male name in a year.
SELECT b.year, b.first_name, b.num
FROM baby_names AS b
INNER JOIN(
    SELECT year, MAX(num) as max_num
    FROM baby_names
    WHERE sex = 'M'
    GROUP BY year) AS subquery 
ON subquery.year = b.year 
AND subquery.max_num = b.num
ORDER BY year DESC;

--Task8
--Return a list of first names that have been the top male first name in any year along with a count of the number of years that name has been the top name.
WITH top_male_names AS (
    SELECT b.year, b.first_name, b.num
    FROM baby_names AS b
    INNER JOIN(
        SELECT year, MAX(num) as max_num
        FROM baby_names
        WHERE sex = 'M'
        GROUP BY year) AS subquery 
    ON subquery.year = b.year 
        AND subquery.max_num = b.num
    ORDER BY year DESC
        )
SELECT first_name, COUNT(first_name) AS count_top_name
FROM top_male_names
GROUP BY first_name
ORDER BY count_top_name DESC;
