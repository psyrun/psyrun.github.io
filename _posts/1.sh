#!/bin/bash

# Find all .md files in the current directory and its subdirectories
find . -type f -name "*.md" | while read -r file; do
  # Append 'author:@psy' to the end of each .md file
  echo "@spotheplanet" >> "$file"
  echo "Appended author:@spotheplanet $file"
done

echo "All .md files have been updated."

