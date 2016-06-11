tsht
====
A tiny shell-script based TAP-compliant testing framework

<!-- BEGIN-EVAL echo '<pre>';echo tsht|toilet -f bigmono9 -F crop;echo '</pre>' -->

<pre>
              █           
  █           █        █  
  █           █        █  
█████  ▒███▒  █▒██▒  █████
  █    █▒ ░█  █▓ ▒█    █  
  █    █▒░    █   █    █  
  █    ░███▒  █   █    █  
  █       ▒█  █   █    █  
  █░   █░ ▒█  █   █    █░ 
  ▒██  ▒███▒  █   █    ▒██
</pre>

<!-- END-EVAL -->

[![Build Status](https://travis-ci.org/kba/tsht.svg?branch=master)](https://travis-ci.org/kba/tsht)

<!-- BEGIN-MARKDOWN-TOC -->
* [Installation](#installation)
	* [Per project](#per-project)
	* [Per machine](#per-machine)
* [Usage](#usage)
	* [Specs](#specs)
	* [CLI](#cli)
	* [Extensions](#extensions)
	* [Example](#example)
	* [Vim integration](#vim-integration)
	* [Pretty Output](#pretty-output)
* [API - core](#api---core)
	* [plan](#plan)
	* [fail](#fail)
	* [pass](#pass)
	* [exec_fail](#exec_fail)
	* [exec_ok](#exec_ok)
	* [ok](#ok)
	* [not_ok](#not_ok)
	* [use](#use)
* [API - file](#api---file)
	* [file_exists](#file_exists)
	* [not_file_exists](#not_file_exists)
	* [not_file_empty](#not_file_empty)
	* [equals_file](#equals_file)
	* [equals_file_file](#equals_file_file)
* [API - string](#api---string)
	* [ok](#ok)
	* [not_ok](#not_ok)
	* [equals](#equals)
	* [not_equals](#not_equals)
	* [match](#match)
	* [not_match](#not_match)
* [API - jq](#api---jq)
	* [jq_ok](#jq_ok)
	* [jq_ok](#jq_ok)
* [API - colordiff](#api---colordiff)
	* [equals (colordiff)](#equals-colordiff)

<!-- END-MARKDOWN-TOC -->

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

### Pretty Output

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

<!-- BEGIN-EVAL echo '<pre>';./test/tsht|tap-spec;echo '</pre>' -->

<pre>

  Testing ./runner/update/update.tsht

    ✔ Executed: git clone ../../../ /home/kb/build/github.com/kba/tsht/test/runner/update/test-project/.tsht
    ✔ Executed: git checkout master
    ✔ Executed: git reset --hard bd9fbafa643f10087cb24ff0f3b47a9d33a12a26
    ✔ HEAD is bd9fbafa643f10087cb24ff0f3b47a9d33a12a26
    ✔ Executed: ./tsht --update
    ✔ HEAD is 5c1f40e3530d6b28607fbe478be0a6747ecf14f9

  Testing ./runner/help/help.tsht

    ✔ Executed: /home/kb/build/github.com/kba/tsht/test/.tsht/tsht-runner.sh --help
    ✔ Executed: /home/kb/build/github.com/kba/tsht/test/.tsht/tsht-runner.sh -h
    ✔ -h == --help
    ✔ Matches '--color': 'Usage: tsht [options...] [<path/to/unit.tsht>...]<LF>    Options:<LF>        --help     -h   Show this help<LF>        --color         Highlight passing/failing tests in green/red<LF>        --update '
    ✔ Matches '--update': 'Usage: tsht [options...] [<path/to/unit.tsht>...]<LF>    Options:<LF>        --help     -h   Show this help<LF>        --color         Highlight passing/failing tests in green/red<LF>        --update '
    ✔ Matches '--version': 'Usage: tsht [options...] [<path/to/unit.tsht>...]<LF>    Options:<LF>        --help     -h   Show this help<LF>        --color         Highlight passing/failing tests in green/red<LF>        --update '
    ✔ Failed as expected (2) '/home/kb/build/github.com/kba/tsht/test/.tsht/tsht-runner.sh --foobar'

  Testing ./runner/color/color-test.tsht


  /home/kb/build/github.com/kba/tsht/test/.tsht/tsht-runner.sh --color test


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

  Testing ./ext/jq/jq.tsht

    ✔ Executed: jq --version
    ✔ From string
    ✔ From STDIN (1)
    ✔ From STDIN (2)
    ✔ JSON: .foo.bar[1] -> '42'
    ✔ 

  Testing ./issues/issue_8.tsht

    ✔ Matches '--foo': '--foo'

  Testing ./before-after/ba2.tsht

    ✔ File does not exist: DELETEME

  Testing ./before-after/ba.tsht


  Sourcing suffix suffixscript ba.tsht.before for ba.tsht

    ✔ File exists: DELETEME

  Sourcing suffix suffixscript ba.tsht.after for ba.tsht



  total:     47
  passing:   47
  duration:  114ms


</pre>

<!-- END-EVAL -->

## API - core

<!-- BEGIN-RENDER lib/core.sh -->

This library the core functions of tsht. It is always included and includes
the most commonly used libraries:

* [string](#string)
* [file](#file)

### plan

Specify the number of planned assertions

    plan <number-of-tests>

### fail

Fail unconditionally

    fail <message> [<additional-output>]

The additional output will be prefixed with `#`.

### pass

Succeed unconditionally.

See [fail](#fail)

### exec_fail

Execute a command (or function) and succeed when its return code matches the
parameter <expected-return>

    exec_fail <expected-return> [<cmd-args>...]

Example

    exec_fail 2 "ls" "-la" "DOES-NOT-EXIST"

### exec_ok

Execute a command (or function) and succeed when it returns zero.

Example

    exec_ok "ls" "-la"

### ok

Succeed if the first argument is a non-empty non-zero string

### not_ok

Succeed if the first argument is an empty string or zero.
### use

Use an extension library

    use 'jq'

<!-- END-RENDER -->

## API - file

<!-- BEGIN-RENDER lib/file.sh -->

### file_exists

Succeed if a file (or folder or symlink...) exists.

    file_exists ".git"

### not_file_exists

Succeed if a file (or folder or symlink...) does not exist.

    not_file_exists "temp"

### not_file_empty

ALIAS: `file_not_empty`

Succeed if a file exists and is a non-empty file.

### equals_file

Succeed if the first arguments match the contents of the file in the second argument.

### equals_file_file

Succeed if the contents of two files match, filenames passed as arguments.

<!-- END-RENDER -->

## API - string

<!-- BEGIN-RENDER lib/string.sh -->

This library contains functions testing strings and numbers
### ok

Succeed if the first argument is a non-empty non-zero string

### not_ok

Succeed if the first argument is an empty string or zero.

### equals

Test for equality of strings

    equals <expected> <actual> [<message>]

Example:

    equals "2" 2 "two equals two"
    equals 2 "$(wc -l my-file)" "two lines in my-file"

### not_equals

Inverse of [equals](#equals).

### match

Succeed if a string matches a pattern

    match "^\\d+$" "1234" "Only numbers"

### not_match

Succeed if a string **does not** match a pattern

    not_match "^\\d+$" "abcd" "Only numbers"

<!-- END-RENDER -->

## API - jq

<!-- BEGIN-RENDER ext/jq/jq.sh -->

Extension that allows testing JSON strings.

Enable with

    use jq

See [`jq` Github repo](https://github.com/stedolan/jq).
### jq_ok

Test if `jq` expression validates

### jq_ok

Test if `jq` expression is as exepected

<!-- END-RENDER -->

## API - colordiff

<!-- BEGIN-RENDER ext/colordiff/colordiff.sh -->

Extension that replaces the builtin [`equals`](#equals) with
a function that shows the difference in a colored diff output.

Enable with

    use colordiff

Requires perl.

See [colordiff Github repo](https://github.com/daveewart/colordiff).
### equals (colordiff)

Test for equality of strings and output colored diff on fail.

    equals <expected> <actual> [<message>]

Example:

    equals "2" 2 "two equals two"
    equals 2 "$(wc -l my-file)" "two lines in my-file"

<!-- END-RENDER -->
