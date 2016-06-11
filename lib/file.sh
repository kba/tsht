#!/bin/bash

## ### file_exists
##
## Succeed if a file (or folder or symlink...) exists.
##
##     file_exists ".git"
##
file_exists() {
    local file
    file="$1"
    if [[ -e "$file" ]];then
        pass "File exists: $file"
    else
        fail "File does **not** exist: $file"
    fi
}

## ### not_file_exists
##
## Succeed if a file (or folder or symlink...) does not exist.
##
##     not_file_exists "temp"
##
not_file_exists() {
    local file
    file="$1"
    if [[ ! -e "$file" ]];then
        pass "File does not exist: $file"
    else
        fail "File **does** exists: $file"
    fi
}

## ### not_file_empty
##
## ALIAS: `file_not_empty`
##
## Succeed if a file exists and is a non-empty file.
##
not_file_empty() {
    local file
    file="$1"
    if [[ -s "$file" ]];then
        pass "Not empty file: $file"
    else
        fail "Empty file: $file"
    fi
}
file_not_empty() {
    not_file_empty "$@"
}

## ### equals_file
##
## Succeed if the first arguments match the contents of the file in the second argument.
##
equals_file() {
    local actual="$1"; shift
    local filename="$1"; shift
    equals "$actual" "$(cat "$filename")" "$@"
}

## ### equals_file_file
##
## Succeed if the contents of two files match, filenames passed as arguments.
##
equals_file_file() {
    local actual="$1"; shift
    local filename="$1"; shift
    equals "$(cat "$actual")" "$(cat "$filename")" "$@"
}
