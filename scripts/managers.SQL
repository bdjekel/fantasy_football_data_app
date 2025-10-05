-- Managers (people who play)
CREATE TABLE managers (
    manager_id SERIAL PRIMARY KEY,
    espn_member_id VARCHAR(50) UNIQUE NOT NULL,  -- The SWID
    display_name VARCHAR(100),
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Leagues
CREATE TABLE leagues (
    league_id SERIAL PRIMARY KEY,
    espn_league_id INTEGER UNIQUE NOT NULL,
    name VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Seasons (a league in a specific year)
CREATE TABLE seasons (
    season_id SERIAL PRIMARY KEY,
    league_id INTEGER REFERENCES leagues(league_id),
    year INTEGER NOT NULL,
    espn_season_id INTEGER,
    is_active BOOLEAN DEFAULT true,
    UNIQUE(league_id, year)
);

-- Teams (manager's team in a specific season)
CREATE TABLE teams (
    team_id SERIAL PRIMARY KEY,
    season_id INTEGER REFERENCES seasons(season_id),
    manager_id INTEGER REFERENCES managers(manager_id),
    espn_team_id INTEGER NOT NULL,
    team_name VARCHAR(255),
    team_abbrev VARCHAR(10),
    final_rank INTEGER,
    playoff_seed INTEGER,
    total_points DECIMAL(10,2),
    UNIQUE(season_id, espn_team_id)
);

-- Weekly team performance
CREATE TABLE weekly_team_stats (
    stat_id SERIAL PRIMARY KEY,
    team_id INTEGER REFERENCES teams(team_id),
    week INTEGER NOT NULL,
    points_scored DECIMAL(10,2),
    points_against DECIMAL(10,2),
    opponent_team_id INTEGER REFERENCES teams(team_id),
    result VARCHAR(10),  -- 'WIN', 'LOSS', 'TIE'
    league_rank INTEGER,  -- Standing after this week
    UNIQUE(team_id, week)
);

-- Season records (derived but useful for queries)
CREATE TABLE team_season_records (
    record_id SERIAL PRIMARY KEY,
    team_id INTEGER REFERENCES teams(team_id) UNIQUE,
    wins INTEGER DEFAULT 0,
    losses INTEGER DEFAULT 0,
    ties INTEGER DEFAULT 0,
    points_for DECIMAL(10,2),
    points_against DECIMAL(10,2)
);

-- Head-to-head records between managers
CREATE TABLE head_to_head_records (
    h2h_id SERIAL PRIMARY KEY,
    season_id INTEGER REFERENCES seasons(season_id),
    manager1_id INTEGER REFERENCES managers(manager_id),
    manager2_id INTEGER REFERENCES managers(manager_id),
    manager1_wins INTEGER DEFAULT 0,
    manager2_wins INTEGER DEFAULT 0,
    ties INTEGER DEFAULT 0,
    UNIQUE(season_id, manager1_id, manager2_id),
    CHECK (manager1_id < manager2_id)  -- Prevent duplicates
);

-- NFL Players
CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    espn_player_id INTEGER UNIQUE NOT NULL,
    name VARCHAR(255),
    position VARCHAR(10),
    nfl_team VARCHAR(10)
);

-- Draft picks
CREATE TABLE draft_picks (
    pick_id SERIAL PRIMARY KEY,
    season_id INTEGER REFERENCES seasons(season_id),
    team_id INTEGER REFERENCES teams(team_id),
    player_id INTEGER REFERENCES players(player_id),
    round INTEGER,
    pick_number INTEGER,
    overall_pick INTEGER,
    UNIQUE(season_id, overall_pick)
);

-- Weekly rosters (who started each week)
CREATE TABLE weekly_rosters (
    roster_id SERIAL PRIMARY KEY,
    team_id INTEGER REFERENCES teams(team_id),
    player_id INTEGER REFERENCES players(player_id),
    week INTEGER,
    lineup_slot VARCHAR(20),  -- 'QB', 'RB', 'FLEX', 'BENCH'
    was_started BOOLEAN,
    UNIQUE(team_id, player_id, week)
);

-- Player weekly stats (for ROI calculations)
CREATE TABLE player_weekly_stats (
    stat_id SERIAL PRIMARY KEY,
    player_id INTEGER REFERENCES players(player_id),
    season_id INTEGER REFERENCES seasons(season_id),
    week INTEGER,
    fantasy_points DECIMAL(10,2),
    actual_stats JSONB,  -- Store raw stats if needed
    UNIQUE(player_id, season_id, week)
);