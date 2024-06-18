#!/bin/bash

# Directory containing the .md files
directory="."

# Styles for hint replacement
hint_start='```'
hint_end='```'

# Find all .md files in the specified directory
find "$directory" -maxdepth 1 -type f -name "*.md" | while read -r file; do
  # Read the file content
  content=$(cat "$file")

  # Replace hint tags with appropriate box
  updated_content=$(echo "$content" | sed -E "s/\{% hint style=\"[^\"]*\" %\}/${hint_start}/g" | sed -E "s/\{% endhint %\}/${hint_end}/g")

  # Write the updated content back to the file
  echo "$updated_content" > "$file"

  echo "Processed $file"
done

echo "All .md files have been processed."
