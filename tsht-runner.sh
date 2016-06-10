#!/bin/bash

USE_COLOR=0
echo-err() {
    echo "$@" >&2
}
if [[ -z "$TSHTLIB" ]];then
    echo-err "\$TSHTLIB is not set, export it or use the 'tsht' wrapper script."
    exit 201
fi

usage() {
    echo "Usage: tsht [options...] [<path/to/unit.tsht>...]
    Options:
        --help     -h   Show this help
        --color         Highlight passing/failing tests in green/red
        --update        Update the tsht framework from git
        --version  -V   Show last revision of the runner"
}

while [[ "$1" =~ ^- ]];do
    case "$1" in
        --)
            break
            ;;
        --version|-V)
            cd "$TSHTLIB"
            git log -1 --format="%C(yellow)%h %C(green)%cI %C(reset)%s"
            exit 0
            ;;
        --color)
            USE_COLOR=1
            ;;
        --update)
            cd "$TSHTLIB"
            git pull origin master && git merge origin/master master
            if [[ "$?" == 0 ]];then
                echo-err "tsht updated";
            else
                 echo-err "tsht not updated"
            fi
            exit 0
            ;;
        --help|-h)
            usage
            exit
            ;;
        *)
            echo-err "No such option: $1"
            exit 2
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
 
export total_failed
for t in "${TESTS[@]}";do
    CURTEST="$(cd "$(dirname "$t")" && pwd)/$(basename "$t")"
    echo "# Testing $t"
    (
        TEST_PLAN=0
        TEST_IDX=0
        TEST_FAILED=0
        source "$TSHTLIB/lib/core.sh"
        cd "$(dirname "$CURTEST")"
        _tsht_run_hook 'before'
        source "$(basename "$CURTEST")"
        _tsht_run_hook 'after'
        if [[ "$TEST_PLAN" == 0 ]];then
            echo "1..$TEST_IDX"
        fi
        exit "$TEST_FAILED"
    ) | (
        failed=0
        while read line;do 
            if [[ "$line" =~ ^not.ok ]];then
                failed=$((failed + 1))
            fi
            if [[ "$USE_COLOR" = 1 ]];then
                echo "$line" \
                    | sed 's/^ok/\x1b[1;32m&\x1b[0;39m/' \
                    | sed 's/^not ok/\x1b[1;31m&\x1b[0;39m/'
            else
                echo "$line"
            fi
        done
        exit $failed
    )
    total_failed=$(( total_failed + $? ))
done
echo "# Failed $total_failed tests"
exit "$total_failed"
