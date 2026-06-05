#!/usr/bin/env zsh

DEEKSHA_NAME="Deeksha Dakshnamurthy"
DEEKSHA_EMAIL="deeksha.dakshna@gmail.com"
SID_NAME="Sidharthan Chandrasekaran Kamaraj"
SID_EMAIL="csidharthank@gmail.com"

current_email=$(git config --global user.email)

if [[ "$current_email" == "$SID_EMAIL" ]]; then
  git config --global user.name "$DEEKSHA_NAME"
  git config --global user.email "$DEEKSHA_EMAIL"
  echo "Switched to: $DEEKSHA_NAME <$DEEKSHA_EMAIL>"
else
  git config --global user.name "$SID_NAME"
  git config --global user.email "$SID_EMAIL"
  echo "Switched to: $SID_NAME <$SID_EMAIL>"
fi
