#!/usr/bin/env bash

# Let the commands break the script
set -e

# Get the source directory of this script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define other variables
LYTEDEV_HUGO_DIR="$HOME/sites/lytedev"

# Go!
echo "Moving to directory $LYTEDEV_HUGO_DIR"
pushd "$LYTEDEV_HUGO_DIR"
git pull origin source
yarn
pushd "themes/lytedev"
echo "Moving to directory $PWD/themes/lytedev"
git pull origin master
yarn
popd
yarn run build-all
