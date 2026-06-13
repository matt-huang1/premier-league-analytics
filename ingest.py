import pandas as pd
from sqlalchemy import create_engine, text

TEAM_NAME_MAP = {
    "Arsenal": "Arsenal",
    "Aston Villa": "Aston Villa",
    "Bournemouth": "Bournemouth",
    "Brentford": "Brentford",
    "Brighton": "Brighton & Hove Albion",
    "Burnley": "Burnley",
    "Chelsea": "Chelsea",
    "Crystal Palace": "Crystal Palace",
    "Everton": "Everton",
    "Fulham": "Fulham",
    "Leeds": "Leeds United",
    "Leicester": "Leicester City",
    "Liverpool": "Liverpool",
    "Luton": "Luton Town",
    "Man City": "Manchester City",
    "Man United": "Manchester United",
    "Newcastle": "Newcastle United",
    "Norwich": "Norwich City",
    "Nott'm Forest": "Nottingham Forest",
    "Sheffield United": "Sheffield United",
    "Southampton": "Southampton",
    "Tottenham": "Tottenham Hotspur",
    "Watford": "Watford",
    "West Brom": "West Bromwich Albion",
    "West Ham": "West Ham United",
    "Wolves": "Wolverhampton Wanderers"
}

TEAM_ID_MAP = {
    "Arsenal": "ARS",
    "Aston Villa": "AVL",
    "Bournemouth": "BOU",
    "Brentford": "BRE",
    "Brighton & Hove Albion": "BHA",
    "Burnley": "BUR",
    "Chelsea": "CHE",
    "Crystal Palace": "CRY",
    "Everton": "EVE",
    "Fulham": "FUL",
    "Leeds United": "LEE",
    "Leicester City": "LEI",
    "Liverpool": "LIV",
    "Luton Town": "LUT",
    "Manchester City": "MCI",
    "Manchester United": "MUN",
    "Newcastle United": "NEW",
    "Norwich City": "NOR",
    "Nottingham Forest": "NFO",
    "Sheffield United": "SHU",
    "Southampton": "SOU",
    "Tottenham Hotspur": "TOT",
    "Watford": "WAT",
    "West Bromwich Albion": "WBA",
    "West Ham United": "WHU",
    "Wolverhampton Wanderers": "WOL"
}

TEAMS_DATA = [
    {"team_id": "ARS", "team_name": "Arsenal", "city": "London", "stadium": "Emirates Stadium", "founded_year": 1886},
    {"team_id": "AVL", "team_name": "Aston Villa", "city": "Birmingham", "stadium": "Villa Park", "founded_year": 1874},
    {"team_id": "BOU", "team_name": "Bournemouth", "city": "Bournemouth", "stadium": "Vitality Stadium", "founded_year": 1899},
    {"team_id": "BRE", "team_name": "Brentford", "city": "London", "stadium": "Gtech Community Stadium", "founded_year": 1889},
    {"team_id": "BHA", "team_name": "Brighton & Hove Albion", "city": "Brighton", "stadium": "Amex Stadium", "founded_year": 1901},
    {"team_id": "BUR", "team_name": "Burnley", "city": "Burnley", "stadium": "Turf Moor", "founded_year": 1882},
    {"team_id": "CHE", "team_name": "Chelsea", "city": "London", "stadium": "Stamford Bridge", "founded_year": 1905},
    {"team_id": "CRY", "team_name": "Crystal Palace", "city": "London", "stadium": "Selhurst Park", "founded_year": 1905},
    {"team_id": "EVE", "team_name": "Everton", "city": "Liverpool", "stadium": "Hill Dickinson Stadium", "founded_year": 1878},
    {"team_id": "FUL", "team_name": "Fulham", "city": "London", "stadium": "Craven Cottage", "founded_year": 1879},
    {"team_id": "LEE", "team_name": "Leeds United", "city": "Leeds", "stadium": "Elland Road", "founded_year": 1919},
    {"team_id": "LEI", "team_name": "Leicester City", "city": "Leicester", "stadium": "King Power Stadium", "founded_year": 1884},
    {"team_id": "LIV", "team_name": "Liverpool", "city": "Liverpool", "stadium": "Anfield", "founded_year": 1892},
    {"team_id": "LUT", "team_name": "Luton Town", "city": "Luton", "stadium": "Kenilworth Road", "founded_year": 1885},
    {"team_id": "MCI", "team_name": "Manchester City", "city": "Manchester", "stadium": "Etihad Stadium", "founded_year": 1880},
    {"team_id": "MUN", "team_name": "Manchester United", "city": "Manchester", "stadium": "Old Trafford", "founded_year": 1878},
    {"team_id": "NEW", "team_name": "Newcastle United", "city": "Newcastle upon Tyne", "stadium": "St James' Park", "founded_year": 1892},
    {"team_id": "NOR", "team_name": "Norwich City", "city": "Norwich", "stadium": "Carrow Road", "founded_year": 1902},
    {"team_id": "NFO", "team_name": "Nottingham Forest", "city": "Nottingham", "stadium": "City Ground", "founded_year": 1865},
    {"team_id": "SHU", "team_name": "Sheffield United", "city": "Sheffield", "stadium": "Bramall Lane", "founded_year": 1889},
    {"team_id": "SOU", "team_name": "Southampton", "city": "Southampton", "stadium": "St Mary's Stadium", "founded_year": 1885},
    {"team_id": "TOT", "team_name": "Tottenham Hotspur", "city": "London", "stadium": "Tottenham Hotspur Stadium", "founded_year": 1882},
    {"team_id": "WAT", "team_name": "Watford", "city": "Watford", "stadium": "Vicarage Road", "founded_year": 1881},
    {"team_id": "WBA", "team_name": "West Bromwich Albion", "city": "West Bromwich", "stadium": "The Hawthorns", "founded_year": 1878},
    {"team_id": "WHU", "team_name": "West Ham United", "city": "London", "stadium": "London Stadium", "founded_year": 1895},
    {"team_id": "WOL", "team_name": "Wolverhampton Wanderers", "city": "Wolverhampton", "stadium": "Molineux Stadium", "founded_year": 1877}
]

SEASONS_DATA = [
    {"season_id": 201920, "season_label": "2019/20", "start_date": "2019-08-09", "end_date": "2020-07-26"},
    {"season_id": 202021, "season_label": "2020/21", "start_date": "2020-09-12", "end_date": "2021-05-23"},
    {"season_id": 202122, "season_label": "2021/22", "start_date": "2021-08-14", "end_date": "2022-05-22"},
    {"season_id": 202223, "season_label": "2022/23", "start_date": "2022-08-05", "end_date": "2023-05-28"},
    {"season_id": 202324, "season_label": "2023/24", "start_date": "2023-08-11", "end_date": "2024-05-19"}
]

engine = create_engine("postgresql://matthewhuang:@localhost:5432/prem_analytics")

def insert(table_name, table_data):
    with engine.connect() as conn:
        result = conn.execute(text(f'SELECT COUNT(*) FROM {table_name}'))
        count = result.scalar()
        if count == 0:
            df = pd.DataFrame(table_data)
            df.to_sql(f'{table_name}', engine, if_exists='append', index=False)
            print(f'{table_name} inserted.')
        else:
            print(f'{table_name} already exist, skipping.')

insert("teams", TEAMS_DATA)
insert("seasons", SEASONS_DATA)

files = ['2019-20.csv', '2020-21.csv', '2021-22.csv', '2022-23.csv', '2023-24.csv']
seasons_ids = [201920, 202021, 202122, 202223, 202324]

for file, season_id in zip(files, seasons_ids):
    df = pd.read_csv(file)
    df['season_id'] = season_id
    df = df[['season_id', 'Date', 'HomeTeam', 'AwayTeam', 'FTHG', 'FTAG', 'HS', 'AS', 'HST', 'AST', 'HC', 'AC', 'HY', 'AY', 'HR', 'AR']].rename(columns={
        'Date': 'match_date',
        'HomeTeam': 'home_team_id',
        'AwayTeam': 'away_team_id',
        'FTHG': 'home_goals',
        'FTAG': 'away_goals',
        'HS': 'home_shots', 
        'AS': 'away_shots', 
        'HST': 'home_shots_target', 
        'AST': 'away_shots_target', 
        'HC': 'home_corners',
        'AC': 'away_corners',
        'HY': 'home_yellows',
        'AY': 'away_yellows',
        'HR': 'home_reds',
        'AR': 'away_reds'
    })
    df['result'] = df['home_goals'].astype(str) + '-' + df['away_goals'].astype(str)
    df['home_team_id'] = df['home_team_id'].map(TEAM_NAME_MAP).map(TEAM_ID_MAP)
    df['away_team_id'] = df['away_team_id'].map(TEAM_NAME_MAP).map(TEAM_ID_MAP)
    df['match_date'] = pd.to_datetime(df['match_date'], dayfirst=True)
    df.to_sql('matches', engine, if_exists='append', index=False)
    print(f"{file} loaded, {len(df)} matches inserted.")

