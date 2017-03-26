#!/usr/bin/env bash

# Let the commands break the script
set -e

# Get the source directory of this script
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define the proper directory in ../env_scripts/dirs.bash
source "$DIR/../env_scripts/dirs.bash"
if [ -z "$LYTEDEV_HUGO_DIR" ]; then
	echo "\$LYTEDEV_HUGO_DIR is not set. Does $DIR/../env_scripts/dirs.bash exist?"
	exit 1
fi

pushd "$LYTEDEV_HUGO_DIR"
git pull
yarn
pushd "themes/lytedev"
git pull
yarn
popd
yarn run build-all
