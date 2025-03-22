#!/bin/bash
last_chosen_model=$(cat .last_chosen_model)
current_line=$(grep -n "$last_chosen_model" .all_models | cut -d':' -f1)
total_lines=$(wc -l < .all_models)

echo $last_chosen_model
echo $current_line

if [[ $current_line -eq $total_lines ]]; then
  next_line=1
  echo "next: $next_line"
else
  next_line=$((current_line + 1))
  echo "next: $next_line"
fi

next_model=$(sed -n "${next_line}p" .all_models)
echo "next: $next_model"
echo "$next_model" > .last_chosen_model
cat .last_chosen_model
