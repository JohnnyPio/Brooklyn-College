#John Piotrowski - 7510X - HW10

from datetime import datetime
import psycopg2
import csv
import os
import gzip
import gnupg

# DB Credentials
DB_NAME = "backup_test"
DB_USER_NAME = "postgres"
DB_PASSWORD = "p@ssw0rd"
DB_HOST = "localhost"
DB_PORT = "5432"
PUBLIC_KEY_ID = "0807C0437F8BC2DEE32FC3F12473D1C12D7A029B"

# Get working dir and timestamp and create a backup directory
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

# Get all tables from DB
cursor = connection.cursor()
cursor.execute("""
select tablename
from pg_catalog.pg_tables
where schemaname = 'public';
""")
db_table_names = [row[0] for row in cursor.fetchall()]
cursor.close()

# Encryption
# gpg = gnupg.GPG()
gpg = gnupg.GPG(gpgbinary='C:\\Program Files (x86)\\GnuPG\\bin\\gpg.exe')

# Create a CSV file for each table in DB
for table in db_table_names:
    csv_gz_path = os.path.join(BACKUP_DIR, f"{table}.csv.gz")
    gpg_path = csv_gz_path + ".gpg"

    print(f"Backing up table: {table}")

    # Export to gzipped CSV
    # If too slow, change default parameter 'compresslevel=9' to 'compresslevel=6' in gzip.open()
    with gzip.open(csv_gz_path, "wt", newline='', encoding='utf-8') as csv_gz_file:
        csv_writer = csv.writer(csv_gz_file)

        # Create a new cursor for each table export
        table_cursor = connection.cursor()
        table_cursor.execute(f"select * from {table}")
        col_names = [desc[0] for desc in table_cursor.description]
        csv_writer.writerow(col_names)

        while True:
            rows = table_cursor.fetchmany(1000)
            if not rows:
                break
            for row in rows:
                csv_writer.writerow(row)

        print(f"csv.gz data written to {csv_gz_path} successfully.")
        table_cursor.close()

    # Encrypt CSV
    with open(csv_gz_path, 'rb') as encrypted_file:
        status = gpg.encrypt_file(
            encrypted_file, recipients=PUBLIC_KEY_ID, output=gpg_path
        )
        if not status.ok:
            raise RuntimeError(f"Encryption failed: {status.status}")
        print(f"Encryption for {csv_gz_path} completed successfully.")

    # Cleanup unencrypted CSV
    os.remove(csv_gz_path)
    print(f"Unencrypted {csv_gz_path} deleted successfully.")

connection.close()