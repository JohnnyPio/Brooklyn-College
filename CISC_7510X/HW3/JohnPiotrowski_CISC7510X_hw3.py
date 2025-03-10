import csv
import os
from pathlib import Path

def main():
    user_input_file1 = input("What is the full path of the first CSV file would you like to join?\n")
    user_input_file2 = input("What is the full path of the second CSV file would you like to join?\n")
    join_method = input(
        "Which join method would you like to use? (-m for merge join, -n for nested loop join, -h for hash join)\n")

    joined_csv_data = None

    if join_method == "-m":
        joined_csv_data = merge_join(user_input_file1, user_input_file2)
    elif join_method == "-n":
        joined_csv_data = nested_loop_join(user_input_file1, user_input_file2)
    elif join_method == "-h":
        joined_csv_data = hash_join(user_input_file1, user_input_file2)
    else:
        print("Invalid join method. Please try again.")

    user_input_write_to_csv = input("Do you want to write the results to a CSV file? (-y for yes or -n for no)\n")

    if user_input_write_to_csv == "-y":
        user_input_write_file = input("What is the name of the CSV file you want to write?\n")
        write_to_csv(joined_csv_data, user_input_write_file)

    return

def merge_join(csv1, csv2):
    # Assuming no responsibility in merge_join for many-to-many matches and worktables
    filedata1 = read_csv_as_list(csv1)
    filedata2 = read_csv_as_list(csv2)

    # Assuming first row is headers, we want to remove them
    headers1 = filedata1.pop(0)
    headers2 = filedata2.pop(0)

    # Initialize result and add header rows to result
    result = [headers1 + headers2]

    # Sort both lists. I assume the first column is the join key and it's an ID so ascending list.sort() works.
    filedata1.sort()
    filedata2.sort()

    # Initialize row iterators
    file1_row_it = 0
    file2_row_it = 0

    while file1_row_it < len(filedata1) and file2_row_it < len(filedata2):
        key1 = filedata1[file1_row_it][0]
        key2 = filedata2[file2_row_it][0]

        if key1 == key2:
            result.append(filedata1[file1_row_it] + filedata2[file2_row_it])
            file2_row_it += 1
        elif key1 < key2:
            file1_row_it += 1
        else:
            file2_row_it += 1

    return result

def read_csv_as_list(filename):
    with open(filename, 'r') as file:
        reader = csv.reader(file)
        return list(reader)

def nested_loop_join(csv1, csv2):
    filedata1 = read_csv_as_list(csv1)
    filedata2 = read_csv_as_list(csv2)

    # Assuming first row is headers, we want to remove them
    headers1 = filedata1.pop(0)
    headers2 = filedata2.pop(0)

    # Initialize result and add header rows to result
    result = [headers1 + headers2]

    # Could add (but didn't) as a potential optimizer for large files: https://youtu.be/0arjvMJihJo?si=_poy6ODgEHiXa88y
    # filedata1.sort()
    # filedata2.sort()

    # Initialize file 1 row iterators
    file1_row_it = 0

    for filedata1[file1_row_it] in filedata1:
        key1 = filedata1[file1_row_it][0]

        # Initialize file 2 row iterators
        file2_row_it = 0

        for filedata2[file2_row_it] in filedata2:
            key2 = filedata2[file2_row_it][0]

            if key1 == key2:
                result.append(filedata1[file1_row_it] + filedata2[file2_row_it])

            file2_row_it += 1

        file1_row_it += 1

    return result

def hash_join(csv1, csv2):
    filedata1 = read_csv_as_list(csv1)
    filedata2 = read_csv_as_list(csv2)

    size_csv1 = get_csv_size_in_bytes(csv1)
    size_csv2 = get_csv_size_in_bytes(csv2)

    # Set build_input to be smaller file
    if size_csv1 <= size_csv2:
        build_input = filedata1
        probe_input = filedata2
    else:
        build_input = filedata2
        probe_input = filedata1

    # Assuming first row is headers, we want to remove them
    headers_build = build_input.pop(0)
    headers_probe = probe_input.pop(0)

    # Initialize result and add header rows to result
    result = [headers_build + headers_probe]

    # Work with smaller dataset first, using dictionary for quicker lookup
    hash_table = {}
    for build_row in build_input:
        key = build_row[0]

        # If key match, add it to a "bucket"
        if key in hash_table:
            hash_table[key].append(build_row)
        else:
            hash_table[key] = [build_row]

    # Look up matches from larger dataset
    for probe_row in probe_input:
        key = probe_row[0]
        if key in hash_table:
            for matched_row in hash_table[key]:
                result.append(matched_row + probe_row)

    return result

def get_csv_size_in_bytes(csv_path):
    return Path(csv_path).stat().st_size

def write_to_csv(data, filename):
    if not (filename.endswith(".csv")):
        filename += ".csv"
    with open(filename, 'w', newline='') as file:
        writer = csv.writer(file)
        writer.writerows(data)
    print(f"Results successfully written to {os.path.abspath(filename)}!")

main()
