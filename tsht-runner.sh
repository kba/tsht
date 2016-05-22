#!/bin/bash

USE_COLOR=0
if [[ -z "$TSHTLIB" ]];then
    echo "\$TSHTLIB is not set, export it or use the 'tsht' wrapper script."
    exit 201
fi

usage() {
    echo "Usage: tsht [-h] [--color] [<path/to/unit.tsht>...]"
}

while [[ "$1" =~ ^- ]];do
    case "$1" in
        --)
            break
            ;;
        # --version|-V)
        #     break
        #     ;;
        --color)
            USE_COLOR=1
            ;;
        --help|-h)
            usage
            exit
            ;;
    esac
    shift
done

declare -a TESTS

if [[ -z "$1" ]];then
    cd "$TSHTLIB/.."
    TESTS=($(find . -type f -name '*.tsht' -not -path '*/.tsht/*'))
else
    while [[ -n "$1" ]];do
        if [[ ! -e "$1" ]];then
            usage 
            echo "!! No such file: '$1' !!"
            exit 1
        fi
        TESTS+=("$1")
        shift
    done
fi

export PATH=$(readlink "$(dirname "$0")"/..):$PATH
total_failed=0
for t in "${TESTS[@]}";do
    echo "# Testing $t"
    (
        TEST_PLAN=0
        TEST_IDX=0
        TEST_FAILED=0
        source "$TSHTLIB/lib/core.sh"
        cd "$(dirname $t)"
        source "$(basename $t)"
        if [[ "$TEST_PLAN" == 0 ]];then
            echo "1..$TEST_IDX"
        else
            equals "$TEST_PLAN" "$TEST_IDX" "Planned number of tests"
        fi
        exit "$TEST_FAILED"
    ) | (
        while read line;do 
            if [[ "$USE_COLOR" = 1 ]];then
                echo "$line" \
                    | sed 's/^ok/\x1b[1;32m&\x1b[0;39m/' \
                    | sed 's/^not ok/\x1b[1;31m&\x1b[0;39m/'
            else
                echo "$line"
            fi
        done
    )
    total_failed=$((total_failed + $?))
done
echo "# Failed $total_failed tests"
exit $total_failed
