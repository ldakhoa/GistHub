#!/bin/bash

echo "Resolving all packages..."

# Get the script's own directory
script_dir=$(dirname $0)

# Navigate to the 'Scripts' directory and then go up one level to get to the source root
cd "$script_dir/.."
source_root=$(pwd)
packages_dir="$source_root/Packages"

# Start in the packages directory
cd "$packages_dir"

GREEN='\033[0;32m' # Green
NC='\033[0m'       # No Color

for item in */; do
	# Check if the item is a directory
	if [[ -d "$item" ]]; then
		# Remove trailing slashes to get the directory name only
		dir_name=${item%%/}
		# Enter the directory and resolve the package
		cd "$item"
		printf "${GREEN}Resolving $dir_name...${NC}\n"
		swift package resolve
		cd ..
	fi
done

echo "✅ Done"
