#!/bin/bash

# btest.bash - Core library for the btest Bash Testing Framework
# Author: Murat Ünalan <murat.uenalan@gmail.com>

# Set default values for environment variables if not already set
: ${BT_VERSION:=0.4.6}
: ${BT_OPT_VERBOSE_DEFAULT:=0}
: ${BT_OPT_REPORT_DEFAULT:=""}
: ${BT_OPT_REPORTER_DEFAULT:=""}
: ${BT_OPT_OUTPUT_DIR_DEFAULT:="./"}
: ${BT_OPT_EPOCH_DELTA_MIN_DEFAULT:=0}
: ${BT_OPT_ABORT_DEFAULT:=0}
: ${BT_OPT_DIR_DEFAULT:=$PWD}
: ${BT_OPT_DEBUG_DEFAULT:=0}
: ${BT_OPT_PROTOCOL_DEFAULT:=TAP}
: ${BT_OPT_LOG_LEVEL_DEFAULT:=0}
: ${BT_OPT_FLAG_DRY_RUN_DEFAULT:=0}
: ${BT_OPT_FLAG_TREE_DEFAULT:=0}
: ${BT_OPT_FLAG_MARKDOWN_MODE_DEFAULT:=0}



BT_STATIC_DEBUG_DETAILED=3
BT_STATIC_DEBUG_DECISIONS=2
BT_STATIC_DEBUG_IMPORTANT=1

# bt_init: setup the environment from default variables etc.
#

function bt_variable_declare_with_default() {
    local varname="$1"                      # The first argument is the name of the variable (e.g., "BT_OPT_REPORTER")
    local varname_default="${1}_DEFAULT"                      # The first argument is the name of the variable (e.g., "BT_OPT_REPORTER")
    local default_value="${!varname_default}"                 # The second argument is the default value to assign if unset (optional)

    if [[ "$BT_OPT_DEBUG" -gt $BT_STATIC_DEBUG_DETAILED ]]; then
        echo "bt_variable_declare_with_default: varname=$varname (current value='${!varname}'), varname_default=$varname_default ('$default_value')..."
    fi
    
    # Dynamically assign a value to the variable name passed
    #    declare -g "${varname}=${!varname:-$default_value}"

    eval "$BT_DECLARE_PRE ${varname}=${!varname:-$default_value}"

    if [[ "$BT_OPT_DEBUG" -gt $BT_STATIC_DEBUG_DETAILED ]]; then
        echo "bt_variable_declare_with_default: verify $varname='${!varname}'"
    fi

    
}

function bt_init() {

    if [[ "$BT_OPT_DEBUG" -gt $BT_STATIC_DEBUG_DETAILED ]]; then
        echo "bt_init: Iterating all global variables, and set the default values (BT_OPT_DEBUG=$BT_OPT_DEBUG)"
    fi

    for VARNAME in $@; do

        bt_variable_declare_with_default "BT_OPT_$VARNAME"

    done
}

# bt_echo: Print debug messages if debug mode is enabled
# Usage: bt_echo [message...]
function bt_echo() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        if [[ $BT_OPT_DEBUG -gt 0 ]]; then
            echo -e "$@"
        fi
    fi
}

# bt_status: Print the current status of btest environment variables
# Usage: bt_status
function bt_status() {
    echo "BT_STATUS(BT_VERSION=$BT_VERSION, BT_OPT_EPOCH_DELTA_MIN=$BT_OPT_EPOCH_DELTA_MIN, BT_OPT_DIR=$BT_OPT_DIR)"
}

# bt_ignore_next: Set a flag to ignore the next test block
# Usage: bt_ignore_next
function bt_ignore_next() {
    export BT_IGNORE_NEXT=1    
}

# bt_if: Conditionally execute the next test block
# Usage: bt_if [condition]
function bt_if() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        bt_echo "BT_IF(ARG1='$1')"
        if [[ ! "$1" ]]; then
            export BT_IGNORE_NEXT=1
        fi
    fi
}

# bt_ignore_if: Ignore the next test block if the condition is true
# Usage: bt_ignore_if [condition]
function bt_ignore_if() {
    bt_echo "BT_IGNORE_IF(ARG1='$1')"
    if [[ "$1" ]]; then
        export BT_IGNORE_NEXT=1
    fi
}

# bt_call: Execute a command within the test framework
# Usage: bt_call [command...]
function bt_call() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        CMD="$*"
        bt_echo " BT_CALL(CMD='$CMD')"
        eval $CMD
    fi
}

# bt_begin: Start a new test block
# Usage: bt_begin [title] [expected_count] [subtitle]
function bt_begin() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        export BT_TITLE1=$1
        export BT_COUNT_EXPECTED=$2
        export BT_TITLE2=$3

        export BT_COUNT_DONE=0
        export BT_COUNT_OK=0
        export BT_COUNT_NOK=0
        export BT_COUNT_SKIPPED=0

        export BT_EPOCH_BEGIN=$(date +%s)

        bt_echo -e "\n\nBT_BEGIN(TITLE1=${BT_TITLE1}, TITLE2=${BT_TITLE2}, EXPECTED=${BT_COUNT_EXPECTED})"

        if [[ "$BT_OPT_PROTOCOL" == "MARKDOWN" ]]; then
            if [[ "$BT TITLE2" ]]; then
                echo "# MARKDOWN: ${BT_TITLE2} (${BT_TITLE1})"
            else
                echo "# MARKDOWN: ${BT_TITLE1}"
            fi
        fi
    fi
}

# bt_declare: Declare a subtest within a test block
# Usage: bt_declare [subtitle]
function bt_declare() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        export BT_SUBTITLE1=$1

        bt_echo " BT_DECLARE(BT_SUBTITLE1=${BT_SUBTITLE1})"

        if [[ "$BT_OPT_PROTOCOL" == "MARKDOWN" ]]; then
            echo "## BT_DECLARE: BT_TITLE1='$BT_TITLE1' BT_TITLE2='$BT_SUBTITLE1'"
        fi
    fi
}

# bt_comment: Add a comment to the test report
# Usage: bt_comment [comment...]
function bt_comment() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        FORMATTED=$*
        bt_echo " BT_COMMENT(FORMATTED='${FORMATTED}')"
        if [[ "$BT_REPORT" ]]; then
            BT_REPORT="${BT_REPORT};# $FORMATTED"
        else
            BT_REPORT="# $FORMATTED"
        fi
    fi
}

# bt_ok: Mark the current subtest as passed
# Usage: bt_ok
function bt_ok() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        bt_echo " BT_OK(BT_SUBTITLE1=${BT_SUBTITLE1})"
        let BT_COUNT_OK++
        let BT_COUNT_DONE++
    fi
}

# bt_nok: Mark the current subtest as failed
# Usage: bt_nok
function bt_nok() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        bt_echo " BT_NOK(BT_SUBTITLE1=${BT_SUBTITLE1})"
        let BT_COUNT_NOK++
        let BT_COUNT_DONE++
    fi
}

# bt_ok_if: Mark the current subtest as passed if the condition is true
# Usage: bt_ok_if [condition]
function bt_ok_if() {
    # Get all but the last argument as the condition
    local condition=("${@:1:$#}")
    
    if eval "${condition[@]}"; then
        bt_echo "bt_ok_if return true for '${condition[@]}'"
        bt_ok
        return 0
    else
        bt_echo "bt_ok_if return false for '${condition[@]}'"
        bt_nok
        return 1
    fi
}

# bt_nok_if: Mark the current subtest as passed if the condition is false
# Usage: bt_nok_if [condition]
function bt_nok_if() {
    # Get all but the last argument as the condition
    local condition=("${@:1:$#}")
    
    if "${condition[@]}"; then
        bt_echo "bt_nok_if return false for '${condition[@]}'"
        bt_nok
        return 1
    else
        bt_echo "bt_nok_if return true for '${condition[@]}'"
        bt_ok
        return 0
    fi
}

# bt_ok_fexists: Mark the current subtest as passed if the file exists
# Usage: bt_ok_fexists [filepath]
function bt_ok_fexists() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        FILEPATH=$1
        if [[ -f $1 ]]; then
            bt_ok
        else
            bt_nok
        fi
    fi
}

# bt_ok_dexists: Mark the current subtest as passed if the directory exists
# Usage: bt_ok_dexists [dirpath]
function bt_ok_dexists() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        DIRPATH=$1
        if [[ -d $1 ]]; then
            bt_ok
        else
            bt_nok
        fi
    fi
}

# bt_skip: Skip the current subtest
# Usage: bt_skip [reason]
function bt_skip() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        REASON=$1
        bt_echo " BT_SKIP(BT_SUBTITLE1=${BT_SUBTITLE1}, REASON=${REASON})"
        let BT_COUNT_SKIPPED++
        let BT_COUNT_DONE++
    fi
}

# bt_end: End the current test block and generate a report
# Usage: bt_end
function bt_end() {

    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        BT_EPOCH_END=$(date +%s)
        let BT_EPOCH_DELTA=BT_EPOCH_END-BT_EPOCH_BEGIN

        if [[ "$OSTYPE" =~ darwin ]]; then
            BT_EPOCH_DELTA_FORMATTED=`date -u -j -f "%s" ${BT_EPOCH_DELTA} "+%H:%M:%S"`
        else
            BT_EPOCH_DELTA_FORMATTED=`date +%H:%M:%S -ud @${BT_EPOCH_DELTA}`
        fi

        if [[ $BT_DONE == $BT_EXPECTED ]]; then
            BT_END_COUNT=BT_END_COUNT_DONE_EXPECTED
        fi

        if [[ $BT_DONE > $BT_EXPECTED ]]; then
            BT_END_COUNT=BT_END_COUNT_DONE_GT_EXPECTED
        fi

        if [[ $BT_DONE < $BT_EXPECTED ]]; then
            BT_END_COUNT=BT_END_COUNT_DONE_LT_EXPECTED
        fi

        bt_echo "BT_END(TITLE1=${BT_TITLE1}, DONE=${BT_COUNT_DONE}, EXPECTED=${BT_COUNT_EXPECTED}) : $BT_END_COUNT"

        if [ $BT_COUNT_NOK -gt 0 ]; then
            BT_VERDICT_OKAY=BT_VERDICT_NOK
            BT_VERDICT_OKAY_SHORT="not ok"
        else
            BT_VERDICT_OKAY=BT_VERDICT_OK
            BT_VERDICT_OKAY_SHORT="ok"
        fi

        bt_echo "BT_END(TITLE1=${BT_TITLE1}, OK=${BT_COUNT_OK}, NOK=${BT_COUNT_NOK}, SKIPPED=${BT_COUNT_SKIPPED}, BT_EPOCH_DELTA_FORMATTED=${BT_EPOCH_DELTA_FORMATTED}) : $BT_VERDICT_OKAY"

        if [ "$BT_EPOCH_DELTA" -le $BT_OPT_EPOCH_DELTA_MIN ]; then
            FORMATTED="${BT_VERDICT_OKAY_SHORT} - $BT_INFO_FILE/${BT_TITLE1} ${BT_TITLE2}"
        else
            FORMATTED="${BT_VERDICT_OKAY_SHORT} - $BT_INFO_FILE/${BT_TITLE1} ${BT_TITLE2} (t=$BT_EPOCH_DELTA_FORMATTED)"
        fi

        bt_echo "bt_end - FORMATTED=$FORMATTED"

        if [[ "$BT_REPORT" ]]; then
            BT_REPORT="${BT_REPORT};$FORMATTED"
        else
            BT_REPORT="$FORMATTED"
        fi

        bt_echo "bt_end - BT_REPORT=$BT_REPORT"

        
        # Clean up variables
        unset BT_TITLE1 BT_COUNT_EXPECTED BT_TITLE2
        unset BT_COUNT_DONE BT_COUNT_OK BT_COUNT_NOK BT_COUNT_SKIPPED
        unset BT_SUBTITLE1 BT_EPOCH_BEGIN
    else
        unset BT_IGNORE_NEXT
    fi
}

# bt_summary_tap: Generate a TAP-format summary of the test results
# Usage: bt_summary_tap
function bt_summary_tap() {
    bt_echo "\n\nBT_REPORT_BEGIN(format=TAP)"

    if [[ "$BT_REPORT" ]]; then

    bt_echo "bt_summary_tap()  - DUMP BT_REPORT: $BT_REPORT"

    while IFS=';' read -ra RESULTS; do
        MAX=0
        for ENTRY in "${RESULTS[@]}"; do
            if [[ ! $ENTRY =~ ^# ]]; then
                let MAX++
            fi
        done

        let COUNT--
        
        echo 1..$MAX

        for ENTRY in "${RESULTS[@]}"; do
            echo "$ENTRY"
        done
        
    done <<< "$BT_REPORT"

    fi
    
    bt_echo "BT_REPORT_END"
    
    return 0
}

# bt_summary_tap: Generate a TAP-format summary of the test results
# Usage: bt_summary_tap
function bt_summary_markdown() {
    bt_echo "\n\nBT_REPORT_BEGIN(format=MARKDOWN)"

    bt_echo "bt_summary_markdown()  - DUMP BT_REPORT: $BT_REPORT"

    if [[ "$BT_REPORT" ]]; then

        while IFS=';' read -ra RESULTS; do
            MAX=0
            for ENTRY in "${RESULTS[@]}"; do
                if [[ ! $ENTRY =~ ^# ]]; then
                    let MAX++
                fi
            done

            let COUNT--
            echo "# TEST COUNTS EXPECTED 1..$MAX"

            for ENTRY in "${RESULTS[@]}"; do
                echo "## TEST ENTRY: $ENTRY"
            done
        done <<< "$BT_REPORT"

    fi
    
    bt_echo "BT_REPORT_END"

    return 0
}

# bt_summary_terminal: Generate a TERMINAL-format summary of the test results
# Usage: bt_summary_terminal
function bt_summary_terminal() {
    bt_echo "\n\nBT_REPORT_BEGIN(format=TERMINAL)"

    bt_echo "bt_summary_terminal()  - DUMP BT_REPORT: $BT_REPORT"

    if [[ "$BT_REPORT" ]]; then
        
        while IFS=';' read -ra RESULTS; do
            MAX=0
            for ENTRY in "${RESULTS[@]}"; do
                if [[ ! $ENTRY =~ ^# ]]; then
                    let MAX++
                fi
            done

            let COUNT--
            echo 1..$MAX

            for ENTRY in "${RESULTS[@]}"; do

                ENTRY=$(echo "$ENTRY" | sed \
                                            -e 's/not ok -/\\e[31m✗ NOK\\e[0m -/g' \
                                            -e 's/ok -/\\e[32m✓ OK\\e[0m -/g')
                                     
                echo -e "$ENTRY"
                #            echo -e "\e[32m✓ OK\e[0m - $message"
                #            echo -e "\e[31m✗ FAIL\e[0m - $message"

            done

        done <<< "$BT_REPORT"

    fi
    
    bt_echo "BT_REPORT_END"

    return 0
}


# bt_summary: Generate a summary of the test results
# Usage: bt_summary
function bt_summary() {

    bt_echo "bt_summary (Script=$0) - BT_OPT_PROTOCOL=$BT_OPT_PROTOCOL"

    if [[ "$BT_OPT_PROTOCOL" == "TAP" ]]; then
        bt_summary_tap
    elif [[ "$BT_OPT_PROTOCOL" == "TERMINAL" ]]; then
        bt_summary_terminal
    elif [[ "$BT_OPT_PROTOCOL" == "MARKDOWN" ]]; then
        bt_summary_markdown
    fi

    unset BT_REPORT

    return 0
}

# bt_finish: Cleanup function to be called at script exit
# Usage: Not to be called directly, set as a trap
function bt_finish() {

    local exit_code=$?

    bt_echo "bt_finish (Script=$0) - BT_REPORT=$BT_REPORT"
    
    if [[ ! "$BT_ABORT" > 0 ]]; then
        bt_summary
    fi

    return $exit_code
}



#if [[ ! "$BT_TRAP_FINISH" ]]; then
    
bt_echo "Installing $0 trap EXIT bt_finish" >&2

# Set the bt_finish function as a trap for script exit
trap bt_finish EXIT
#trap 'echo "Exit code: $?"' EXIT

#export BT_TRAP_FINISH=1

#fi
