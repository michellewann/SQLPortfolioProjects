/* Cleaned Athletes Event Results Table */

SELECT [ID],
       [Name] AS 'Competitor Name',
       CASE WHEN Sex = 'M' THEN 'Male'
            WHEN Sex = 'F' THEN 'Female'
            ELSE Sex 
             END AS Sex, -- Better name for visualization and filers
       [Age],
       CASE WHEN Age < 18 THEN 'Under 18'
            WHEN Age BETWEEN 18 AND 25 THEN '18-25'
            WHEN Age BETWEEN 25 AND 30 THEN '25-30'
            WHEN Age > 30 THEN 'Over 30'
             END AS 'Age Grouping', 
       [Height],
       [Weight],
       [NOC] AS 'Nation Code',
       --[Games],
       -- RIGHT(Games,CHARINDEX(' ', REVERSE(Games)) -1) AS 'Season', -- Filtered based on Summer games so we no longer need this column
       SUBSTRING(games, 1,4) AS 'Year',
       --[City],
       [Sport],
       [Event],
       CASE WHEN [Medal] = 'NA' THEN 'Not Registered' -- Replacing NA with Not Registered
            ELSE Medal 
             END AS Medal
  FROM [olympic_games].[dbo].[athletes_event_results]
 WHERE RIGHT(Games,CHARINDEX(' ', REVERSE(Games)) -1) = 'Summer' -- Filtering the performance for the Summer Games
