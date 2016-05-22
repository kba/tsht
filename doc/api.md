## lib/file.sh

### file_exists

[source](./lib/file.sh#L3)
[test](./test/file/file_exists.tsht)

Succeed if a file (or folder or symlink...) exists.

    file_exists ".git"

### file_not_empty

[source](./lib/file.sh#L18)
[test](./test/file/file_not_empty.tsht)

Succeed if a file exists and is a non-empty file.
## lib/core.sh

### plan

[source](./lib/core.sh#L8)
[test](./test/core/plan.tsht)

Specify the number of planned assertions

    plan <number-of-tests>

### fail

[source](./lib/core.sh#L20)
[test](./test/core/fail.tsht)

Fail unconditionally

    fail <message> [<additional-output>]

The additional output will be prefixed with `#`.

### pass

[source](./lib/core.sh#L41)
[test](./test/core/pass.tsht)

Succeed unconditionally.

See [fail](#fail)

### equals

[source](./lib/core.sh#L58)
[test](./test/core/equals.tsht)

Test for equality of strings

    equals <expected> <actual> [<message>]

Example:

    equals "2" 2 "two equals two"
    equals 2 "$(wc -l my-file)" "two lines in my-file"

### not_equals

[source](./lib/core.sh#L81)
[test](./test/core/not_equals.tsht)

Inverse of [equals](#equals).

### exec_fail

[source](./lib/core.sh#L97)
[test](./test/core/exec_fail.tsht)

Execute a command (or function) and succeed when its return code matches the
parameter <expected-return>

    exec_fail <expected-return> [<cmd-args>...]

Example

    exec_fail 2 "ls" "-la" "DOES-NOT-EXIST"

### exec_ok

[source](./lib/core.sh#L115)
[test](./test/core/exec_ok.tsht)

Execute a command (or function) and succeed when it returns zero.

Example

    exec_ok "ls" "-la"

### match

[source](./lib/core.sh#L132)
[test](./test/core/match.tsht)

Succeed if a string matches a pattern

    match "^\\d+$" "1234" "Only numbers"

### not_match

[source](./lib/core.sh#L151)
[test](./test/core/not_match.tsht)

Succeed if a string **does not** match a pattern

    not_match "^\\d+$" "abcd" "Only numbers"

### ok

[source](./lib/core.sh#L170)
[test](./test/core/ok.tsht)

Succeed if the first argument is a non-empty non-zero string

### not_ok

[source](./lib/core.sh#L184)
[test](./test/core/not_ok.tsht)

Succeed if the first argument is an empty string or zero.
