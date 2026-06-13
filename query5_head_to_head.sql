WITH h2h AS (
        SELECT home_team_id AS team_id, home_goals AS goals_for, away_goals AS goals_against,
            CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END AS win,
            CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END AS draw,
            CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END AS lost
        FROM matches
        WHERE home_team_id in ('CHE', 'MCI') AND away_team_id in ('CHE', 'MCI')

    UNION ALL 

    SELECT away_team_id AS team_id, away_goals AS goals_for, home_goals AS goals_against,
        CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END AS lost,
        CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END AS draw,
        CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END AS win
    FROM matches
    WHERE home_team_id in ('CHE', 'MCI') AND away_team_id in ('CHE', 'MCI')

)
SELECT 
    team_id,
    SUM(win) AS wins,
    SUM(draw) AS draws,
    SUM(lost) AS losses,
    SUM(goals_for) as goals_for,
    SUM(goals_against) as goals_against
From h2h
GROUP BY team_id;

-- Similar CTEs, WHERE clause can adjust for any head to head. 