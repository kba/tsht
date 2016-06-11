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
<!-- Begin API TOC -->

	* [core](#core)
		* [plan](#plan)
		* [fail](#fail)
		* [pass](#pass)
		* [exec_fail](#exec_fail)
		* [exec_ok](#exec_ok)
		* [ok](#ok)
		* [not_ok](#not_ok)
	* [file](#file)
		* [file_exists](#file_exists)
		* [file_not_empty](#file_not_empty)
	* [string](#string)
		* [ok](#ok)
		* [not_ok](#not_ok)
		* [equals](#equals)
		* [not_equals](#not_equals)
		* [match](#match)
		* [not_match](#not_match)

<!-- End API TOC -->

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

### CLI

<!-- Begin CLI -->
```
Usage: tsht [options...] [<path/to/unit.tsht>...]
    Options:
        --help     -h   Show this help
        --color         Highlight passing/failing tests in green/red
        --update        Update the tsht framework from git
        --version  -V   Show last revision of the runner
```
<!-- End CLI -->

### Extensions

In addition to the [core functionality](#api), tsht can be extended with
extensions. An extension is a subdirectory of tsht that has this structure:

```
/ext/<name>
ext/
└── <name>
    ├── Makefile
    └── <name>.sh
```

The `Makefile` must have an `install` target that can install necessary binaries
into `$(PREFIX)/bin`.

To use an extension, call the `use` directive:

```sh
use 'jq'
```

This will call `make install` in the extension directory and set the `PATH`
variable to let the extension use the locally installed software.

Currently, these extensions are available:

* [jq](ext/jq) [[test](test/ext/jq/jq.tsht)]: A wrapper around the [jq](https://stedolan.github.io/jq) CLI JSON query tool
* [colordiff](ext/colordiff) [[test](test/ext/color/colordiff.tsht)]: Show differences with color-highlighted diff

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

<!-- Begin tsht -->
```

  Testing ./runner/update/update.tsht

    ✔ Executed: git clone ../../../ /home/kb/build/github.com/kba/tsht/test/runner/update/test-project/.tsht
    ✔ Executed: git checkout master
    ✔ Executed: git reset --hard bd9fbafa643f10087cb24ff0f3b47a9d33a12a26
    ✔ HEAD is bd9fbafa643f10087cb24ff0f3b47a9d33a12a26
    ✔ Executed: ./tsht --update
    ✔ HEAD is 57598eeb7ea49f9ef2b938c7b1cd2e07c58b2a59

  Testing ./runner/help/help.tsht

    ✔ Executed: /home/kb/build/github.com/kba/tsht/test/.tsht/tsht-runner.sh --help
    ✔ Executed: /home/kb/build/github.com/kba/tsht/test/.tsht/tsht-runner.sh -h
    ✔ -h == --help
    ✔ Matches '--color': 'Usage: tsht [options...] [<path/to/unit.tsht>...]<LF>    Options:<LF>        --help     -h   Show this help<LF>        --color         Highlight passing/failing tests in green/red<LF>        --update '
    ✔ Matches '--update': 'Usage: tsht [options...] [<path/to/unit.tsht>...]<LF>    Options:<LF>        --help     -h   Show this help<LF>        --color         Highlight passing/failing tests in green/red<LF>        --update '
    ✔ Failed as expected (2) '/home/kb/build/github.com/kba/tsht/test/.tsht/tsht-runner.sh --foobar'

  Testing ./runner/color/color-test.tsht


  /home/kb/build/github.com/kba/tsht/test/.tsht/tsht-runner.sh --color test

    ✔ Color output as expected

  Testing ./runner/0tshtlib/tshtlib.tsht

    ✔ TSHTLIB is set
    ✔ TSHTLIB is relative to this dir
    ✔ /home/kb/build/github.com/kba/tsht/test/.tsht/tsht-runner.sh is the right tsht-runner.sh

  Testing ./file.tsht

    ✔ Failed as expected (2) 'ls does-not-exist'
    ✔ Executed: touch does-not-exist
    ✔ File exists: does-not-exist
    ✔ Not empty file: does-not-exist
    ✔ (unnamed equals assertion)

  Testing ./api/core/not_ok.tsht

    ✔ Empty string
    ✔ 0
    ✔ "0"

  Testing ./api/core/exec_fail.tsht

    ✔ Failed as expected (2) 'ls does-not-exist'

  Testing ./api/core/ok.tsht

    ✔ Me testing my existence

  Testing ./api/core/exec_ok.tsht

    ✔ Executed: touch does-not-exist

  Testing ./api/file/file_exists.tsht

    ✔ File exists: does-not-exist

  Testing ./api/file/file_not_empty.tsht

    ✔ Not empty file: does-not-exist

  Testing ./api/string/match.tsht

    ✔ Matches '^d+': '1234'
    ✔ Matches '^d+$': '1234'
    ✔ Matches '^ad+$': 'a1234'

  Testing ./api/string/equals.tsht

    ✔ (unnamed equals assertion)
    ✔ (unnamed equals assertion)
    ✔ (unnamed equals assertion)
    ✔ (unnamed equals assertion)

  Testing ./api/string/not_match.tsht

    ✔ Not like '^d+$': 'string'

  Testing ./api/string/not_equals.tsht

    ✔ 1984 test

  Testing ./issues/issue_8.tsht

    ✔ Matches '--foo': '--foo'


  total:     39
  passing:   39
  duration:  19ms


```
<!-- End tsht -->

## API

<!-- Begin API -->

### core
This library the core functions of tsht. It is always included and includes
the most commonly used libraries:
* [string](#string)
* [file](#file)

##### plan

[source](./lib/core.sh#L17)
[test](./test/api/core/plan.tsht)

Specify the number of planned assertions

    plan <number-of-tests>

##### fail

[source](./lib/core.sh#L29)
[test](./test/api/core/fail.tsht)

Fail unconditionally

    fail <message> [<additional-output>]

The additional output will be prefixed with `#`.

##### pass

[source](./lib/core.sh#L50)
[test](./test/api/core/pass.tsht)

Succeed unconditionally.

See [fail](#fail)

##### exec_fail

[source](./lib/core.sh#L67)
[test](./test/api/core/exec_fail.tsht)

Execute a command (or function) and succeed when its return code matches the
parameter <expected-return>

    exec_fail <expected-return> [<cmd-args>...]

Example

    exec_fail 2 "ls" "-la" "DOES-NOT-EXIST"

##### exec_ok

[source](./lib/core.sh#L85)
[test](./test/api/core/exec_ok.tsht)

Execute a command (or function) and succeed when it returns zero.

Example

    exec_ok "ls" "-la"

##### ok

[source](./lib/core.sh#L102)
[test](./test/api/core/ok.tsht)

Succeed if the first argument is a non-empty non-zero string

##### not_ok

[source](./lib/core.sh#L116)
[test](./test/api/core/not_ok.tsht)

Succeed if the first argument is an empty string or zero.

### file

##### file_exists

[source](./lib/file.sh#L3)
[test](./test/api/file/file_exists.tsht)

Succeed if a file (or folder or symlink...) exists.

    file_exists ".git"

##### file_not_empty

[source](./lib/file.sh#L18)
[test](./test/api/file/file_not_empty.tsht)

Succeed if a file exists and is a non-empty file.

### string
This library contains functions testing strings and numbers

##### ok

[source](./lib/string.sh#L12)
[test](./test/api/string/ok.tsht)

Succeed if the first argument is a non-empty non-zero string

##### not_ok

[source](./lib/string.sh#L26)
[test](./test/api/string/not_ok.tsht)

Succeed if the first argument is an empty string or zero.

##### equals

[source](./lib/string.sh#L39)
[test](./test/api/string/equals.tsht)

Test for equality of strings

    equals <expected> <actual> [<message>]

Example:

    equals "2" 2 "two equals two"
    equals 2 "$(wc -l my-file)" "two lines in my-file"

##### not_equals

[source](./lib/string.sh#L62)
[test](./test/api/string/not_equals.tsht)

Inverse of [equals](#equals).

##### match

[source](./lib/string.sh#L78)
[test](./test/api/string/match.tsht)

Succeed if a string matches a pattern

    match "^\\d+$" "1234" "Only numbers"

##### not_match

[source](./lib/string.sh#L95)
[test](./test/api/string/not_match.tsht)

Succeed if a string **does not** match a pattern

    not_match "^\\d+$" "abcd" "Only numbers"
<!-- End API -->

