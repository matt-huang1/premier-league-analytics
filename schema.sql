-- Premier League Analytics — database schema
-- Run once against an empty database: psql -d prem_analytics -f schema.sql

-- One row per club that appeared in the Premier League across the five seasons.
CREATE TABLE teams (
    team_id      VARCHAR(3)  PRIMARY KEY,
    team_name    VARCHAR(80),
    city         VARCHAR(80),
    stadium      VARCHAR(80),
    founded_year INTEGER
);

-- One row per season, used as a foreign key anchor on matches and standings.
CREATE TABLE seasons (
    season_id    INTEGER     PRIMARY KEY,
    season_label VARCHAR(7),
    start_date   DATE,
    end_date     DATE
);

-- One row per match.  All counting stats (shots, corners, bookings) are split
-- into home_* and away_* columns matching the football-data.co.uk CSV layout.
CREATE TABLE matches (
    match_id           SERIAL      PRIMARY KEY,
    season_id          INTEGER     REFERENCES seasons(season_id),
    match_date         DATE,
    home_team_id       VARCHAR(3)  REFERENCES teams(team_id),
    away_team_id       VARCHAR(3)  REFERENCES teams(team_id),
    home_goals         INTEGER,
    away_goals         INTEGER,
    result             VARCHAR(5),
    home_shots         INTEGER,
    away_shots         INTEGER,
    home_shots_target  INTEGER,
    away_shots_target  INTEGER,
    home_corners       INTEGER,
    away_corners       INTEGER,
    home_yellows       INTEGER,
    away_yellows       INTEGER,
    home_reds          INTEGER,
    away_reds          INTEGER
);

-- Pre-computed end-of-season standings table, populated separately from match results.
-- Query 1 derives the same figures on the fly if this table is not populated.
CREATE TABLE standings (
    standing_id      SERIAL  PRIMARY KEY,
    season_id        INTEGER REFERENCES seasons(season_id),
    team_id          VARCHAR(3) REFERENCES teams(team_id),
    matches_played   INTEGER,
    wins             INTEGER,
    draws            INTEGER,
    losses           INTEGER,
    goals_for        INTEGER,
    goals_against    INTEGER,
    goal_difference  INTEGER,
    points           INTEGER
);
