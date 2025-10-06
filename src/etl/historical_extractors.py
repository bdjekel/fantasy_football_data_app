# src/etl/extractors.py
"""
Extract and transform ESPN league history JSON into database-ready dictionaries.
"""


def extract_managers(espn_data):
    managers = []
    if "members" in espn_data:
        for member in espn_data.get("members", {}):
            display_name = member.get("displayName")
            first_name = member.get("firstName")
            last_name = member.get("lastName")
            espn_member_id = member.get("id")

            managers.append(
                {
                    "espn_member_id": espn_member_id,
                    "display_name": display_name,
                    "first_name": first_name,
                    "last_name": last_name,
                }
            )

    return managers
