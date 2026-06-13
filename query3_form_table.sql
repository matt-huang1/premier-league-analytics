WITH combined_matches AS (
    SELECT home_team_id AS team_id, season_id, match_date, 
        CASE    
            WHEN home_goals > away_goals THEN +3
            WHEN home_goals = away_goals THEN +1
            WHEN home_goals < away_goals THEN +0
        END AS points
    FROM matches

UNION ALL 

    SELECT away_team_id AS team_id, season_id, match_date, 
        CASE
            WHEN home_goals < away_goals THEN +3
            WHEN home_goals = away_goals THEN +1
            WHEN home_goals > away_goals THEN +0
        END AS points
    FROM matches
)
SELECT 
    team_id,
    season_id,
    match_date,
    ROW_NUMBER() OVER (PARTITION BY team_id, season_id ORDER BY match_date) AS match_number,
    SUM(points) OVER (
        PARTITION BY team_id, season_id
        ORDER BY match_date
        ROWS BETWEEN 5 PRECEDING AND CURRENT ROW
    ) AS form
FROM combined_matches;
--WHERE team_id = 'CHE';

-- In the CTE, combined all matches (home + away) and made points column, then used a rolling window function with frame clause to get last 6 match form