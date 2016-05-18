
### plan

[source](./tsht-core.sh#L3)
[test](./test/core/plan.tsht)

Specify the number of planned assertions

    plan <number-of-tests>

### equals

[source](./tsht-core.sh#L15)
[test](./test/core/equals.tsht)

Test for equality of strings

    equals <expected> <actual> [<message>]

Example:

    equals "2" 2 "two equals two"
    equals 2 "$(wc -l my-file)" "two lines in my-file"

### not_equals

[source](./tsht-core.sh#L39)
[test](./test/core/not_equals.tsht)

Inverse of [equals](#equals).

### fail

[source](./tsht-core.sh#L56)
[test](./test/core/fail.tsht)

Fail unconditionally

    fail <message> [<additional-output>]

The additional output will be prefixed with `#`.

### pass

[source](./tsht-core.sh#L76)
[test](./test/core/pass.tsht)

Succeed unconditionally.

See [fail](#fail)

### exec_fail

[source](./tsht-core.sh#L93)
[test](./test/core/exec_fail.tsht)

Execute a command (or function) and succeed when its return code matches the
parameter <expected-return>

    exec_fail <expected-return> [<cmd-args>...]

Example

    exec_fail 2 "ls" "-la" "DOES-NOT-EXIST"

### exec_ok

[source](./tsht-core.sh#L111)
[test](./test/core/exec_ok.tsht)

Execute a command (or function) and succeed when it returns zero.

Example

    exec_ok "ls" "-la"

### file_exists

[source](./tsht-core.sh#L128)
[test](./test/core/file_exists.tsht)

Succeed if a file (or folder or symlink...) exists.

    file_exists ".git"

### file_not_empty

[source](./tsht-core.sh#L143)
[test](./test/core/file_not_empty.tsht)

Succeed if a file exists and is a non-empty file.

### match

[source](./tsht-core.sh#L156)
[test](./test/core/match.tsht)

Succeed if a string matches a pattern

    match "^\\d+$" "1234" "Only numbers"

### not_match

[source](./tsht-core.sh#L173)
[test](./test/core/not_match.tsht)

Succeed if a string **does not** match a pattern

    not_match "^\\d+$" "abcd" "Only numbers"

### ok

[source](./tsht-core.sh#L190)
[test](./test/core/ok.tsht)

Succeed if the first argument is a non-empty non-zero string

### not_ok

[source](./tsht-core.sh#L204)
[test](./test/core/not_ok.tsht)

Succeed if the first argument is an empty string or zero.
