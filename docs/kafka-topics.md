
#TODO: Complete documentation of topics.

# Reference Data Topics

## nfl.players
- **Purpose:** Stores NFL player metadata from ESPN
- **Key:** player_id
- **Value schema:**
    - player_id: int
    - name: string
    - position(s): array<string (enum: QB, RB, WR, TE, K, P, OP, D/ST, DT, DE, LB, DL, CB, S, DB, DP, HC)> 
    - team: string
    - injury_status: string (enum: OUT, QUESTIONABLE, DOUBTFUL, INJURED RESERVE)
    - stats: TBD
- **Producers:** TBD
- **Consumers:** TBD
- **Retention:** TBD
- **Partitions:** TBD

## fantasy.leagues
- **Purpose:** Stores leagues and league-wide information
- **Key:** league_id: int
- **Value schema:**
    - league_id: int
    - league_name: string
    - league_type: string (enum: PRIVATE, PUBLIC)
    - seasons: array<season_id: int>
- **Producers:** TBD
- **Consumers:** TBD
- **Retention:** TBD
- **Partitions:** TBD

## fantasy.seasons
- **Purpose:**
- **Key:** season_id: int
- **Value schema:** 
    - season_id: int
    - team_count: int
    - regular_week_count: int
    - playoff_week_count: int
    - final_standings: array<object>
        - ranking: int
        - manager_id: int
    - current_standings: array<object>
        - ranking: int
        - manager_id: int
    - completion_status: boolean
    - draft_recap: array<object>
        - draft_pick: int
        - player_id: int
    - commissioner: manager_id
    - league_settings: array<object>
        - TBD
    - scoring_settings: array<object>
        - TBD
    - draft_settings: array<object>
        - TBD
    - roster_settings: array<object>
        - TBD
- **Producers:** TBD
- **Consumers:** TBD
- **Retention:** TBD
- **Partitions:** TBD

#TODO: complete fantasy.managers schema

## fantasy.managers
- **Purpose:** Stores NFL player metadata from ESPN
- **Key:** player_id
- **Value schema:**
    - TBD
- **Producers:** TBD
- **Consumers:** TBD
- **Retention:** TBD
- **Partitions:** TBD

## fantasy.rosters
- **Purpose:** Current roster snapshot for each team, maintained from fantasy.roster-events.
- **Key:** team_id:season
- **Value schema:**
    - team_id: int
    - season: int
    - week: int
    - roster: array<player_id: int>
    - timestamp: string
- **Producers:** TBD
- **Consumers:** TBD
- **Retention:** TBD
- **Partitions:** TBD

## fantasy.drafts
- **Purpose:** Basic draft information for each season.
- **Key:** league_id:season_id
- **Value schema:**
    - league_id: int
    - season_id: int
    - draft_date: string
    - seconds_per_pick: int
    - draft_pick_trading: boolean
- **Producers:** TBD
- **Consumers:** TBD
- **Retention:** TBD
- **Partitions:** TBD


# Event Data Topics

#TODO: complete fantasy.scores-weekly schema
## fantasy.scores-weekly
- **Purpose:** Team weekly fantasy scores
- **Key:** team_id:season
- **Value schema:**
    - team_id, week, season, score, opponent_id, result
- **Producers:** TBD
- **Consumers:** TBD
- **Retention:** TBD
- **Partitions:** TBD

## fantasy.standings-weekly


## fantasy.roster-events
- **Purpose:** Events where any team's roster changes (draft, add, drop, trade)
- **Key:** team_id:season
- **Value schema:**
    - team_id: int
    - season: int
    - week: int
    - player_id: int
    - event_type: string (enum: ADD, DROP, TRADE-RECEIVE, TRADE-SEND, DRAFT)
    - timestamp: string
- **Producers:** TBD
- **Consumers:** TBD
- **Retention:** TBD
- **Partitions:** TBD