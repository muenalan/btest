#!/bin/bash

source $BT_OPT_DIR/btest.bash

function bt_selftest
{
    bt_if 1

    bt_begin iftest1 1 "Check bt_begin/bt_end executation upon bt_if"

      bt_declare step1

      bt_ok

    bt_end


    bt_begin skiptest 1 "check bt_skip"

      bt_declare step1

      bt_skip

    bt_end


    bt_begin oktest 1 "check bt_ok alone"

      bt_declare step1

      bt_ok

    bt_end


    bt_begin oktest5secs 1 "check if sleep5 is tolerated"

      bt_declare step1

      sleep 5
      
      bt_ok

    bt_end


    bt_begin fileoktest 1 "check bt_ok_fexists"

      bt_declare checkfiletest

      FILENAME=$(mktemp)
    
      bt_call "echo ABC >$FILENAME"

      bt_ok_fexists $FILENAME

    bt_end


    bt_begin diroktest 1 "check bt_ok_dexists"

      bt_declare checkfiledir

      DIRNAME=$(mktemp)

      mv $DIRNAME ${DIRNAME}.bak
      
      bt_call "mkdir $DIRNAME"

      bt_ok_dexists $DIRNAME

    bt_end


    bt_comment "bt_ignore_next test will be invisible"

    bt_ignore_next
    
    bt_begin ignoretest 1 "check for bt_nok if previous block is under bt_ignore_next"

      bt_nok

    bt_end


    COVERAGE=full

    bt_comment "ignoretest_condition_COVERAGE_not_limited bt_ignore_if true"
    
    bt_ignore_if $( [[ "$COVERAGE" == "limited" ]] && echo 1 ) 
    
    bt_begin ignoretest_condition_COVERAGE_not_limited 1 "bt_ok if previous bt_ignore_if is true"

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

    
#    bt_summary
}

bt_selftest



