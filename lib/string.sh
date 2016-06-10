#!/bin/bash

# This library contains functions testing strings and numbers

_shorten() {
    string="$1"
    string=${string//$'\n'/<LF>}
    string=${string:0:200}
    echo "$string"
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
        fail "$message ('$(_shorten "$expected")' != '$(_shorten "$actual")')"
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
        fail "$message ('$(_shorten "$expected")' == '$(_shorten "$actual")')"
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
    echo "$string"|grep -Pi -- "$pattern" 2>/dev/null >&2
    if [[ "$?" != 0 ]];then
        fail "Does ot match '$pattern': '$(_shorten "$string")'"
    else
        pass "Matches '$pattern': '$(_shorten "$string" )'"
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
    echo "$string"|grep -Pi -- "$pattern" 2>/dev/null >&2
    if [[ "$?" = 0 ]];then
        fail "Like '$pattern': '$string'"
    else
        pass "Not like '$pattern': '$(_shorten string)'"
    fi
}

