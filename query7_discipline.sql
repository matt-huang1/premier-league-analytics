WITH discipline AS (
    SELECT home_team_id AS team_id, season_id, home_yellows AS yellows, home_reds AS reds
    FROM matches

    UNION ALL 

    SELECT away_team_id as team_id, season_id, away_yellows AS yellows, away_reds AS reds
    FROM matches
),
avg_discipline AS (
    SELECT team_id, season_id, SUM(yellows) AS total_yellows, SUM(reds) AS total_reds
    FROM discipline
    GROUP BY team_id, season_id
)
SELECT
    team_id,
    season_id,
    ROW_NUMBER() OVER (PARTITION BY team_id ORDER BY season_id) AS season_number,
    ROUND(AVG(total_yellows) OVER (
        PARTITION BY team_id
        ORDER BY season_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 3) AS avg_yellows,
    ROUND(AVG(total_reds) OVER (
        PARTITION BY team_id
        ORDER BY season_id
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 3) AS avg_reds
FROM avg_discipline
WHERE team_id = 'LIV';

-- One CTE to combine all yellows and reds for each team, second CTE to sum them up for each season, out SELECT gets rolling 3 season average. 