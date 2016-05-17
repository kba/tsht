#!/bin/bash

_inc_curtest() {
    TEST_IDX=$((TEST_IDX + 1))
}

# ## plan
#
# Specify the number of planned tests
#
#     plan <number-of-tests>
plan() {
    local max
    max="$1"
    TEST_PLAN=$max
    echo "$TEST_IDX..$TEST_PLAN"
}

# ## equals
#
# Test for equality of strings
#
#     equals <expected> <actual> [<message>]
#
# Example:
#
#     equals "2" 2 "two equals two"
#     equals 2 "$(wc -l my-file)" "two lines in my-file"
equals() {
    local expected actual message
    expected="$1"
    actual="$2"
    message="$3"
    message=${message:-(unnamed equals test)}
    _inc_curtest
    if [[ "$expected" -eq "$actual" ]];then
        echo "ok $TEST_IDX - $message"
    else
        echo "not ok $TEST_IDX - $message ($expected != $actual)"
    fi
}

# ## not_equals
#
# Inverse of [equals](#equals).
not_equals() {
    local expected actual message
    expected="$1"
    actual="$2"
    message="$3"
    message=${message:-(unnamed not_equals test)}
    _inc_curtest
    if [[ "$expected" -ne "$actual" ]];then
        echo "ok $TEST_IDX - $message"
    else
        echo "not ok $TEST_IDX - $message ($expected != $actual)"
    fi
}

# ## fail
#
# Fail unconditionally
#
#     fail <message> [<additional-output>]
#
# The additional output will be prefixed with `#`.
fail() {
    local message diag
    message="$1"
    # shellcheck disable=SC2001
    # diag=${output//^/#}
    if [[ -n "$2" ]];then
        diag="\n$(echo "$2"|sed 's/^/#/g')"
    fi
    _inc_curtest
    echo -e "not ok $TEST_IDX - $message$diag"
    return 42
}

# ## ok
#
# Succeed unconditionally.
#
# See [fail](#fail)
ok() {
    local message diag
    message="$1"
    # shellcheck disable=SC2001
    # diag=${output//^/#}
    if [[ -n "$2" ]];then
        diag="\n$(echo "$2"|sed 's/^/#/g')"
    fi
    _inc_curtest
    echo -e "ok $TEST_IDX - $message$diag"
}

# ## exec_fail
#
# Execute a command (or function) and succeed when its return code matches the
# parameter <expected-return>
#
#     exec_fail <expected-return> [<cmd-args>...]
#
# Example
#
#     exec_fail 2 "ls" "-la" "DOES-NOT-EXIST"
exec_fail() {
    local output expected_return
    expected_return=$1
    shift
    output=$("$@" 2>&1)
    equals "$?" "$expected_return" "Failed as expected: $*"
}

# ## exec_ok
#
# Execute a command (or function) and succeed when it returns zero.
#
# Example
#
#     exec_ok "ls" "-la"
exec_ok() {
    local output
    output=$("$@" 2>&1)
    if [[ "$?" = 0 ]];then 
        ok "Executed: $*"
    else
        fail "Failed: $*" "$output"
    fi
}

# ## file_exists
#
# Succeed if a file (or folder or symlink...) exists.
#
#     file_exists ".git"
file_exists() {
    file="$1"
    if [[ -e "$file" ]];then
        ok "File exists: $file"
    else
        fail "File does not exist: $file"
    fi
}

# ## file_not_empty
#
# Succeed if a file exists and is a non-empty file.
file_not_empty() {
    file="$1"
    if [[ -s "$file" ]];then
        ok "Not empty file: $file"
    else
        fail "Empty file: $file"
    fi
}
