#/bin/bash

# The functions in this library are considered **INTERNAL**.
#
# They should not be used in unit tests but for extending `tsht`.
#
# All internal functions are prefixed with `_tsht_` to avoid collisions


# ### _tsht_run_hook
#
# Runs a hook. A hook is either 
#   * a shell function in the environment of the test
#   * a shell script `$CURTEST.$HOOKNAME`
#   * a shell script `$CURTESTDIR/.$HOOKNAME`
#
# Pre-defined hooks:
#
#   * `before`: executed before sourcing a unit test, cannot be a function
#   * `after`: executed after finishing a unit test
#   * ~`beforeEach`: executed before every test method like `equals` or `ok`after
#   * ~`afterEach`: executed after every test method like `equals` or `ok`after
#   * ~`beforePlan`: executed before running the `plan` functionafter
#   * ~`afterPlan`: executed after running the `plan` functionafter
_tsht_run_hook() {
    local suffixscript="$CURTEST.$1"
    local dirscript="$(dirname "$CURTEST")/.$1"
    local curtest_name="${CURTEST##*/}"
    # echo "curtest_name: $curtest_name"
    # echo "suffixscript: $suffixscript"
    # echo "dirscript: $dirscript"

    if declare -f -F "$1";then
        echo "# Running function $1 for $curtest_name"
        "$1"
    elif [[ -e "$suffixscript" ]];then
        echo "# Sourcing suffix suffixscript $curtest_name.$1 for $curtest_name"
        source "$suffixscript"
    elif [[ -e "$dirscript" ]];then
        echo "# Sourcing dir script .$1 for $curtest_name"
        source "$dirscript"
    fi
}
