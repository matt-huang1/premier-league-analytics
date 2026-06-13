-- Business question: How does a team's disciplinary record (yellow and red cards) trend
--   across seasons, smoothed over a rolling 3-season window?
-- Technique: Two CTEs — first unpivots home/away bookings, second aggregates per season;
--   outer SELECT applies AVG() OVER with ROWS BETWEEN 2 PRECEDING AND CURRENT ROW.
--   Change the WHERE clause to query any club by team_id.

WITH discipline AS (
    SELECT home_team_id AS team_id, season_id, home_yellows AS yellows, home_reds AS reds
    FROM matches

    UNION ALL

    SELECT away_team_id AS team_id, season_id, away_yellows AS yellows, away_reds AS reds
    FROM matches
),
season_totals AS (
    SELECT
        team_id,
        season_id,
        SUM(yellows) AS total_yellows,
        SUM(reds)    AS total_reds
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
FROM season_totals
WHERE team_id = 'LIV';
