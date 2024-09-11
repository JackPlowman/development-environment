# Fix the format so we can use it
MODIFIED_DATE=$(echo $AWS_SESSION_EXPIRATION | sed 's/:00/00/')
# ISO 8601 date format
EXPIRATION_EPOCH=$(date -j -f "%Y-%m-%dT%H:%M:%S%z" $MODIFIED_DATE +"%s")
echo $EXPIRATION_EPOCH
