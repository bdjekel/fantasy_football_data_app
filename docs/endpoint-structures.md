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
- The below parameters were explored during the 2025 season of a private league on the currently playing season. Separate data will be shown for historical seasons.
- param options
    - None - gameId*, id* (league id), members array, scoringPeriodId*, seasonId*, segmentId*, settings object ("name" key only), status object, teams array
        ```json
        "members array object structure":
        {
            "displayName": "marcus5670676",
            "id": "{165F7F4E-901E-4030-973C-4B1A2AE291AB}",
            "isLeagueManager": false
        },
        "status object structure":
        {
            "currentMatchupPeriod": 5,
            "isActive": true,
            "latestScoringPeriod": 5
        },
        "teams array object structure":
        {
            "abbrev": "BDJ",
            "id": 1,
            "owners": [
                "{59410FBF-10B5-482A-810F-BF10B5D82A88}"
            ]
        },
        ```
    - mStandings - draftDetail object, schedule array, status object, 
        ```json
        "schedule array object structure":
        {
            "away": {
                "gamesPlayed": 0,
                "teamId": 2,
                "totalPoints": 109.42
            },
            "home": {
                "gamesPlayed": 0,
                "teamId": 13,
                "totalPoints": 110.42
            },
            "matchupPeriodId": 1
        },
        "status object structure": 
        {
            "activatedDate": 1755208263509,
            "createdAsLeagueType": 0,
            "currentLeagueType": 0,
            "currentMatchupPeriod": 5,
            "finalScoringPeriod": 17,
            "firstScoringPeriod": 1,
            "isActive": true,
            "isExpired": false,
            "isFull": true,
            "isPlayoffMatchupEdited": false,
            "isToBeDeleted": false,
            "isViewable": false,
            "isWaiverOrderEdited": false,
            "latestScoringPeriod": 5,
            "previousSeasons": [
                2016,
                2017,
                2018,
                2019,
                2020,
                2021,
                2022,
                2023,
                2024
            ],
            "standingsUpdateDate": 1759391550201,
            "teamsJoined": 12,
            "transactionScoringPeriod": 5,
            "waiverLastExecutionDate": 1759391549121,
            "waiverProcessStatus": {
                "2025-09-04T07:00:57.338+00:00": 1,
                "2025-09-10T07:22:39.927+00:00": 6,
                "2025-09-17T08:08:38.471+00:00": 5,
                "2025-09-19T07:27:39.291+00:00": 1,
                "2025-09-24T07:52:42.141+00:00": 3,
                "2025-09-26T07:51:56.100+00:00": 1,
                "2025-10-01T07:01:09.399+00:00": 11,
                "2025-10-02T07:52:29.121+00:00": 1
            }
        },
        "teams array object structure":
        {
            "currentSimulationResults": {
                "divisionWinPct": 0.161,
                "modeRecord": {
                    "gamesBack": 0.0,
                    "losses": 7,
                    "percentage": 0.0,
                    "pointsAgainst": 0.0,
                    "pointsFor": 0.0,
                    "streakLength": 0,
                    "streakType": "NONE",
                    "ties": 0,
                    "wins": 7
                },
                "playoffClinchType": "UNKNOWN",
                "playoffPct": 0.5555,
                "rank": 6
            },
            "id": 1,
            "playoffClinchType": "UNKNOWN"
        },
        ```
    - mSettings
    - modular - Includes draftDetail object, 
    - mTeam - Includes draftDetail object, members array, status object, teams array


- ?view=mTeam - Team rosters
- ?view=mMatchup - Matchups/scores
- ?view=mDraftDetail - Draft results
- ?view=mSettings - League settings
- ?view=kona_player_info - Player stats