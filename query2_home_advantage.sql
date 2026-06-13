-- Business question: How does home advantage (win rate, goals scored) vary by season?
-- Technique: Conditional SUM / COUNT to compute home win rate; CAST to NUMERIC avoids
--   integer division before passing to ROUND.

SELECT
    season_id,
    ROUND(
        CAST(SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS NUMERIC)
        / COUNT(match_id),
        3
    )                        AS home_win_rate,
    ROUND(AVG(home_goals), 3) AS avg_home_goals,
    ROUND(AVG(away_goals), 3) AS avg_away_goals
FROM matches
GROUP BY season_id
ORDER BY season_id;
