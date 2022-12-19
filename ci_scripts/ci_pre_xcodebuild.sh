#!/bin/sh

echo "Stage: PRE-Xcode Build is activated ..."

cd ..

cd GistHub/Resources

plutil -replace GITHUBID -string $GITHUBID Info.plist
plutil -replace GITHUBSECRET -string $GITHUBSECRET Info.plist

plutil -p Info.plist

echo "Stage: PRE-Xcode Build is DONE ..."

exit 0
