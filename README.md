# Premier League Analytics

A relational analytics project covering **1,900 matches across five Premier League seasons (2019/20 to 2023/24)**. Match data is ingested from raw CSVs into a normalised PostgreSQL database, queried with analytical SQL (window functions, CTEs, difference-in-differences), and visualised in Tableau.

![League Overview](screenshots/League_Overview.png)

---

## Tech Stack

| Layer | Tool |
|---|---|
| Database | PostgreSQL 15 (local) |
| Ingestion | Python 3 (pandas, SQLAlchemy, python-dotenv) |
| Analysis | SQL (window functions, CTEs) |
| Visualisation | Tableau Desktop (live PostgreSQL connection) |
| Data source | [football-data.co.uk](https://www.football-data.co.uk) (free CSV downloads) |

---

## Database Schema

```
teams        -- club metadata (abbreviation, full name, city, stadium, founded year)
seasons      -- one row per season with start/end dates
matches      -- one row per match: home/away goals, shots, corners, bookings
standings    -- pre-computed end-of-season table (also derivable via query1)
```

See [schema.sql](schema.sql) for full `CREATE TABLE` statements with FK constraints, or [ERD.png](ERD.png) for the entity-relationship diagram.

---

## Running Locally

### Prerequisites

- PostgreSQL 15+ installed and running
- Python 3.9+

### Setup

```bash
# 1. Clone the repo
git clone <repo-url>
cd premier-league

# 2. Install Python dependencies
pip install pandas sqlalchemy psycopg2-binary python-dotenv

# 3. Create the database
createdb prem_analytics

# 4. Apply the schema
psql -d prem_analytics -f schema.sql

# 5. Configure the database connection
cp .env.example .env
# Edit .env and set DATABASE_URL, e.g.:
# DATABASE_URL=postgresql://your_username:your_password@localhost:5432/prem_analytics

# 6. Run the ingestion pipeline
python3 ingest.py
```

The pipeline is idempotent for the `teams` and `seasons` tables (skips if rows already exist). The `matches` table is appended on each run, so truncate it first if you need a clean reload.

> **Note:** The raw CSV files (`2019-20.csv` through `2023-24.csv`) are excluded from this repo via `.gitignore` due to size. Download them from [football-data.co.uk](https://www.football-data.co.uk/englandm.php) and place them in the project root before running `ingest.py`.

### Connecting Tableau

1. Open Tableau Desktop and go to Connect > PostgreSQL
2. Server: `localhost`, Port: `5432`, Database: `prem_analytics`
3. Enter your PostgreSQL credentials
4. The four tables (`teams`, `seasons`, `matches`, `standings`) will appear in the schema browser

---

## Queries

| File | Business Question |
|---|---|
| [query1_standings.sql](query1_standings.sql) | Full league table derived from raw match results |
| [query2_home_advantage.sql](query2_home_advantage.sql) | Home win rate and goals per season |
| [query3_form_table.sql](query3_form_table.sql) | Rolling 6-game form for each team at every match day |
| [query4_shot_conversion.sql](query4_shot_conversion.sql) | Shot-on-target conversion rate, ranked within each season |
| [query5_head_to_head.sql](query5_head_to_head.sql) | All-time head-to-head record between any two clubs |
| [query6_high_scoring_pairs.sql](query6_high_scoring_pairs.sql) | Fixture pairings with the highest average goals per game |
| [query7_discipline.sql](query7_discipline.sql) | Rolling 3-season average yellow and red cards per club |
| [query8_covid_analysis.sql](query8_covid_analysis.sql) | Difference-in-differences analysis of COVID's effect on home advantage |

---

## Key Findings

### 1. COVID eliminated the home advantage

Home win rate fell from **45.3% in 2019/20** to **37.9% in 2020/21**, the season played entirely behind closed doors. Average home goals (1.353) converged with average away goals (1.342), wiping out the usual scoring edge. After fans returned, win rates recovered and peaked at **48.4% in 2022/23**. Crowd support looks like a real driver of home performance rather than just background noise.

> Caveat: the 2019/20 baseline is slightly contaminated. Matches from March 2020 onwards were played without fans after the season restarted, which compresses the apparent pre-COVID advantage.

### 2. High shot conversion does not guarantee a high league finish

Tottenham finished 6th (2019/20) and 4th (2020/21) despite ranking 2nd and 1st in shot conversion in both seasons. West Ham ranked 2nd in conversion in 2021/22 and 2023/24, finishing 7th and 9th respectively. Teams that take fewer but higher-quality shots will tend to post strong conversion numbers, so volume and defensive solidity still matter a lot for where you end up.

### 3. Manchester City vs Watford is the highest-scoring fixture in the dataset

Averaging **5.5 goals per game** across four meetings, it tops the fixture table. More consistent examples over longer spans include Leicester City vs Tottenham (8 meetings, 4.5 goals/game) and Newcastle United vs West Ham (10 meetings, 4.3 goals/game).

---

## Dashboard Screenshots

![COVID Dashboard](screenshots/COVID_Dashboard.png)
![Shot Conversion](screenshots/Shot_Conversion_Dashboard.png)

---

## Project Structure

```
premier-league/
├── schema.sql                    # CREATE TABLE statements
├── ingest.py                     # CSV to PostgreSQL ingestion pipeline
├── query1_standings.sql          # League table from raw results
├── query2_home_advantage.sql     # Home advantage by season
├── query3_form_table.sql         # Rolling 6-game form
├── query4_shot_conversion.sql    # Shot conversion ranking
├── query5_head_to_head.sql       # Head-to-head record
├── query6_high_scoring_pairs.sql # Highest-scoring fixtures
├── query7_discipline.sql         # Rolling discipline trend
├── query8_covid_analysis.sql     # COVID difference-in-differences
├── insights_summary.md           # Plain-English briefing note
├── ERD.png                       # Entity-relationship diagram
├── screenshots/                  # Tableau dashboard screenshots
├── .env.example                  # Database connection template
└── .gitignore
```