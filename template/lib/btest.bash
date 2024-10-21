#!/bin/bash

# btest.bash - Core library for the btest Bash Testing Framework
# Version: 0.3.1
# Author: Murat Ünalan <murat.uenalan@gmail.com>

# Set default values for environment variables if not already set
: ${BT_VERSION:=0.3.2}
: ${BT_REPORT:=""}
: ${BT_EPOCH_DELTA_MIN:=0}
: ${BT_ABORT:=0}
: ${BT_DIR:=$PWD}
: ${BT_DEBUG:=0}
: ${BT_PROTOCOL:=TAP}
: ${BT_OPT_FLAG_TREE:=0}

# bt_echo: Print debug messages if debug mode is enabled
# Usage: bt_echo [message...]
bt_echo() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        if [[ $BT_DEBUG -gt 0 ]]; then
            echo -e "$@"
        fi
    fi
}

# bt_status: Print the current status of btest environment variables
# Usage: bt_status
bt_status() {
    echo "BT_STATUS(BT_VERSION=$BT_VERSION, BT_EPOCH_DELTA_MIN=$BT_EPOCH_DELTA_MIN, BT_DIR=$BT_DIR)"
}

# bt_ignore_next: Set a flag to ignore the next test block
# Usage: bt_ignore_next
bt_ignore_next() {
    export BT_IGNORE_NEXT=1    
}

# bt_if: Conditionally execute the next test block
# Usage: bt_if [condition]
bt_if() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        bt_echo "BT_IF(ARG1='$1')"
        if [[ ! "$1" ]]; then
            export BT_IGNORE_NEXT=1
        fi
    fi
}

# bt_ignore_if: Ignore the next test block if the condition is true
# Usage: bt_ignore_if [condition]
bt_ignore_if() {
    bt_echo "BT_IGNORE_IF(ARG1='$1')"
    if [[ "$1" ]]; then
        export BT_IGNORE_NEXT=1
    fi
}

# bt_call: Execute a command within the test framework
# Usage: bt_call [command...]
bt_call() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        CMD="$*"
        bt_echo " BT_CALL(CMD='$CMD')"
        eval $CMD
    fi
}

# bt_begin: Start a new test block
# Usage: bt_begin [title] [expected_count] [subtitle]
bt_begin() {
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
    fi
}

# bt_declare: Declare a subtest within a test block
# Usage: bt_declare [subtitle]
bt_declare() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        export BT_SUBTITLE1=$1
        bt_echo " BT_DECLARE(BT_SUBTITLE1=${BT_SUBTITLE1})"
    fi
}

# bt_comment: Add a comment to the test report
# Usage: bt_comment [comment...]
bt_comment() {
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
bt_ok() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        bt_echo " BT_OK(BT_SUBTITLE1=${BT_SUBTITLE1})"
        let BT_COUNT_OK++
        let BT_COUNT_DONE++
    fi
}

# bt_nok: Mark the current subtest as failed
# Usage: bt_nok
bt_nok() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        bt_echo " BT_NOK(BT_SUBTITLE1=${BT_SUBTITLE1})"
        let BT_COUNT_NOK++
        let BT_COUNT_DONE++
    fi
}

# bt_ok_if: Mark the current subtest as passed if the condition is true
# Usage: bt_ok_if [condition]
bt_ok_if() {
    if [[ "$1" ]]; then
        bt_ok
    else
        bt_nok
    fi
}

# bt_ok_fexists: Mark the current subtest as passed if the file exists
# Usage: bt_ok_fexists [filepath]
bt_ok_fexists() {
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
bt_ok_dexists() {
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
bt_skip() {
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
        REASON=$1
        bt_echo " BT_SKIP(BT_SUBTITLE1=${BT_SUBTITLE1}, REASON=${REASON})"
        let BT_COUNT_SKIPPED++
        let BT_COUNT_DONE++
    fi
}

# bt_end: End the current test block and generate a report
# Usage: bt_end
bt_end() {
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

        if [ "$BT_EPOCH_DELTA" -le $BT_EPOCH_DELTA_MIN ]; then
            FORMATTED="${BT_VERDICT_OKAY_SHORT} - ${BT_TITLE1}"
        else
            FORMATTED="${BT_VERDICT_OKAY_SHORT} - ${BT_TITLE1} (t=$BT_EPOCH_DELTA_FORMATTED)"
        fi

        if [[ "$BT_REPORT" ]]; then
            BT_REPORT="${BT_REPORT};$FORMATTED"
        else
            BT_REPORT="$FORMATTED"
        fi

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
bt_summary_tap() {
    bt_echo "\n\nBT_REPORT_BEGIN(format=TAP)"

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

    bt_echo "BT_REPORT_END"
}

# bt_summary: Generate a summary of the test results
# Usage: bt_summary
bt_summary() {
    if [[ "$BT_PROTOCOL" == "TAP" ]]; then
        bt_summary_tap
    fi
    unset BT_REPORT
}

# bt_finish: Cleanup function to be called at script exit
# Usage: Not to be called directly, set as a trap
bt_finish() {
    if [[ ! "$BT_ABORT" > 0 ]]; then
        bt_summary
    fi
}

# Set the bt_finish function as a trap for script exit
trap bt_finish EXIT
