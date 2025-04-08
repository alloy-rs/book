#!/usr/bin/env bash

# Exit if anything fails
set -eo pipefail

# Utilities
GREEN="\033[00;32m"
YELLOW="\033[00;33m"

function log () {
  echo -e "$1"
  echo "################################################################################"
  echo "#### $2 "
  echo "################################################################################"
  echo -e "\033[0m"
}

# Cloned examples should be moved here from `lib/examples/examples`
SNIPPETS_PATH="./vocs/docs/snippets"
# MDX Snippets path
MDX_SNIPPETS_PATH="./vocs/docs/pages/examples"
# Templates path
MDX_TEMPLATES_PATH="./vocs/docs/pages/templates"
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
  git submodule init
  git submodule update --recursive --remote
  git submodule foreach git checkout main
  git submodule foreach git pull origin main

  # Create the $SNIPPETS_PATH directory if it doesn't exist
  mkdir -p $SNIPPETS_PATH

  # Copy the directory and files from `lib/examples/examples` to $SNIPPETS_PATH
  echo "Copying examples to $SNIPPETS_PATH"
  cp -r ./lib/examples/examples/* $SNIPPETS_PATH/
  
  log $GREEN "Copied examples to $SNIPPETS_PATH"

  # Create the `src/examples` directory if it doesn't exist
  mkdir -p ./src/examples

  # Get the commit hash of the latest commit in the examples repository
  EXAMPLES_COMMIT_HASH=$(git -C ./lib/examples rev-parse HEAD)

  # Store the current example files list for comparison
  CURRENT_EXAMPLE_FILES=$(find ./src/examples -type f)

  # Clean up existing examples
  echo "Cleaning up existing examples"
  rm -rf ./src/examples/*

  # Create the $MDX_SNIPPETS_PATH directory if it doesn't exist
  mkdir -p $MDX_SNIPPETS_PATH

  # Create example markdown files
  for CODE_DIRPATH in ./lib/examples/examples/*/; do
    # Get the example category directory name
    EXAMPLE_DIRNAME=$(basename $CODE_DIRPATH)

    # Populate the `src/examples` directory with the example category directory
    mkdir -p ./src/examples/$EXAMPLE_DIRNAME

    # Populate the $MDX_SNIPPETS_PATH directory with the example category directory
    mkdir -p $MDX_SNIPPETS_PATH/$EXAMPLE_DIRNAME

    # Populate the `src/templates` directory with the example category directory if it doesn't exist
    mkdir -p ./src/templates/$EXAMPLE_DIRNAME
    touch ./src/templates/$EXAMPLE_DIRNAME/README.md
    cp ./src/templates/$EXAMPLE_DIRNAME/README.md ./src/examples/$EXAMPLE_DIRNAME/README.md

    # Populate the $MDX_TEMPLATES_PATH directory with the example category directory if it doesn't exist
    mkdir -p $MDX_TEMPLATES_PATH/$EXAMPLE_DIRNAME
    touch $MDX_TEMPLATES_PATH/$EXAMPLE_DIRNAME/README.mdx
    cp $MDX_TEMPLATES_PATH/$EXAMPLE_DIRNAME/README.mdx $MDX_SNIPPETS_PATH/$EXAMPLE_DIRNAME/README.mdx

    # For every example file in the examples directory
    # - Create a markdown file in the src/examples directory
    # - Insert the example code by reference in the markdown file
    # - Include the template content by pointer if it exists
    for EXAMPLE_FILEPATH in $CODE_DIRPATH/examples/*.rs; do
      EXAMPLE_FILENAME=$(basename $EXAMPLE_FILEPATH .rs)
      TEMPLATE_FILEPATH="./src/templates/$EXAMPLE_DIRNAME/$EXAMPLE_FILENAME.md"
      BOOK_FILEPATH="./src/examples/$EXAMPLE_DIRNAME/$EXAMPLE_FILENAME.md"
      MDX_SNIPPET=$MDX_SNIPPETS_PATH/$EXAMPLE_DIRNAME/$EXAMPLE_FILENAME.mdx

      # Include the template content pointer if the template exists
      TEMPLATE_CONTENT=$(
        [ -f $TEMPLATE_FILEPATH ] && \
        echo "{{#include ../../templates/$EXAMPLE_DIRNAME/$EXAMPLE_FILENAME.md}}" || \
        echo ""
      )

      echo "Creating $MDX_SNIPPET"

# Create the markdown file for the example
cat << EOF > "$MDX_SNIPPET"
{/*DO NOT EDIT THIS FILE. IT IS GENERATED BY RUNNING \`./scripts/update.sh\`
ANY CHANGES MADE TO THIS FILE WILL BE OVERWRITTEN
EDIT OR CREATE THIS TEMPLATE INSTEAD: $TEMPLATE_FILEPATH
LATEST UPDATE: https://github.com/alloy-rs/examples/tree/$EXAMPLES_COMMIT_HASH
*/}

## Example: \`$EXAMPLE_FILENAME\`
$TEMPLATE_CONTENT

To run this example:

- Clone the [examples](https://github.com/alloy-rs/examples) repository: \`git clone git@github.com:alloy-rs/examples.git\`
- Run: \`cargo run --example $EXAMPLE_FILENAME\`

\`\`\`rust
// [!include ~/snippets/$EXAMPLE_DIRNAME/examples/$(basename $EXAMPLE_FILEPATH)]
\`\`\`

Find the source code on Github [here](https://github.com/alloy-rs/examples/tree/$EXAMPLES_COMMIT_HASH/examples/$EXAMPLE_DIRNAME/examples/$EXAMPLE_FILENAME.rs).
EOF
  done
done

  # Duplicate specific examples that symlink to other examples
  cp $MDX_SNIPPETS_PATH/contracts/deploy_from_contract.mdx $MDX_SNIPPETS_PATH/sol-macro/contract.mdx

  # Match the current example files list with the updated example files list
  # If there are differences, print them
  UPDATED_EXAMPLE_FILES=$(find ./src/examples -type f)
  diff <(echo "$CURRENT_EXAMPLE_FILES") <(echo "$UPDATED_EXAMPLE_FILES") || true

  log $YELLOW "Update \`src/SUMMARY.md\` and \`src/templates/*/README.md\` if necessary!"

  log $GREEN "Done"
}

# Run the main function
# This prevents partial execution in case of incomplete downloads
main