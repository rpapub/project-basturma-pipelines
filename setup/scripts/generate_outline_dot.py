import csv

input_path = 'docs/_data/outline.csv'
output_path = 'docs/outline.dot'

# Read the CSV data
with open(input_path, 'r') as f:
    reader = csv.DictReader(f)
    data = list(reader)

# Begin writing the DOT file
with open(output_path, 'w') as f:
    f.write('digraph Outline {\n')
    f.write('rankdir=TB;\n')  # Top to bottom layout
    f.write('node [shape=box];\n')  # Set the default node shape

    # Create nodes for each topic
    for row in data:
        f.write(f'"{row["id"]}" [label="{row["topic"]}"];\n')

    # Create edges based on the relative_tocdepth
    previous_row = None
    for row in data:
        if row['relative_tocdepth']:  # Check if not empty
            if previous_row and int(row['relative_tocdepth']) > 0:
                f.write(f'"{previous_row["id"]}" -> "{row["id"]}";\n')
        previous_row = row

    f.write('}\n')

print(f'Graphviz DOT file generated at {output_path}')
