#!/bin/bash
i_2="  "
i_4="${i_2}${i_2}"
i_6="${i_4}${i_2}"
i_8="${i_6}${i_2}"
i_10="${i_8}${i_2}"

# ### plan
#
# Specify the number of planned assertions
#
#     plan <number-of-tests>
plan() {
    local max
    max="$1"
    TEST_PLAN=$((TEST_PLAN + max))
    echo "1..$((TEST_PLAN + 1))"
}

# ### fail
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
        diag="\n${i_4}---\n${i_4}diag: |\n$(echo "$2"|sed "s/^/${i_10}/g")\n${i_4}...\n"
    fi
    TEST_IDX=$((TEST_IDX + 1))
    TEST_FAILED=$((TEST_FAILED + 1))
    echo -e "not ok $TEST_IDX - $message$diag"
    return 1
}

# ### pass
#
# Succeed unconditionally.
#
# See [fail](#fail)
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

# ### equals
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
    message=${message:-(unnamed equals assertion)}
    if [[ "$expected" = "$actual" ]];then
        pass "$message"
    else
        fail "$message ($expected != $actual)"
    fi
}

# ### not_equals
#
# Inverse of [equals](#equals).
not_equals() {
    local expected actual message
    expected="$1"
    actual="$2"
    message="$3"
    message=${message:-(unnamed not_equals assertion)}
    if [[ "$expected" -ne "$actual" ]];then
        pass "$message"
    else
        fail "$message ($expected != $actual)"
    fi
}

# ### exec_fail
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

# ### exec_ok
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
        pass "Executed: $*"
    else
        fail "Failed: $*" "$output"
    fi
}

# ### file_exists
#
# Succeed if a file (or folder or symlink...) exists.
#
#     file_exists ".git"
file_exists() {
    local file
    file="$1"
    if [[ -e "$file" ]];then
        pass "File exists: $file"
    else
        fail "File does not exist: $file"
    fi
}

# ### file_not_empty
#
# Succeed if a file exists and is a non-empty file.
file_not_empty() {
    local file
    file="$1"
    if [[ -s "$file" ]];then
        pass "Not empty file: $file"
    else
        fail "Empty file: $file"
    fi
}

# ### match
#
# Succeed if a string matches a pattern
#
#     match "^\\d+$" "1234" "Only numbers"
match() {
    local pattern string message
    pattern="$1"; string="$2"; message="$3"
    message=${message:-(unnamed match assertion)}
    echo "$string"|grep -Pi "$pattern" 2>/dev/null >&2
    if [[ "$?" != 0 ]];then
        fail "Does ot match '$pattern': '$string'"
    else
        string=${string//$'\n'/}
        string=${string:0:50}
        pass "Matches '$pattern': '${string}...'"
    fi
}

# ### not_match
#
# Succeed if a string **does not** match a pattern
#
#     not_match "^\\d+$" "abcd" "Only numbers"
not_match() {
    local pattern string message
    pattern="$1"; string="$2"; message="$3"
    message=${message:-(unnamed not_match assertion)}
    echo "$string"|grep -Pi "$pattern" 2>/dev/null >&2
    if [[ "$?" = 0 ]];then
        fail "Like '$pattern': '$string'"
    else
        string=${string//$'\n'/}
        string=${string:0:50}
        pass "Not like '$pattern': '$string'"
    fi
}

# ### ok
#
# Succeed if the first argument is a non-empty non-zero string
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

# ### not_ok
#
# Succeed if the first argument is an empty string or zero.
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
