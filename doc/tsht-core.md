# API of tsht-core.sh

- [plan](#plan)
- [equals](#equals)
- [not_equals](#not_equals)
- [fail](#fail)
- [ok](#ok)
- [exec_fail](#exec_fail)
- [exec_ok](#exec_ok)
- [file_exists](#file_exists)
- [file_not_empty](#file_not_empty)

## plan

Specify the number of planned tests

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
## ok

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
