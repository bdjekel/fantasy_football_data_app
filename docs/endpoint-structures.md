# ESPN

## Fantasy

### Composition Breakdown

> Arrays and objects listed don't always contain the same information (e.g., mLiveScoring and mMatchupScore have same top-level structure, but differing nested data). For full structure of payloads for each view, see .json files located in espn-api-responses/

Full Request URL example: https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/seasons/2025/segments/0/leagues/110304?rosterForTeamId=1&view=mDraftDetail&view=mLiveScoring&view=mMatchupScore&view=mPendingTransactions&view=mPositionalRatings&view=mRoster&view=mSettings&view=mTeam&view=modular&view=mNav

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

#### Your specific team ID (Not shown in the example above)
    - /teams/[team_id]

#### Query Parameters
> The below parameters were explored during the 2025 season of a private league on the currently playing season. Separate data will be shown for historical seasons.
- params
    - `forTeamId=[TeamId]`
    - `rosterForTeamId=[TeamId]`
        - Note: TeamId can be usually found in the teams array, and is connnected to the owner(s) SWID(s).
    - `scoringPeriodId=[WeekNumber]`
- param "view" options (*included in every payload. Only mentioned on None)
    - `view=[mViewParam]`
    - None - gameId*, id* (league id), members array, scoringPeriodId*, seasonId*, segmentId*, settings object ("name" key only), status object, teams array
    - modular - draftDetail object, status object
    - mDraftDetail - draftDetail object (very detailed), settings object, status object
    - kona_player_info - players array (of every player in ESPN fantasy?), positionAgainstOpponent object
    - mLiveScoring - draftDetail object, schedule array, status object
    - mMatchupScore - draftDetail object, schedule array, status object
    - mNav - draftDetail object, members array, settings object, status object, teams object
    - mPendingTransactions - draftDetail object, status object
    - mPositionalRatings - draftDetail object, positionAgainstOpponent object, status object
    - mRoster - draftDetail object, status object, teams array (includes NFL player details)
    - mRosterRecommends - draftDetail object, status object, teams array
    - mScoreboard - draftDetail object, (no gameId), settings object, status object, teams array
    - mSettings - draftDetail object, settings object { acquisitionSettings object, draftSettings object, finance setting object, isAutoReactivate, isCustomizable, isPublic, name, restriction type, rosterSettings object, scheduleSettings object, scoringSettings object, size, tradeSettings object }, status object
    - mStandings - draftDetail object, schedule array, status object 
    - mStatus - draftDetail object, status object
    - mTeam - draftDetail object, members array, status object, teams array
    - mTopPerformers - schedule array (massive array with alot of empty away/home objects at top.)



    #### Unexplored Options
    - https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/seasons/2024/players
    - https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/seasons/2025?view=kona_game_state
    - 