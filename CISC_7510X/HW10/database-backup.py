from datetime import datetime
import psycopg2
import csv
import os

# DB Credentials
DB_NAME = "backup_test"
DB_USER_NAME = "postgres"
DB_PASSWORD = "p@ssw0rd"
DB_HOST = "localhost"
DB_PORT = "5432"

# Get working dir and timestamp and create backup dir
BACKUP_ROOT = os.getcwd()
get_current_timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
BACKUP_DIR = f"{BACKUP_ROOT}/backup_{get_current_timestamp}"
os.mkdir(BACKUP_DIR)

# Connect to PostgreSQL
connection = psycopg2.connect(
    database=DB_NAME,
    user=DB_USER_NAME,
    password=DB_PASSWORD,
    host=DB_HOST,
    port=DB_PORT
)

# Pull all tables from DB
cursor = connection.cursor()
cursor.execute("""
select tablename
from pg_catalog.pg_tables
where schemaname = 'public';
""")
db_table_names = [row[0] for row in cursor.fetchall()]
cursor.close()

# Create CSV file for each table in DB
for table in db_table_names:
    csv_path = os.path.join(BACKUP_DIR, f"{table}.csv")

    print(f"Backing up table: {table}")

    # Export to CSV 
    with open(csv_path, "w", newline='', encoding='utf-8') as csvfile:
        writer = csv.writer(csvfile)

        # Create a new cursor for each table export
        table_cursor = connection.cursor()
        table_cursor.execute(f"select * from {table}")
        col_names = [desc[0] for desc in table_cursor.description]
        writer.writerow(col_names)

        while True:
            rows = table_cursor.fetchmany(1000)
            if not rows:
                break
            for row in rows:
                writer.writerow(row)

        table_cursor.close()

connection.close()