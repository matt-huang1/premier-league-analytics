CREATE TABLE teams ( 
    team_id varchar(3),
    team_name char(80),
    city varchar(80),
    founded_year integer,
    stadium char(80),
    PRIMARY KEY (team_id)
 );

 CREATE TABLE seasons (
    season_id integer,
    season_label varchar(7),
    start_date date,
    end_date date,
    PRIMARY KEY (season_id)
 );


CREATE TABLE matches (
    match_id serial primary key,
    season_id integer references seasons(season_id),
    match_date date,
    home_team_id varchar(3) references teams(team_id), 
    away_team_id varchar(3) references teams(team_id),
    home_goals integer,
    away_goals integer,
    result varchar(5),
    home_shots integer,
    away_shots integer,
    home_shots_target integer,
    away_shots_target integer,
    home_corners integer,
    away_corners integer,
    home_yellows integer,
    away_yellows integer,
    home_reds integer,
    away_reds integer
);


CREATE TABLE standings (
    standing_id serial primary key,
    season_id integer references seasons(season_id),
    team_id varchar(3) references teams(team_id),
    matches_played integer,
    wins integer,
    draws integer,
    losses integer,
    goals_for integer,
    goals_against integer,
    goal_difference integer,
    points integer
);