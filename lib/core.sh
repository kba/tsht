#!/bin/bash
i_2="  "
i_4="${i_2}${i_2}"
i_6="${i_4}${i_2}"
i_8="${i_6}${i_2}"
i_10="${i_8}${i_2}"

## This library the core functions of tsht. It is always included and includes
## the most commonly used libraries:
##
## * [string](#string)
## * [file](#file)
##

source "$TSHTLIB/lib/internal.sh"
source "$TSHTLIB/lib/string.sh"
source "$TSHTLIB/lib/file.sh"

## ### plan
##
## Specify the number of planned assertions
##
##     plan <number-of-tests>
##
plan() {
    local max
    max="$1"
    TEST_PLAN=$((TEST_PLAN + max))
    echo "1..$((TEST_PLAN))"
}

## ### fail
##
## Fail unconditionally
##
##     fail <message> [<additional-output>]
##
## The additional output will be prefixed with `#`.
##
fail() {
    local message diag
    message="$1"
    # shellcheck disable=SC2001
    # diag=${output//^/#}
    if [[ -n "$2" ]];then
        diag="\n${i_4}---\n${i_4}diag: |\n$(echo "$2"|sed "s/^/${i_10}/g")\n${i_4}...\n"
    fi
    TEST_IDX=$((TEST_IDX + 1))
    TEST_FAILED=$((TEST_FAILED + 1))
    echo -e "not ok $TEST_IDX - $message$diag"
    return 1
}

## ### pass
##
## Succeed unconditionally.
##
## See [fail](#fail)
##
pass() {
    local message diag
    message="$1"
    # shellcheck disable=SC2001
    # if [[ -n "$2" ]];then
        # diag="\n${i_4}---\n${i_4}diag: |\n$(echo "$2"|sed "s/^/${i_10}/g")\n${i_4}...\n"
    # fi
    TEST_IDX=$((TEST_IDX + 1))
    # echo -e "ok $TEST_IDX - $message$diag"
    echo -e "ok $TEST_IDX - $message$diag"
}

## ### exec_fail
##
## Execute a command (or function) and succeed when its return code matches the
## parameter <expected-return>
##
##     exec_fail <expected-return> [<cmd-args>...]
##
## Example
##
##     exec_fail 2 "ls" "-la" "DOES-NOT-EXIST"
##
exec_fail() {
    local output expected_return
    expected_return=$1
    shift
    output=$("$@" 2>&1)
    equals "$?" "$expected_return" "Failed as expected ($expected_return) '$*'"
}

## ### exec_ok
##
## Execute a command (or function) and succeed when it returns zero.
##
## Example
##
##     exec_ok "ls" "-la"
##
exec_ok() {
    local output
    output=$("$@" 2>&1)
    if [[ "$?" = 0 ]];then 
        pass "Executed: $*"
    else
        fail "Failed: $*" "$output"
    fi
}

## ### ok
##
## Succeed if the first argument is a non-empty non-zero string
##
ok() {
    local input message
    input=$1 ; message=$2
    message=${message:-(unnamed ok assertion)}
    if [[ -z "$input" || "0" = "$input" ]];then
        fail "$message ('$input')"
    else
        pass "$message"
    fi
}

## ### not_ok
##
## Succeed if the first argument is an empty string or zero.
not_ok() {
    local input message
    input=$1 ; message=$2
    message=${message:-(unnamed not_ok assertion)}
    if [[ -z "$input" || "0" = "$input" ]];then
        pass "$message"
    else
        fail "$message"
    fi
}

## ### use
## 
## Use an extension library
##
##     use 'jq'
##
use() {
    local extname extdir extinstall extlib
    extname="$1"
    extdir="$TSHTLIB/ext/$extname"
    extmake="$extdir/Makefile"
    extlib="$extdir/$extname.sh"
    if [[ ! -d "$extdir" ]];then
        echo "# No such extension: '$extname'"
        exit 2
    elif [[ ! -e "$extmake" ]];then
        echo "# No 'Makefile' script in $extdir"
        exit 2
    elif [[ ! -e "$extlib" ]];then
        echo "# No '$extname.sh' script in $extdir"
        exit 2
    fi
    make -sC "$extdir" PREFIX="$extdir" install
    if [[ "$?" -gt 0 ]];then
        echo "# Could not install '$extname' extension"
        exit 2
    fi
    export PATH="$extdir/bin:$PATH"
    source "$extlib"
}

