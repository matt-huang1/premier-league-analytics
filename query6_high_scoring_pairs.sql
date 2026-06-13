-- Business question: Which fixture pairings produce the most goals on average?
-- Technique: LEAST/GREATEST to canonicalise the fixture regardless of home/away order
--   (avoids double-counting reversed fixtures); HAVING COUNT(*) >= 4 filters for
--   reliability — pairings with fewer meetings are noisy outliers.

SELECT
    LEAST(home_team_id, away_team_id)     AS team_a,
    GREATEST(home_team_id, away_team_id)  AS team_b,
    ROUND(AVG(home_goals + away_goals), 2) AS goals_per_game,
    COUNT(*)                              AS no_of_matches
FROM matches
GROUP BY
    LEAST(home_team_id, away_team_id),
    GREATEST(home_team_id, away_team_id)
HAVING COUNT(*) >= 4
ORDER BY AVG(home_goals + away_goals) DESC;
