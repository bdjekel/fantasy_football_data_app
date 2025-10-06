# src/etl/load_historical.py
import json
import os

import psycopg2
from dotenv import load_dotenv
from historical_extractors import extract_managers
from historical_loaders import insert_managers

load_dotenv()


def load_league_history(json_file_path):
    """Load historical league data from JSON file into database."""

    # Load JSON
    print(f"Loading {json_file_path}...")
    with open(json_file_path) as f:
        data = json.load(f)

    espn_data = data[0]  # ESPN returns array

    # Connect to database
    conn = psycopg2.connect(os.getenv("DEV_DATABASE_URL"))
    cursor = conn.cursor()

    try:
        # Stage 1: Independent entities
        print("\n=== Stage 1: Loading managers ===")

        managers = extract_managers(espn_data)
        manager_id_map = insert_managers(cursor, managers)  # noqa: F841

        # Commit stage 1
        conn.commit()
        print("✓ Stage 1 complete")

        # Stage 2: Dependent entities (manager_seasons, etc.)
        # Add later...

    except Exception as e:
        conn.rollback()
        print(f"✗ Error: {e}")
        raise
    finally:
        cursor.close()
        conn.close()


if __name__ == "__main__":
    load_league_history("docs/espn-api-responses/_league_history_2016.json")
