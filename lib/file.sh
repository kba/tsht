#!/bin/bash

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

