#!/bin/sh

echo "Stage: PRE-Xcode Build is activated ..."

export $(cat .env | grep -v '#' | awk '/=/ {print $0} {print $1}' )

cd GistHub/Resources

plutil -replace GITHUBID -string $GITHUBID Info.plist
plutil -replace GITHUBSECRET -string $GITHUBSECRET Info.plist

echo "Stage: PRE-Xcode Build is DONE ..."

exit 0