# Fix the format so we can use it
MODIFIED_DATE=$(echo $AWS_SESSION_EXPIRATION | sed 's/:00/00/')
# ISO 8601 date format
EXPIRATION_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" $MODIFIED_DATE +"%s")
# Get the current epoch time
CURRENT_EPOCH=$(date +%s)
# Check if the current epoch is greater than the expiration epoch
COMPARISON=$((CURRENT_EPOCH > EXPIRATION_EPOCH))
# If the comparison is true, then the session is expired
if [ $COMPARISON -eq 1 ]; then
  echo "AWS session has expired."
  exit 1
fi
DIFFERENCE=$((EXPIRATION_EPOCH - CURRENT_EPOCH))
# If the difference is less than 1 minutes, then the session should be refreshed first
if [ $DIFFERENCE -lt 60 ]; then
  echo "AWS session has less than 1 minute remaining. Refresh Session."
  exit 2
fi
