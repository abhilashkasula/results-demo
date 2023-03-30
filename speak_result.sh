#! /bin/bash

RESULTS=$(curl -s https://abhilashkasula.github.io/results-demo/results.json)

PIN=$1

STUDENT=$(echo $RESULTS | jq ". | .sem_1[] | select(.pin==\"$PIN\")")

if [[ -z $STUDENT ]]; then 
  say No record found!
  exit 0 
fi

NAME=$(echo $STUDENT | jq '.name')
MARKS=$(echo $STUDENT | jq '.marks')

IS_PASSED=true
TOTAL=0

for SUBJECT in $(echo $MARKS | jq -c '.[]')
do
  STATUS=$(echo $SUBJECT | jq '.is_passed')
  EXTERNAL_MARKS=$(echo $SUBJECT | jq '.external')
  INTERNAL_MARKS=$(echo $SUBJECT | jq '.internal')

  TOTAL=$((TOTAL + EXTERNAL_MARKS + INTERNAL_MARKS))

  if [[ $STATUS != "true" ]]; then
    IS_PASSED=false
  fi
done

if $IS_PASSED; then
  MSG="$NAME is passed with $TOTAL marks"
else
  MSG="$NAME is failed with $TOTAL marks"
fi

echo $MSG
say $MSG
