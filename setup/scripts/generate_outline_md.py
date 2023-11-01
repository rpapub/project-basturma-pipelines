"""
Outline Generator

This script reads from an input CSV file, processes its contents to generate a markdown-formatted outline, and writes 
this outline to a specified output markdown file. Additionally, the script overwrites the `id` column of the CSV 
with integer increments starting at 1.

The CSV file is expected to have the following columns:
- id: A unique identifier for each topic/entry.
- relative_tocdepth: An indicator for the topic's level in relation to the previous topic. An empty value indicates 
  a new part. The special value "p" denotes a paragraph.
- topic: The title or name of the topic.
- dependency: Additional data column (not utilized in the current logic of this script).

The script uses the following levels for topics:
['part', 'chapter', 'Section', 'Subsection', 'Sub-subsection', 'paragraph']

For every topic, the script determines its depth in the outline based on the relative_tocdepth, adjusts counters 
for each level, and then constructs a markdown heading with appropriate depth and numbering. This heading is 
appended to the output list.

Finally, the script writes back the modified rows with updated IDs to the CSV file and writes the generated outline 
to a markdown file.

Usage:
    To execute the script, simply run it in a Python environment. Ensure the CSV file is present at the path 
    specified in `input_path`.

Attributes:
    input_path (str): Path to the input CSV file.
    output_path (str): Path where the output markdown file will be saved.
    levels (list): A list of strings specifying the names of each depth level in the outline.

Author: Christian Prior-Mamulyan (cprior@gmail.com)
Repository Location: https://github.com/rpapub/project-basturma-pipelines
LICENSE: CC-BY
"""

import csv
from datetime import datetime

# Define file paths
input_path = "docs/_data/outline.csv"
output_path = "docs/outline.md"

levels = ['part', 'chapter', 'Section', 'Subsection', 'Sub-subsection', 'paragraph']

# Start with the Jekyll frontmatter
output = [
    "---",
    "title: \"Outline\"",
    "---",
    ""
]

# Read the CSV data
with open(input_path, 'r') as file:
    reader = csv.DictReader(file)
    entries = [dict(row) for row in reader]

# Overwrite the id column
for i, entry in enumerate(entries):
    entry['id'] = i + 1

# Write the modified CSV back
with open(input_path, 'w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=entries[0].keys())
    writer.writeheader()
    writer.writerows(entries)

# Define initial counters and current depth
counters = [0] * (len(levels) - 1)  # excluding 'paragraph' for counting
current_depth = -1

for entry in entries:
    if entry['relative_tocdepth'] == '':
        current_depth = 0
        delta = 0
    elif entry['relative_tocdepth'] == 'p':
        output.append(entry['topic'] + "\n")
        continue
    else:
        delta = int(entry['relative_tocdepth'])
        current_depth += delta

    # Increment current depth counter
    counters[current_depth] += 1

    # For jumps of more than one level, set intermediate counters to 0
    for i in range(1, delta):
        counters[current_depth - i] = 0

    # Reset all subsequent counters if we move up a level or more
    for i in range(current_depth + 1, len(counters)):
        counters[i] = 0

    # Modify numbering list for depth jumps greater than 1
    if delta > 1:
        for i in range(1, delta):
            counters[current_depth - i] = 0

    # Generate the numbering for the current level
    numbering = ".".join([str(c) for c in counters[:current_depth+1]])

    # Generate the markdown string for the current entry
    md_string = "#"* (current_depth + 1) + " " + numbering + " " + entry['topic'] + " - " + levels[current_depth]
    output.append(md_string)

# Write the output to a file
with open(output_path, 'w') as file:
    file.write("\n".join(output))

current_time = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
print(f"{current_time} | Outline generated and saved to {output_path}")
