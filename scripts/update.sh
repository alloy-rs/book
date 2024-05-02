#!/usr/bin/env bash

# Exit if anything fails
set -eo pipefail

# Change directory to project root
SCRIPT_PATH="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_PATH/.." || exit

# Utilities
GREEN="\033[00;32m"

function log () {
  echo -e "$1"
  echo "################################################################################"
  echo "#### $2 "
  echo "################################################################################"
  echo -e "\033[0m"
}

# This script will do the following:
#
# 1. Update the submodules.
# 2. Generate markdown files for each example in the `lib/examples` repository
# and store them in the `src/examples` directory. The markdown files will contain
# the example code and instructions on how to run the example.
# 3. Print any differences between the current and updated example files list.
function main () {
  log $GREEN "Updating..."

  # Update submodules
  git submodule update --init --recursive

  # Get the commit hash of the latest commit in the examples repository
  EXAMPLES_COMMIT_HASH=$(git -C ./lib/examples rev-parse HEAD)

  # Store the current example files list for comparison
  CURRENT_EXAMPLE_FILES=$(find ./src/examples -type f)

  # Clean up existing examples
  echo "Cleaning up existing examples"
  rm -rf ./src/examples/*

  # Create example markdown files
  for EXAMPLE_DIRPATH in ./lib/examples/examples/*/; do
    EXAMPLE_DIRNAME=$(basename $EXAMPLE_DIRPATH)
    BOOK_DIRNAME="./src/examples/$EXAMPLE_DIRNAME"

    mkdir $BOOK_DIRNAME

    for EXAMPLE_FILEPATH in $EXAMPLE_DIRPATH/examples/*.rs; do
      REFERENCE_FILEPATH="../../../lib/examples/examples/$EXAMPLE_DIRNAME/examples/$(basename $EXAMPLE_FILEPATH)"
      EXAMPLE_FILENAME=$(basename $EXAMPLE_FILEPATH .rs)
      BOOK_FILEPATH="./src/examples/$EXAMPLE_DIRNAME/$EXAMPLE_FILENAME.md"

      echo "Creating $BOOK_FILEPATH"

cat << EOF > "$BOOK_FILEPATH"
<!-- DO NOT EDIT THIS FILE. IT IS GENERATED BY RUNNING \`./scripts/update.sh\` -->
<!-- ANY CHANGES MADE TO THIS FILE WILL BE OVERWRITTEN -->
<!-- LATEST UPDATE: https://github.com/alloy-rs/examples/tree/$EXAMPLES_COMMIT_HASH -->

## Example: \`$EXAMPLE_FILENAME\`

To run this example:

- Clone the [examples](https://github.com/alloy-rs/examples) repository: \`git clone git@github.com:alloy-rs/examples.git\`
- Run: \`cargo run --example $EXAMPLE_FILENAME\`

\`\`\`rust,ignore
{{#include $REFERENCE_FILEPATH}}
\`\`\`

Find the source code on Github [here](https://github.com/alloy-rs/examples/tree/main/examples/$EXAMPLE_DIRNAME/examples/$EXAMPLE_FILENAME.rs).
EOF
  done
done

  # Match the current example files list with the updated example files list
  # If there are differences, print them
  UPDATED_EXAMPLE_FILES=$(find ./src/examples -type f)
  diff <(echo "$CURRENT_EXAMPLE_FILES") <(echo "$UPDATED_EXAMPLE_FILES") || true

  log $GREEN "Done"
}

# Run the main function
# This prevents partial execution in case of incomplete downloads
main