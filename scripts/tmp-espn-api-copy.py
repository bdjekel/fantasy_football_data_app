# type: ignore

import json
import os
import random

import requests
from dotenv import load_dotenv

load_dotenv()

url = "https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl/seasons/2017/segments/0/leagues/110304"

params = {
    # "view": "mSettings",
    # "view": "mDraftDetail",
    # "view": "mRoster",
    # "view": "mStandings",
    # "view": "mTeam",
}

cookies = {
    "SWID": os.getenv("BDJ_ESPN_SWID"),
    "espn_s2": os.getenv("BDJ_ESPN_S2"),
}

response = requests.get(url, params=params, cookies=cookies)
# response_id = params["view"]
file_name = f"docs/espn-api-responses/__espn_2017_league_info.json"

data = response.json()



# Save to file
with open(file_name, "w") as f:
    json.dump(data, f, indent=2)

print(f"Saved to {file_name}")