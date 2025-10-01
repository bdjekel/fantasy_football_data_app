# ESPN

## Fantasy

### Composition Breakdown

#### Base domain for ESPN's fantasy API
- https://lm-api-reads.fantasy.espn.com
    - lm = League Manager
    - api-reads = Read-only endpoint (vs writes for roster changes)

#### Version
- /apis/v3

#### Games = Fantasy games category
- /games/ffl
    - ffl = Fantasy Football (would be fba for basketball, fho for hockey)

#### Season - The fantasy season year
- /seasons/[4-digit season year]


#### Season segment (always 0 for regular season)
- /segments/0
    - ESPN's internal grouping (you'll always use 0)

#### Your specific league ID
    - /leagues/[league_id]
        - league_id is unique to your league

#### Query Parameters
- ?view=mTeam - Team rosters
- ?view=mMatchup - Matchups/scores
- ?view=mDraftDetail - Draft results
- ?view=mSettings - League settings
- ?view=kona_player_info - Player stats