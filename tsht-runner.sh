#!/bin/bash

if [[ -z "$TSHTLIB" ]];then
    echo "\$TSHTLIB is not set, export it or use the runner.sh"
    exit 201
fi

usage() {
    echo "Usage: $0 [-h] [<path/to/unit.sh>]"
}

declare -a TESTS

if [[ -n "$1" ]];then
    if [[ "$1" = "-h" ]];then
        usage
        exit
    elif [[ -e "$1" ]];then
        TESTS=("$1")
    else
        usage 
        echo "!! No such file: '$1' !!"
        exit 1
    fi
else
    cd "$TSHTLIB/.."
    TESTS=($(find . -type f -name '*.tsht'))
fi

for t in "${TESTS[@]}";do
    echo "#"
    echo "# Testing $t"
    echo "#"
    (
        TEST_IDX=0
        TEST_PLAN=0
        source "$TSHTLIB/tsht-core.sh"
        cd "$(dirname $t)"
        source "$(basename $t)"
        if [[ "$TEST_PLAN" -eq 0 ]];then
            echo "1..$TEST_IDX"
        else
            equals "$TEST_PLAN" "$TEST_IDX" "Planned number of tests"
        fi
    )
done
