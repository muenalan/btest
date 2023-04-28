#!/bin/bash

# Author: Murat Ünalan <murat.uenalan@gmail.com>
#
# License: GNU General Public License v3.0


# variables

export BT_VERSION=V0.001

export BT_REPORT=""

if [[ ! "$BT_DEBUG" ]]; then

    export BT_DEBUG=0

fi

if [[ ! "$BT_PROTOCOL" ]]; then

    export BT_PROTOCOL=TAP

fi


# functions

function bt_echo
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then
	
	if [[ $BT_DEBUG -gt 0 ]]; then

	    echo -e $*

	fi

    fi
}

function bt_ignore_next
{
    export BT_IGNORE_NEXT=1    
}

function bt_ignore_if
{
    bt_echo "BT_INGORE_IF(ARG1='$1')"
    
    if [[ "$1" ]]; then

        export BT_IGNORE_NEXT=1

    fi
}

function bt_call
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

        CMD="$*"
    
        bt_echo " BT_CALL(CMD='$CMD')"

        eval $CMD

    fi
}

function bt_begin
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

        export BT_TITLE1=$1
        export BT_COUNT_EXPECTED=$2
        export BT_TITLE2=$3

        export BT_COUNT_DONE=0
        export BT_COUNT_OK=0
        export BT_COUNT_NOK=0
        export BT_COUNT_SKIPPED=0

        bt_echo -e "\n\nBT_BEGIN(TITLE1=${BT_TITLE1}, TITLE2=${BT_TITLE2}, EXPECTED=${BT_COUNT_EXPECTED})"

    fi
}

function bt_declare
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

        export BT_SUBTITLE1=$1
 
        bt_echo " BT_DECLARE(BT_SUBTITLE1=${BT_SUBTITLE1})"

    fi
}

function bt_comment
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

        FORMATTED=$1

        bt_echo " BT_COMMENT(FORMATTED='${FORMATTED}')"

        if [[ "$BT_REPORT" ]]; then
            BT_REPORT="${BT_REPORT};# $FORMATTED"
        else
            BT_REPORT="# $FORMATTED"
        fi

    fi
}

function bt_ok
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

        bt_echo " BT_OK(BT_SUBTITLE1=${BT_SUBTITLE1})"

        let BT_COUNT_OK++
        let BT_COUNT_DONE++

    fi
}

function bt_nok
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

        bt_echo " BT_NOK(BT_SUBTITLE1=${BT_SUBTITLE1})"

        let BT_COUNT_NOK++
        let BT_COUNT_DONE++

    fi
}

function bt_fexists
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

        FILEPATH=$1

        if [[ -f $1 ]]; then
            bt_ok
        else
            bt_nok
        fi

    fi
}

function bt_dexists
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

        DIRPATH=$1

        if [[ -d $1 ]]; then
            bt_ok
        else
            bt_nok
        fi
    fi
}


function bt_skip
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

        REASON=$1
    
        bt_echo " BT_SKIP(BT_SUBTITLE1=${BT_SUBTITLE1}, REASON=${REASON})"

        let BT_COUNT_SKIPPED++
        let BT_COUNT_DONE++

    fi
}

function bt_end
{
    if [[ ! "$BT_IGNORE_NEXT" ]]; then

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
        
        bt_echo "BT_STATUS(TITLE1=${BT_TITLE1}, OK=${BT_COUNT_OK}, NOK=${BT_COUNT_NOK}, SKIPPED=${BT_COUNT_SKIPPED}) : $BT_VERDICT_OKAY"

        FORMATTED="${BT_VERDICT_OKAY_SHORT} - ${BT_TITLE1}"

        if [[ "$BT_REPORT" ]]; then
            BT_REPORT="${BT_REPORT};$FORMATTED"
        else
            BT_REPORT="$FORMATTED"
        fi
        
        unset BT_TITLE1
        unset BT_COUNT_EXPECTED
        unset BT_TITLE2

        unset BT_COUNT_DONE
        unset BT_COUNT_OK
        unset BT_COUNT_NOK
        unset BT_COUNT_SKIPPED

        unset BT_SUBTITLE1

    else

        unset BT_IGNORE_NEXT

    fi
}

# If choosen, can be invoked in the commandline with: "BT_SELFTEST=1 prove --exec bash bt.bash"

function bt_summary_tap
{
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

function bt_summary
{
    if [[ "$BT_PROTOCOL" == "TAP" ]]; then
	
	bt_summary_tap

    fi

    unset TEST_REPORT
}


function bt_selftest
{
    bt_comment "BT_VERSION=$BT_VERSION - bt_selftest() - expects one test to fail"

    bt_begin skiptest 1 

      bt_declare step1

      bt_skip

    bt_end


    bt_begin oktest 1

      bt_declare step1

      bt_ok

    bt_end


    bt_begin noktest 1

      bt_declare step1

      bt_nok

    bt_end


    bt_begin fileoktest 1

      bt_declare checkfiletest

      FILENAME=$(mktemp)
    
      bt_call "echo ABC >$FILENAME"

      bt_fexists $FILENAME

    bt_end


    bt_begin diroktest 1

      bt_declare checkfiledir

      DIRNAME=$(mktemp)

      mv $DIRNAME ${DIRNAME}.bak
      
      bt_call "mkdir $DIRNAME"

      bt_dexists $DIRNAME

    bt_end


    bt_comment "bt_ignore_next test will be invisible"

    bt_ignore_next
    
    bt_begin ignoretest 1

      bt_nok

    bt_end


    COVERAGE=full

    bt_comment "ignoretest_condition_COVERAGE_not_limited bt_ignore_if true"
    
    bt_ignore_if $( [[ "$COVERAGE" == "limited" ]] && echo 1 ) 
    
    bt_begin ignoretest_condition_COVERAGE_not_limited 1

      bt_ok

    bt_end


    bt_comment "ignoretest_condition_COVERAGE_or bt_ignore_if true"
    
    bt_ignore_if $( [[ ! "$COVERAGE" =~ "ignoretest_condition_COVERAGE_or" ]] || [[ "$COVERAGE" == "full" ]] && echo 1 ) 
   
    bt_begin ignoretest_condition_COVERAGE_or 1

      bt_ok

    bt_end



    bt_ignore_if $( [[ "$COVERAGE" == "full" ]] && echo 1 ) 
    
    bt_begin ignoretest_condition_COVERAGE_not_full 1

      bt_ok

    bt_end

    
    bt_summary
}

if [[ "$BT_SELFTEST" ]]; then

    bt_selftest

fi

