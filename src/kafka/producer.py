# type: ignore
# TODO: Fix type hints to make ruff / mypy happy

import json
import os

import requests
from dotenv import load_dotenv
from kafka import KafkaProducer

load_dotenv()


class ESPNProducer:
    def __init__(self, league_id: int, year: int):
        self.league_id = league_id
        self.year = year
        self.base_url = "https://lm-api-reads.fantasy.espn.com/apis/v3/games/ffl"
        self.league_endpoint = (
            f"{self.base_url}/seasons/{year}/segments/0/leagues/{league_id}"
        )

        # Kafka producer
        self.producer = KafkaProducer(
            bootstrap_servers="localhost:9092",
            value_serializer=lambda v: json.dumps(v).encode("utf-8"),
        )

        # ESPN authentication
        self.cookies = {
            "SWID": os.getenv("BDJ_ESPN_SWID"),
            "espn_s2": os.getenv("BDJ_ESPN_S2"),
        }

    # TODO: Modify any type hint to be more specific
    def _make_request(self, params: dict[str, any]) -> dict[str, any]:
        # Make authenticated request to ESPN API
        response = requests.get(
            self.league_endpoint, params=params, cookies=self.cookies
        )

        if response.status_code == 401:
            raise Exception("Authentication failed. Check ESPN_S2 and SWID.")
        elif response.status_code == 404:
            raise Exception(f"League {self.league_id} not found.")
        elif response.status_code != 200:
            raise Exception(f"Request failed with status {response.status_code}")

        return response.json()

    def fetch_league_info(self) -> dict[str, any]:
        # Fetch basic league information
        params = {"view": ["mSettings", "mStandings"]}
        data = self._make_request(params)
        self.producer.send("fantasy.leagues", value=data)
        print("✅ Sent league info to fantasy.leagues")
        return data

    def fetch_teams_and_rosters(self) -> dict[str, any]:
        # Fetch team and roster data
        params = {"view": ["mTeam", "mRoster"]}
        data = self._make_request(params)
        self.producer.send("fantasy.rosters", value=data)
        print("✅ Sent rosters to fantasy.rosters")
        return data

    def fetch_all(self) -> None:
        # Fetch all data from all endpoints
        print(f"Fetching all data for league {self.league_id}, year {self.year}")
        self.fetch_league_info()
        self.fetch_teams_and_rosters()
        self.producer.flush()
        print("✅ All data sent to Kafka")

    def close(self):
        # Close producer connection
        self.producer.close()


if __name__ == "__main__":
    # Test the producer
    producer = ESPNProducer(league_id=110304, year=2025)
    producer.fetch_all()
    producer.close()
