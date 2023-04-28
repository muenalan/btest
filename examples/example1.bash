#!/bin/bash 

source ../btest.bash


# variables

export DIRPATH_RESULTS=/results

export BT_DEBUG=1

COVERAGE="notebook1, notebook3"


# tests

bt_ignore_if $( [[ ! "$COVERAGE" =~ "notebook1" ]] || [[ "$COVERAGE" == "full" ]] && echo 1 ) 

bt_begin 01_notebook1 1 


  bt_declare Scripts/notebook1.ipynb

  bt_call jupyter nbconvert --to notebook1 --execute Scripts/notebook1.ipynb --output-dir ${DIRPATH_RESULTS}

  bt_fexists ${DIRPATH_RESULTS}/notebook1.ipynb


bt_end


bt_ignore_if $( [[ ! "$COVERAGE" =~ "notebook2" ]] || [[ "$COVERAGE" == "full" ]] && echo 1 ) 

bt_begin 02_notebook2 2


  bt_declare Scripts/notebook2.ipynb

  bt_call jupyter nbconvert --to notebook --execute Scripts/notebook2.ipynb --output-dir ${DIRPATH_RESULTS}

  bt_fexists ${DIRPATH_RESULTS}/notebook2.ipynb


  bt_declare Scripts/notebook2_plot.ipynb

  bt_call jupyter nbconvert --to notebook --execute Scripts/notebook2_plot.ipynb --output-dir ${DIRPATH_RESULTS}

  bt_fexists ${DIRPATH_RESULTS}/notebook2_plot.ipynb


bt_end


bt_ignore_if $( [[ ! "$COVERAGE" =~ "notebook3" ]] || [[ "$COVERAGE" == "full" ]] && echo 1 ) 

bt_begin 03_notebook3 4

  export DTS_DIR_CACHE_HOME=/results/03_notebook3/

  mkdir -p $DTS_DIR_CACHE_HOME


  bt_declare DTS_build_example_data_zebrafish1

  bt_call dts invoke system/objects/example-dataset/rebuild system/contexts/example-dataset/zebrafish1

  bt_dexists $DTS_DIR_CACHE_HOME/cache/data/example-data/zebrafish1/unified/MATs/mat-algorithm1_local_maxima/


  bt_declare DTS_build_example_data_celegans1

  bt_call dts invoke system/objects/example-dataset/rebuild system/contexts/example-dataset/celegans1

  bt_dexists $DTS_DIR_CACHE_HOME/cache/data/example-data/celegans1/unified/MATs/mat-algorithm1_local_maxima/


  bt_declare DTS_build_example_data_medakashort1

  bt_call dts invoke system/objects/example-dataset/rebuild system/contexts/example-dataset/medakashort1

  bt_dexists $DTS_DIR_CACHE_HOME/cache/data/example-data/medakashort1/unified/MATs/mat-algorithm1_local_maxima/


  bt_declare DTS_build_example_data_stickleback1

  bt_call dts invoke system/objects/example-dataset/rebuild system/contexts/example-dataset/stickleback1

  bt_dexists $DTS_DIR_CACHE_HOME/cache/data/example-data/stickleback1/unified/MATs/mat-algorithm1_local_maxima/


bt_end


bt_summary
