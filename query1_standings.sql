-- Business question: What is the final league standings table for each season?
-- Technique: UNION ALL to unpivot home/away rows into a single perspective per team,
--   CASE WHEN to assign points (3/1/0), then GROUP BY + ORDER BY to sort the table.

WITH all_results AS (
    SELECT
        home_team_id AS team_id,
        season_id,
        home_goals   AS goals_for,
        away_goals   AS goals_against,
        CASE
            WHEN home_goals > away_goals THEN 3
            WHEN home_goals = away_goals THEN 1
            ELSE 0
        END AS points,
        CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END AS wins,
        CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END AS draws,
        CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END AS losses
    FROM matches

    UNION ALL

    SELECT
        away_team_id AS team_id,
        season_id,
        away_goals   AS goals_for,
        home_goals   AS goals_against,
        CASE
            WHEN home_goals < away_goals THEN 3
            WHEN home_goals = away_goals THEN 1
            ELSE 0
        END AS points,
        CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END AS wins,
        CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END AS draws,
        CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END AS losses
    FROM matches
)
SELECT
    team_id,
    season_id,
    SUM(wins)                                    AS wins,
    SUM(draws)                                   AS draws,
    SUM(losses)                                  AS losses,
    SUM(goals_for)                               AS goals_for,
    SUM(goals_against)                           AS goals_against,
    SUM(goals_for) - SUM(goals_against)          AS goal_difference,
    SUM(points)                                  AS points
FROM all_results
GROUP BY team_id, season_id
ORDER BY season_id, points DESC;
