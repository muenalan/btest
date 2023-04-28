# btest
Bash single file library for tests

## Description
Bash library for testing software commands. Takes some inspiration from Test::More, and is compatible when output is set to TAP.

## Output
Per default produces TAP (https://testanything.org/) compatible output. See btest_summary

## Template

```
#!/bin/bash -l

source /path/to/btest.bash

export BT_DEBUG=1

COVERAGE="testname1" # set to 'full' for all tests

# tests

bt_ignore_if $( [[ ! "$COVERAGE" =~ "testname1" ]] || [[ "$COVERAGE" == "full" ]] && echo 1 ) 

bt_begin 01_testname1 1 

  bt_declare title1

  bt_ok

bt_end

bt_begin 01_testname2 2

  bt_declare title1

  bt_ok

  bt_declare title2

  bt_ok

bt_end

bt_summary
```

# Author
Murat Ünalan <murat.uenalan@gmail.com>

