-- Business question: Did the absence of fans during COVID-19 measurably reduce home
--   advantage?  Compares home win rate and average goals across four treatment groups.
-- Technique: CASE WHEN to label each season's COVID status, then GROUP BY season for a
--   difference-in-differences-style comparison.  Note: 2019/20 is labelled 'COVID-Partial'
--   because matches from March 2020 onwards were played behind closed doors after the
--   season resumed, slightly contaminating the pre-COVID baseline.

SELECT
    season_id,
    CASE
        WHEN season_id = 201920 THEN 'COVID-Partial'
        WHEN season_id = 202021 THEN 'COVID-NoFans'
        WHEN season_id >= 202122 THEN 'Post-COVID'
        ELSE 'Pre-COVID'
    END AS treatment,
    ROUND(
        CAST(SUM(CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END) AS NUMERIC)
        / COUNT(match_id),
        3
    )                         AS home_win_rate,
    ROUND(AVG(home_goals), 3) AS avg_home_goals,
    ROUND(AVG(away_goals), 3) AS avg_away_goals
FROM matches
GROUP BY season_id
ORDER BY season_id;
