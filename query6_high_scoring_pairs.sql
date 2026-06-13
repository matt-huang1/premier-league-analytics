SELECT
    LEAST(home_team_id, away_team_id) AS team_a,
    GREATEST(home_team_id, away_team_id) AS team_b,
    ROUND(AVG(home_goals + away_goals), 2) AS goals_per_game,
    COUNT(*) AS no_of_matches
FROM matches
GROUP BY LEAST(home_team_id, away_team_id), GREATEST(home_team_id, away_team_id)
HAVING COUNT(*) >= 4
ORDER BY AVG(home_goals + away_goals) DESC;

-- Using LEAST, GREATEST to alphabetically sort and fix position to avoid reverse fixture mismatch. Added HAVING COUNT(*) >= 4 to show more reliable observations as there were some particularly high scoring but occured twice which weren't as meaningful or reliable. 