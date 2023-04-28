# btest
Compact bash library for testing software

## Description
A single-file bash library for testing software commands. 

## Output
Per default produces TAP (https://testanything.org/) compatible output. 

## Template

```
#!/bin/bash -l

source /path/to/btest.bash

export BT_DEBUG=1

COVERAGE="testname1" # set to 'full' for all tests

# tests

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

