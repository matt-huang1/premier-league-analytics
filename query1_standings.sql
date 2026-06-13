WITH all_results AS (
    SELECT home_team_id AS team_id, season_id, home_goals AS goals_for, away_goals AS goals_against,
        CASE 
            WHEN home_goals > away_goals THEN +3
            WHEN home_goals = away_goals THEN +1
            WHEN home_goals < away_goals THEN +0
        END AS points,
        CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END AS wins,
        CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END AS draws,
        CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END AS losses
    FROM matches

    UNION ALL 

    SELECT away_team_id AS team_id, season_id, away_goals AS goals_for, home_goals AS goals_against,
        CASE 
            WHEN home_goals > away_goals THEN +0
            WHEN home_goals = away_goals THEN +1
            WHEN home_goals < away_goals THEN +3
        END AS points,
        CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END AS wins,
        CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END AS draws,
        CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END AS losses
    FROM matches
)
SELECT 
    team_id, 
    season_id,  
    SUM(wins) AS wins, 
    SUM(draws) AS draws, 
    SUM(losses) AS losses,
    SUM(goals_for) AS goals_for, 
    SUM(goals_against) AS goals_against, 
    SUM(goals_for) - SUM(goals_against) AS goal_difference,
    SUM(points) AS points
FROM all_results
GROUP BY team_id, season_id
ORDER BY season_id, points DESC;

-- Firstly starting off by calculating points on the home side, as well as tallying W/D/L, then similarly for the away side. UNION ALL to combine and then putting it in a CTE to select sum of relevant columns to build the table. 