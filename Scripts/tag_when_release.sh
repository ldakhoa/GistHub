#!/bin/sh

if [ -f GistHub.xcconfig ]; then
	export $(cat GistHub.xcconfig | grep -v '#' | awk '/=/ {print $0}')

	echo $MARKETING_VERSION

	git tag $MARKETING_VERSION
	git push origin $MARKETING_VERSION
fi