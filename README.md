tsht
====
A tiny shell-script based testing framework

[![Build Status](https://travis-ci.org/kba/tsht.svg?branch=master)](https://travis-ci.org/kba/tsht)

## Installation

In general you don't have to install `tsht`, simply [add the wrapper script](#usage) to your project.

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

1. Create a test directory, e.g. `test`
2. Copy and paste the contents of [`tsht`](./tsht) to a file named `tsht`.
3. Create your unit tests
4. Execute all tests using `./tsht` or a single test using `./tsht path/to/unit-test.tsht`

## Creating a unit test

Tsht unit tests are written in a DSL superset of the Bash shell scripting
language. This means that any bash code can be used in a tsht script.

All tsht scripts must end with `.tsht`.

All tsht scripts should start with `#!/usr/bin/env tsht`

Tsht scripts are executed in alphabetic order, so prefix the scripts you want
to run early with a low number.

## API

See the auto-generated docs in [./doc](./doc)

* [Core functions](./doc/tsht-core.md)
