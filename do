#!/bin/bash

# Load helper functions and globals; note that the function 'run-do-script' still needs to be called
source ./.do.sh

# Environment setup:  (Needed for most functions)  but quietly
ENV_FILE="${ENV_FILE:-my-env.sh}"
if [ -e "${ENV_FILE}" ]; then
    debug 1 "Loading environment settings from '${ENV_FILE}'.."
    # shellcheck source=./my-env.sh
    QUIET=1  # enh: quiet++
    source "${ENV_FILE}" > /dev/null
    QUIET=0
fi

# Adding bin to path..
if [ -d "$(pwd)/bin" ]; then
    debug 2 "Adding ./bin to the path.."
    export PATH="$(pwd)/bin:${PATH}"
fi

# Set up some variables, if not already defined:
MAIN_FILE="${MAIN_FILE:-src/main.ts}"

#
# Helper functions
#
banner() {
    if [ -x $(which figlet) ]; then
        figlet "$@"
    else
        echo "####################"
        echo "$@"
        echo "####################"
    fi
}

# Sample:
#orm() {
#    yarn typeorm -d ./src/database/dataSource.ts $@
#}

#
# Commands (functions starting with 'do-')
#

do-setup() {
    # quick install deno here..
    mkdir -pv bin
    if [ ! -e "bin/deno" ]; then
        debug 1 "Setting up deno into ./bin/deno"
        cat setup/deno.gz | gzip -d > bin/deno
        chmod +x bin/deno
    fi
    bin/deno --version
}

do-help() {
    show_usage
    # Append a little extra info:
    cat <<EOF

Environment variables used:
   ENV_FILE: [default: my-env.sh]
       - bash script sourced (if it exists) to load your particular environment variables & overrides
EOF
}

do-build() {
    OUTFILE="${MAIN_FILE/.ts/.bin}"
    OUTFILE="${OUTFILE/src\//dist/}"
    debug 1 "Using MAIN_FILE: '${MAIN_FILE}', OUTFILE: '${OUTFILE}'"
    true &&
        deno check "${MAIN_FILE}" &&
        deno lint "${MAIN_FILE}" &&
        deno compile --output "${OUTFILE}" "${MAIN_FILE}"
}

do-start() {
    true &&
        # deno install &&
        deno task dev
}

do-run() {
    deno task dev
}

do-pre-push() {
    true &&
        # deno install &&
        deno fmt &&
        deno lint &&
        deno check &&
        deno test &&
        banner pre-push done
}

do-tests() {
    deno test
}

# Run the script using all the above defined functions
run-do-script $@
