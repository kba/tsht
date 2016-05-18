tsht
====
A tiny shell-script based TAP-compliant testing framework

[![Build Status](https://travis-ci.org/kba/tsht.svg?branch=master)](https://travis-ci.org/kba/tsht)

<!-- vim :GenTocGFM -->
* [Installation](#installation)
	* [Per project](#per-project)
	* [Per machine](#per-machine)
* [Usage](#usage)
	* [Specs](#specs)
	* [Example](#example)
	* [Vim integration](#vim-integration)
* [Pretty Output](#pretty-output)
* [API](#api)
	* [plan](#plan)
	* [equals](#equals)
	* [not_equals](#not_equals)
	* [fail](#fail)
	* [pass](#pass)
	* [exec_fail](#exec_fail)
	* [exec_ok](#exec_ok)
	* [file_exists](#file_exists)
	* [file_not_empty](#file_not_empty)
	* [match](#match)
	* [not_match](#not_match)
	* [ok](#ok)
	* [not_ok](#not_ok)

## Installation

In general you don't have to install `tsht`, simply [add the wrapper script](#per-project) to your project.

### Per project

1. Create a test directory, e.g. `test`
2. Download the wrapper script `cd test && wget 'https://cdn.rawgit.com/kba/tsht/master/tsht'`
3. Create your unit tests
4. Execute all tests using `./tsht` or specific tests using `./tsht <path/to/unit-test.tsht>...`

The first time you execute the wrapper script, it will clone this repository to
`.tsht` and execute the runner. Whenever you want to update the tsht framework,
simply delete the `.tsht` folder and an up-to-date version of the framework
will be cloned when you next run your tests.

### Per machine

To execute tsht scripts without the runner, you will need to have `tsht` in
your `$PATH`. You can either set `$PATH` up manually to include the directory that contains the
`tsht` wrapper or clone this repository and use the `Makefile`.

To install system-wide:

```
sudo make install
```

To install to your home directory:

```
make PREFIX=$HOME/.local install
```

## Usage

### Specs

Tsht unit tests are written in a DSL superset of the Bash shell scripting
language. This means that any bash code can be used in a tsht script.

All tsht scripts must end with `.tsht`.

All tsht scripts should start with `#!/usr/bin/env tsht`

Tsht scripts are executed in alphabetic order, so prefix the scripts you want
to run early with a low number.

### Example

```sh
#!/usr/bin/env tsht

plan 4

equals $(( 84 / 2 )) 42 "three score and six"
exec_ok "ls /"
match "oo" "foobar"
not_ok $(( 0 / 42 ))  "Nothing divided is nothing"
```

### Vim integration

If you are a vim user, try out the [tsht.vim](https://github.com/kba/tsht.vim)
plugin which will detect `.tsht` files, highlight the [builtin functions](#api)
and execute scripts with the closest wrapper.

## Pretty Output

There are various TAP consumers that can produce nice output, the
[tape](https://github.com/substack/tape) NodeJS TAP-based framework [lists a
few](https://github.com/substack/tape#pretty-reporters).

For example, using the [tap-spec](https://github.com/scottcorgan/tap-spec) TAP reporter can be installed using

```
npm install -g tap-spec
```

For the [tests of tsht itself](./test), it will produce output like this:

```
$ ./test/tsht | tap-spec
```

<!-- vim :!./test/tsht|tap-spec -->

```

  Testing ./file.tsht

    ✔ Failed as expected: ls does-not-exist
    ✔ Executed: touch does-not-exist
    ✔ File exists: does-not-exist
    ✔ Not empty file: does-not-exist
    ✔ (unnamed equals assertion)
    ✔ Planned number of tests

  Testing ./core/file_exists.tsht

    ✔ File exists: does-not-exist
    ✔ Planned number of tests

  Testing ./core/match.tsht

    ✔ Like '^\d+': '1234'
    ✔ Like '^\d+$': '1234'
    ✔ Like '^a\d+$': 'a1234'
    ✔ Planned number of tests

  Testing ./core/file_not_empty.tsht

    ✔ Not empty file: does-not-exist
    ✔ Planned number of tests

  Testing ./core/not_ok.tsht

    ✔ No such file, hooray!
    ✔ Planned number of tests

  Testing ./core/equals.tsht

    ✔ (unnamed equals assertion)
    ✔ (unnamed equals assertion)
    ✔ (unnamed equals assertion)
    ✔ (unnamed equals assertion)
    ✔ Planned number of tests

  Testing ./core/not_match.tsht

    ✔ Not like '^\d+$': 'a1234'
    ✔ Planned number of tests

  Testing ./core/exec_fail.tsht

    ✔ Failed as expected: ls does-not-exist
    ✔ Planned number of tests

  Testing ./core/not_equals.tsht

    ✔ 1984 test
    ✔ Planned number of tests

  Testing ./core/ok.tsht

    ✔ Me testing my existence
    ✔ Planned number of tests

  Testing ./core/exec_ok.tsht

    ✔ Executed: touch does-not-exist
    ✔ Planned number of tests

  Testing ./options.tsht

    ✔ Executed: tsht --help
    ✔ Executed: tsht -h
    ✔ (unnamed equals assertion)
    ✔ Planned number of tests


  total:     35
  passing:   35
  duration:  20ms

```

## API

<!-- vim :r!./doc/apidoc.pl tsht-core.sh -->

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
