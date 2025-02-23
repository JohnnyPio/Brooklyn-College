import csv

# @TODO figure this out once I have all the functions
def main():

    return

def read_csv_as_list(filename):
    # Not sure if I need the encoding, but I'm getting weird character from Excel CSVs. See:
    # https://stackoverflow.com/questions/34399172/why-does-my-python-code-print-the-extra-characters-%C3%AF-when-reading-from-a-tex
    with open(filename, encoding='utf-8-sig') as file:
        reader = csv.reader(file)
        return list(reader)

def merge_join(csv1, csv2):
    filedata1 = read_csv_as_list(csv1)
    filedata2 = read_csv_as_list(csv2)

    # Assuming first row is headers, we want to remove them
    headers1 = filedata1.pop(0)
    headers2 = filedata2.pop(0)

    # Initialize result and add header rows to result
    result = [headers1 + headers2]

    # Sort both lists. I assume the first column is the join key and it's an ID so ascending list.sort() works
    filedata1.sort()
    filedata2.sort()

    # Initialize row iterators
    file1_row_it, file2_row_it = 0, 0

    while file1_row_it < len(filedata1) and file2_row_it < len(filedata2):
        key1 = filedata1[file1_row_it][0]
        key2 = filedata2[file2_row_it][0]

        if key1 == key2:
            result.append(filedata1[file1_row_it] + filedata2[file2_row_it])
            file2_row_it += 1  # Move down a row in file2
        elif key1 < key2:
            file1_row_it += 1  # Move down a row in file1
        else:
            file2_row_it += 1  # Move down a row in file2

    return result

file1 = 'C:/Users/JohnS/OneDrive/Documents/Local repos/Brooklyn-College/CISC 7510X/HW3/file1.csv'
file2 = 'C:/Users/JohnS/OneDrive/Documents/Local repos/Brooklyn-College/CISC 7510X/HW3/file2.csv'

merged = merge_join(file1, file2)
print(merged)
