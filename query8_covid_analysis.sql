SELECT
    season_id,
    CASE
        WHEN season_id = 201920 THEN 'COVID-Partial'
        WHEN season_id = 202021 THEN 'COVID-NoFans'
        WHEN season_id >= 202122 THEN 'Post-Covid'
        ELSE 'Pre-Covid'
    END AS treatment,
    ROUND(CAST(SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS NUMERIC) / COUNT(match_id), 3) AS home_win_rate,
    ROUND(AVG(home_goals), 3) AS avg_home_goals,
    ROUND(AVG(away_goals), 3) AS avg_away_goals
FROM matches
GROUP BY season_id
ORDER BY season_id;

-- Classify seasons, then compare home_win_rates across each season. 