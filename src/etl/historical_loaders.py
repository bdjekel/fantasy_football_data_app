# src/etl/loaders.py


def insert_managers(cursor, managers):
    """
    Insert managers into database and return mapping of espn_member_id to manager_id.

    Args:
        cursor: psycopg2 cursor
        managers: List of manager dicts from extract_managers()

    Returns:
        Dict mapping espn_member_id to database manager_id
    """
    espn_id_to_manager_id = {}

    for manager in managers:
        cursor.execute(
            """
            INSERT INTO managers (espn_member_id, display_name, first_name, last_name)
            VALUES (%(espn_member_id)s, %(display_name)s, %(first_name)s, %(last_name)s)
            ON CONFLICT (espn_member_id) DO NOTHING
            RETURNING manager_id
        """,
            manager,
        )

        # Get the inserted manager_id (or fetch if already exists)
        result = cursor.fetchone()
        if result:
            manager_id = result[0]
        else:
            # Already existed, fetch it
            cursor.execute(
                "SELECT manager_id FROM managers WHERE espn_member_id = %s",
                (manager["espn_member_id"],),
            )
            manager_id = cursor.fetchone()[0]

        espn_id_to_manager_id[manager["espn_member_id"]] = manager_id
        print(f"Inserted/found manager: {manager['display_name']} (ID: {manager_id})")

    return espn_id_to_manager_id
