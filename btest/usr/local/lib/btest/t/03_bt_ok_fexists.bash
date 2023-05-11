#!/bin/bash

source $BT_DIR/btest.bash

bt_begin bt_ok_fexists 1 

  bt_declare test_on_btest_bash_file
  
  bt_ok_fexists $BT_DIR/btest.bash

bt_end

#bt_summary
