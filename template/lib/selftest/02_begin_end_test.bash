#!/bin/bash

source $BT_OPT_DIR/btest.bash

COVERAGE=notebook1


bt_begin 01_notebook1 3


  bt_declare Scripts/notebook1.ipynb

  bt_ok


  bt_declare Scripts/notebook1a.ipynb

  bt_ok


  bt_declare Scripts/notebook1b.ipynb

  bt_ok


bt_end


bt_if $( [[ "$COVERAGE" =~ "notebook2" ]] || [[ "$COVERAGE" == "full" ]] && echo 1 ) 

bt_begin 02_notebook2 2


  bt_declare Scripts/notebook2.ipynb

  bt_ok


  bt_declare Scripts/notebook2_plot.ipynb

  bt_ok


bt_end


bt_begin 03_notebook3 3


  bt_declare Scripts/notebook3.ipynb

  bt_ok


bt_end
  
#bt_summary
