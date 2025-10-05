--Create initial tables 
-- depends: 

-- Managers (people who play fantasy football)
CREATE TABLE managers (
    manager_id SERIAL PRIMARY KEY,
    espn_member_id VARCHAR(50) UNIQUE NOT NULL,  -- ESPN's SWID
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
    is_active BOOLEAN DEFAULT TRUE,
    UNIQUE(league_id, year)
);

-- Manager participation in a season
CREATE TABLE manager_seasons (
    manager_season_id SERIAL PRIMARY KEY,
    manager_id INTEGER REFERENCES managers(manager_id),
    season_id INTEGER REFERENCES seasons(season_id),
    espn_team_id INTEGER NOT NULL,  -- ESPN's team ID for API mapping
    team_name VARCHAR(255),
    team_abbrev VARCHAR(10),
    logo_url TEXT,
    final_rank INTEGER,
    playoff_seed INTEGER,
    total_points DECIMAL(10,2),
    UNIQUE(manager_id, season_id),
    UNIQUE(season_id, espn_team_id)  -- Prevent duplicate ESPN team IDs in same season
);

-- Co-ownership tracking (if teams have multiple managers)
CREATE TABLE manager_season_ownership (
    manager_id INTEGER REFERENCES managers(manager_id),
    manager_season_id INTEGER REFERENCES manager_seasons(manager_season_id),
    ownership_percentage DECIMAL(5,2) DEFAULT 100.00,
    is_primary_owner BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (manager_id, manager_season_id)
);

-- Weekly manager performance
CREATE TABLE weekly_manager_stats (
    stat_id SERIAL PRIMARY KEY,
    manager_season_id INTEGER REFERENCES manager_seasons(manager_season_id),
    week INTEGER NOT NULL,
    points_scored DECIMAL(10,2),
    points_against DECIMAL(10,2),
    opponent_manager_season_id INTEGER REFERENCES manager_seasons(manager_season_id),
    result VARCHAR(10),  -- 'WIN', 'LOSS', 'TIE'
    league_rank INTEGER,  -- Standing after this week
    UNIQUE(manager_season_id, week)
);

-- Manager season records (aggregated stats for quick access)
CREATE TABLE manager_season_records (
    record_id SERIAL PRIMARY KEY,
    manager_season_id INTEGER REFERENCES manager_seasons(manager_season_id) UNIQUE,
    wins INTEGER DEFAULT 0,
    losses INTEGER DEFAULT 0,
    ties INTEGER DEFAULT 0,
    points_for DECIMAL(10,2),
    points_against DECIMAL(10,2),
    home_wins INTEGER DEFAULT 0,
    home_losses INTEGER DEFAULT 0,
    away_wins INTEGER DEFAULT 0,
    away_losses INTEGER DEFAULT 0
);

-- Head-to-head records between managers across all seasons
CREATE TABLE head_to_head_records (
    h2h_id SERIAL PRIMARY KEY,
    league_id INTEGER REFERENCES leagues(league_id),
    manager1_id INTEGER REFERENCES managers(manager_id),
    manager2_id INTEGER REFERENCES managers(manager_id),
    manager1_wins INTEGER DEFAULT 0,
    manager2_wins INTEGER DEFAULT 0,
    ties INTEGER DEFAULT 0,
    UNIQUE(league_id, manager1_id, manager2_id),
    CHECK (manager1_id < manager2_id)  -- Prevent duplicate pairs
);

-- NFL Players
CREATE TABLE players (
    player_id SERIAL PRIMARY KEY,
    espn_player_id INTEGER UNIQUE NOT NULL,
    name VARCHAR(255),
    position VARCHAR(10),
    nfl_team VARCHAR(10),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Draft picks
CREATE TABLE draft_picks (
    pick_id SERIAL PRIMARY KEY,
    season_id INTEGER REFERENCES seasons(season_id),
    manager_season_id INTEGER REFERENCES manager_seasons(manager_season_id),
    player_id INTEGER REFERENCES players(player_id),
    round INTEGER,
    pick_number INTEGER,  -- Pick within the round
    overall_pick INTEGER,  -- Overall pick number in draft
    UNIQUE(season_id, overall_pick)
);

-- Weekly rosters (who each manager started each week)
CREATE TABLE weekly_rosters (
    roster_id SERIAL PRIMARY KEY,
    manager_season_id INTEGER REFERENCES manager_seasons(manager_season_id),
    player_id INTEGER REFERENCES players(player_id),
    week INTEGER,
    lineup_slot VARCHAR(20),  -- 'QB', 'RB', 'WR', 'TE', 'FLEX', 'BENCH', 'IR'
    was_started BOOLEAN,  -- TRUE if in starting lineup, FALSE if benched
    UNIQUE(manager_season_id, player_id, week)
);

-- Player weekly fantasy stats (for ROI calculations)
CREATE TABLE player_weekly_stats (
    stat_id SERIAL PRIMARY KEY,
    player_id INTEGER REFERENCES players(player_id),
    season_id INTEGER REFERENCES seasons(season_id),
    week INTEGER,
    fantasy_points DECIMAL(10,2),
    actual_stats JSONB,  -- Raw stats from ESPN if needed
    UNIQUE(player_id, season_id, week)
);

-- Transactions (trades, waivers, free agent pickups)
CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    season_id INTEGER REFERENCES seasons(season_id),
    transaction_type VARCHAR(20),  -- 'TRADE', 'WAIVER', 'FREE_AGENT', 'DROP'
    transaction_date TIMESTAMP,
    week INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Transaction participants (who was involved in a transaction)
CREATE TABLE transaction_participants (
    participant_id SERIAL PRIMARY KEY,
    transaction_id INTEGER REFERENCES transactions(transaction_id),
    manager_season_id INTEGER REFERENCES manager_seasons(manager_season_id),
    player_id INTEGER REFERENCES players(player_id),
    action VARCHAR(20)  -- 'ACQUIRED', 'DROPPED', 'TRADED_AWAY', 'TRADED_FOR'
);
