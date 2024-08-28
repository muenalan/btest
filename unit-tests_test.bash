#!/bin/bash

source $BT_DIR/btest.bash

export BT_DEBUG=1

bt_begin btest_core 7

  bt_declare "bt_ok function"
  bt_ok_if [[ $BT_COUNT_OK -eq 1 ]]

  bt_declare "bt_nok function"
  bt_ok_if [[ $BT_COUNT_NOK -eq 1 ]]

  bt_skip "Test skipped"
  bt_declare "bt_skip function"
  bt_ok_if [[ $BT_COUNT_SKIPPED -eq 1 ]]

  bt_declare "bt_ok_if function 1"
  bt_ok_if [[ 1 -eq 1 ]]

  bt_declare "bt_ok_if function 2"
  bt_ok_if [[ $BT_COUNT_OK -eq 3 ]]

  bt_declare "bt_ok_fexists function1"
  bt_call touch temp_test_file
  bt_ok_fexists temp_test_file

  bt_declare "bt_ok_fexists function2"
  bt_call rm temp_test_file
  bt_ok_if [[ $BT_COUNT_OK -eq 5 ]]

bt_end


bt_if true

bt_begin bt_if 1

  bt_declare "bt_if function"

  bt_ok_if [[ $BT_COUNT_OK -eq 0 ]]

bt_end


bt_ignore_if 0

bt_begin bt_ignore_if 1

  bt_declare "bt_ignore_if function"

  bt_ok_if [[ $BT_COUNT_OK -eq 0 ]]

bt_end

  

