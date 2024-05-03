#!/usr/bin/env bash

# Exit if anything fails
set -eo pipefail

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

  # Change directory to project root
  SCRIPT_PATH="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"
  cd "$SCRIPT_PATH/.." || exit

  # Update submodules
  git submodule update --recursive --remote
  git submodule foreach git pull origin

  # Get the commit hash of the latest commit in the examples repository
  EXAMPLES_COMMIT_HASH=$(git -C ./lib/examples rev-parse HEAD)

  # Store the current example files list for comparison
  CURRENT_EXAMPLE_FILES=$(find ./src/examples -type f)

  # Clean up existing examples
  echo "Cleaning up existing examples"
  rm -rf ./src/examples/*

  # Create example markdown files
  for CODE_DIRPATH in ./lib/examples/examples/*/; do
    # Get the example category directory name
    EXAMPLE_DIRNAME=$(basename $CODE_DIRPATH)

    # Populate the `src/examples` directory with the example category directory
    mkdir ./src/examples/$EXAMPLE_DIRNAME

    # For every example file in the examples directory
    # - Create a markdown file in the src/examples directory
    # - Insert the example code by pointer in the markdown file
    # - Include the template content by pointer if it exists
    for EXAMPLE_FILEPATH in $CODE_DIRPATH/examples/*.rs; do
      EXAMPLE_FILENAME=$(basename $EXAMPLE_FILEPATH .rs)

      TEMPLATE_FILEPATH="./src/templates/$EXAMPLE_DIRNAME/$EXAMPLE_FILENAME.md"
      BOOK_FILEPATH="./src/examples/$EXAMPLE_DIRNAME/$EXAMPLE_FILENAME.md"

      # Include the template content pointer if the template exists
      TEMPLATE_CONTENT=$(
        [ -f $TEMPLATE_FILEPATH ] && \
        echo "{{#include ../../templates/$EXAMPLE_DIRNAME/$EXAMPLE_FILENAME.md}}" || \
        echo ""
      )

      echo "Creating $BOOK_FILEPATH"

# Create the markdown file, insert the template content pointer above the example code pointer.
cat << EOF > "$BOOK_FILEPATH"
<!-- DO NOT EDIT THIS FILE. IT IS GENERATED BY RUNNING \`./scripts/update.sh\` -->
<!-- ANY CHANGES MADE TO THIS FILE WILL BE OVERWRITTEN -->
<!-- EDIT OR CREATE THIS TEMPLATE INSTEAD: $TEMPLATE_FILEPATH -->
<!-- LATEST UPDATE: https://github.com/alloy-rs/examples/tree/$EXAMPLES_COMMIT_HASH -->

## Example: \`$EXAMPLE_FILENAME\`
$TEMPLATE_CONTENT
### Example

To run this example:

- Clone the [examples](https://github.com/alloy-rs/examples) repository: \`git clone git@github.com:alloy-rs/examples.git\`
- Run: \`cargo run --example $EXAMPLE_FILENAME\`

\`\`\`rust,ignore
{{#include ../../../lib/examples/examples/$EXAMPLE_DIRNAME/examples/$(basename $EXAMPLE_FILEPATH)}}
\`\`\`

Find the source code on Github [here](https://github.com/alloy-rs/examples/tree/$EXAMPLES_COMMIT_HASH/examples/$EXAMPLE_DIRNAME/examples/$EXAMPLE_FILENAME.rs).
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