#!/usr/bin/env bash
set -euo pipefail

tickets=$(jira issue list -a$(jira me) -s"In Progress" -t~Epic  --raw | jq -r '.[] | "\(.key) - \(.fields.status.name) - \(.fields.summary)"')

if [[ -z "$tickets" ]]; then
  echo "No in-progress tickets found."
  exit 0
fi

echo "Select a ticket to create a branch:"
i=1
declare -a ticket_map
while read -r line; do
  # Extract the ticket ID (assuming format ABC-123 Summary)
  ticket_id=$(echo "$line" | awk '{print $1}')
  ticket_map[$i]=$ticket_id
  echo "[$i] $line"
  ((i++))
done <<< "$tickets"

read -p "Enter number: " selection

if [[ -z "${ticket_map[$selection]}" ]]; then
  echo "Invalid selection."
  exit 1
fi

echo $ticket_id | pbcopy

echo "$ticket_id coppied to clipbaord."
