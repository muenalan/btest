#!/bin/bash

source /usr/local/lib/btest/btest.bash

bt_begin "btest Core Functions" 5

  bt_declare "bt_ok function"
  bt_ok
  bt_ok_if [[ $BT_COUNT_OK -eq 1 ]]

  bt_declare "bt_nok function"
  bt_nok
  bt_ok_if [[ $BT_COUNT_NOK -eq 1 ]]

  bt_declare "bt_skip function"
  bt_skip "Test skipped"
  bt_ok_if [[ $BT_COUNT_SKIPPED -eq 1 ]]

  bt_declare "bt_ok_if function"
  bt_ok_if [[ 1 -eq 1 ]]
  bt_ok_if [[ $BT_COUNT_OK -eq 3 ]]

  bt_declare "bt_ok_fexists function"
  touch temp_test_file
  bt_ok_fexists temp_test_file
  rm temp_test_file
  bt_ok_if [[ $BT_COUNT_OK -eq 5 ]]

bt_end

bt_begin "btest Advanced Functions" 3

  bt_declare "bt_ignore_next function"
  bt_ignore_next
  bt_nok
  bt_ok_if [[ $BT_COUNT_NOK -eq 1 ]]

  bt_declare "bt_if function"
  bt_if true
  bt_ok
  bt_ok_if [[ $BT_COUNT_OK -eq 7 ]]

  bt_declare "bt_ignore_if function"
  bt_ignore_if false
  bt_ok
  bt_ok_if [[ $BT_COUNT_OK -eq 9 ]]

bt_end
