-- Business question: What is the all-time head-to-head record between two specific clubs?
-- Technique: CTE + UNION ALL so each match contributes one row per team; filter with
--   WHERE on both home_team_id and away_team_id to isolate the fixture.
--   Change the team codes in the WHERE clauses to query any two clubs.

WITH h2h AS (
    SELECT
        home_team_id                                             AS team_id,
        home_goals                                               AS goals_for,
        away_goals                                               AS goals_against,
        CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END     AS win,
        CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END     AS draw,
        CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END     AS lost
    FROM matches
    WHERE home_team_id IN ('CHE', 'MCI')
      AND away_team_id IN ('CHE', 'MCI')

    UNION ALL

    SELECT
        away_team_id                                             AS team_id,
        away_goals                                               AS goals_for,
        home_goals                                               AS goals_against,
        CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END     AS win,
        CASE WHEN home_goals = away_goals THEN 1 ELSE 0 END     AS draw,
        CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END     AS lost
    FROM matches
    WHERE home_team_id IN ('CHE', 'MCI')
      AND away_team_id IN ('CHE', 'MCI')
)
SELECT
    team_id,
    SUM(win)           AS wins,
    SUM(draw)          AS draws,
    SUM(lost)          AS losses,
    SUM(goals_for)     AS goals_for,
    SUM(goals_against) AS goals_against
FROM h2h
GROUP BY team_id;
