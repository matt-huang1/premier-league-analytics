-- Business question: What is each team's rolling 6-game form (points) at every
--   match day within a season?
-- Technique: CTE to unpivot home/away rows and assign points; ROW_NUMBER() for match
--   sequence; SUM() window with ROWS BETWEEN 5 PRECEDING AND CURRENT ROW for the
--   rolling 6-game window.

WITH combined_matches AS (
    SELECT
        home_team_id AS team_id,
        season_id,
        match_date,
        CASE
            WHEN home_goals > away_goals THEN 3
            WHEN home_goals = away_goals THEN 1
            ELSE 0
        END AS points
    FROM matches

    UNION ALL

    SELECT
        away_team_id AS team_id,
        season_id,
        match_date,
        CASE
            WHEN home_goals < away_goals THEN 3
            WHEN home_goals = away_goals THEN 1
            ELSE 0
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
