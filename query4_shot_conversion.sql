WITH shots_table AS (
    SELECT 
        home_team_id AS team_id,
        season_id,
        home_goals AS goals,
        home_shots_target AS shots_target
    FROM matches

    UNION ALL 

    SELECT 
        away_team_id AS team_id,
        season_id,
        away_goals AS goals,
        away_shots_target AS shots_target
    FROM matches
)
SELECT 
    team_id,
    season_id,
    ROUND(CAST(SUM(goals) AS NUMERIC) / SUM(shots_target), 3) AS conversion_rate,
    RANK() OVER (PARTITION BY season_id ORDER BY ROUND(CAST(SUM(goals) AS NUMERIC) / SUM(shots_target), 3) DESC) AS conversion_rank
FROM shots_table
GROUP BY team_id, season_id;

-- CTE to UNION ALL necessary home and away goals and shots on target columns, outer SELECT gets the conversion rate and RANK() to rank from best to worst.