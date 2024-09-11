#!/bin/bash

# Fix the format so we can use it
MODIFIED_DATE="${AWS_SESSION_EXPIRATION/:00/00}"

# ISO 8601 date format
EXPIRATION_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" "${MODIFIED_DATE}" +"%s")

# Get the current epoch time
CURRENT_EPOCH=$(date +%s)

# Check if the current epoch is greater than the expiration epoch
COMPARISON=$((CURRENT_EPOCH > EXPIRATION_EPOCH))

# If the comparison is true, then the session is expired
if [ $COMPARISON -eq 1 ]; then
  echo "AWS session has expired."
  exit 1
fi

# Calculate the difference between the current epoch and the expiration epoch
DIFFERENCE=$((EXPIRATION_EPOCH - CURRENT_EPOCH))
# If the difference is less than 15 minutes, then the session should be refreshed first
if [ $DIFFERENCE -lt 900 ]; then
  echo "AWS session has less than 15 minutes remaining. Refresh Session."
  exit 2
fi
