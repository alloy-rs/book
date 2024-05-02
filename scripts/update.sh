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

log $GREEN "Updating..."

# Update submodules
git submodule update --init --recursive

# Clean up existing examples
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

cat << EOF > "$BOOK_FILEPATH"
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

log $GREEN "Done"