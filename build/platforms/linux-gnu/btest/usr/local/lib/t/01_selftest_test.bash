#!/bin/bash

source $BT_DIR/btest.bash

function bt_selftest
{
    bt_comment $(bt_status)

    bt_if 1

    bt_begin iftest1 1 

      bt_declare step1

      bt_ok

    bt_end


    bt_begin skiptest 1 

      bt_declare step1

      bt_skip

    bt_end


    bt_begin oktest 1

      bt_declare step1

      bt_ok

    bt_end


    bt_begin oktest5secs 1

      bt_declare step1

      sleep 5
      
      bt_ok

    bt_end


    bt_begin fileoktest 1

      bt_declare checkfiletest

      FILENAME=$(mktemp)
    
      bt_call "echo ABC >$FILENAME"

      bt_ok_fexists $FILENAME

    bt_end


    bt_begin diroktest 1

      bt_declare checkfiledir

      DIRNAME=$(mktemp)

      mv $DIRNAME ${DIRNAME}.bak
      
      bt_call "mkdir $DIRNAME"

      bt_ok_dexists $DIRNAME

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

    
#    bt_summary
}

bt_selftest



