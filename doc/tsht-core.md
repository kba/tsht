# API of tsht-core.sh

- [plan](#plan)
- [equals](#equals)
- [not_equals](#not_equals)
- [fail](#fail)
- [pass](#pass)
- [exec_fail](#exec_fail)
- [exec_ok](#exec_ok)
- [file_exists](#file_exists)
- [file_not_empty](#file_not_empty)
- [match](#match)
- [not_match](#not_match)
- [ok](#ok)
- [not_ok](#not_ok)

## plan

Specify the number of planned assertions

    plan <number-of-tests>
## equals

Test for equality of strings

    equals <expected> <actual> [<message>]

Example:

    equals "2" 2 "two equals two"
    equals 2 "$(wc -l my-file)" "two lines in my-file"
## not_equals

Inverse of [equals](#equals).
## fail

Fail unconditionally

    fail <message> [<additional-output>]

The additional output will be prefixed with `#`.
## pass

Succeed unconditionally.

See [fail](#fail)
## exec_fail

Execute a command (or function) and succeed when its return code matches the
parameter <expected-return>

    exec_fail <expected-return> [<cmd-args>...]

Example

    exec_fail 2 "ls" "-la" "DOES-NOT-EXIST"
## exec_ok

Execute a command (or function) and succeed when it returns zero.

Example

    exec_ok "ls" "-la"
## file_exists

Succeed if a file (or folder or symlink...) exists.

    file_exists ".git"
## file_not_empty

Succeed if a file exists and is a non-empty file.
## match

Succeed if a string matches a pattern

    like "^\\d+$" "1234" "Only numbers"
## not_match

Succeed if a string **does not** match a pattern

    like "^\\d+$" "1234" "Only numbers"
## ok

Succeed if the first argument is a non-empty non-zero string
## not_ok

Succeed if the first argument is an empty string or zero.
