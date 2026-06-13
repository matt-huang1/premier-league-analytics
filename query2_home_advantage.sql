SELECT 
    season_id, 
    ROUND(CAST(SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS NUMERIC) / COUNT(match_id), 3) AS home_win_rate,
    ROUND(AVG(home_goals), 3) AS avg_home_goals,
    ROUND(AVG(away_goals), 3) AS avg_away_goals
FROM matches
GROUP BY season_id;

-- Similar aggregation to tally home wins to calculate avg home win rate, CAST to avoid integer division, NUMERIC instead of FLOAT for ROUND. 