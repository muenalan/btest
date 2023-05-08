# btest
Compact bash library for testing software

## Description
A single-file bash library for testing software commands. 

## Output
Per default produces [TAP](https://testanything.org/) compatible output. 

## Template: testfile.bash

```
#!/bin/bash -l

source /path/to/btest.bash

# tests

bt_begin 01_testname1 1 

  bt_declare title1

  bt_call sleep 10
  
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

### Invokation
Call the file from the commandline as usual.

```
$ bash testfile.bash
```

### Output
Per default, [TAP](https://testanything.org/) is printed to stdout.

```
1..2
ok - 01_testname1 (00:00:10)
ok - 02_testname2
```

Note that only blocks of tests are shown; subtests not. 

### [TAP](https://testanything.org/) harness (*btest* self-test)
You can use [prove](https://perldoc.perl.org/prove) to verify a test. *btest* comes with a small self-test (which fails a single test). You can call it as:
```
$ BT_SELFTEST=1 prove --exec bash ./btest.bash
```

# Environment
When btest is called with *source*, following environment is exported:

    BT_VERSION - btest library version

Following environment is used to change the behavior of *btest*:

    BT_DEBUG - debug-level controlling the verbosity (default=0, silent)
    BT_PROTOCOL - protocol for bt_summary (default=TAP)
    BT_EPOCH_DELTA_MIN - minimal number of seconds a test uses, so the time is included in the testreport (default=0, always).

# Structural functions
The main concept of *btest* are test blocks. These are sections, which are enclosed by bt_begin/bt_end.
```
bt_begin

  ...
  ... block functions
  ...

bt_end
```

## bt_begin <testname> <expected>
Start a block of texts, encompassing <expected> number of *ok*.

## bt_end
End of bt_begin block.

## bt_ignore_next
Completely ignore bt_begin/bt_end block. Note that commands will be still executed, however bt_ commands will be ignored.
```
bt_ignore_next

bt_begin

  ...
  ... All bt_ block functions are ignored
  ...

bt_end
```

## bt_ignore_if condition
Conditionally ignore bt_begin/bt_end block. Note that commands will be still executed, however bt_ commands will be ignored.

# Block functions (inside a bt_begin/bt_end block)

## bt_echo arg [ ... ]
Print string

## bt_call arg [ ... ]
Call a command. 

## bt_declare subtestname
Declare a subtest, as part of a test (bt_begin/bt_end).

Important: This statement is required with a status function, such as: bt_ok, bt_nok, bt_skip.

## bt_comment arg [ ... ]
Append a command to the testlog. Will not printed, as it is appended to the testlog. Included into bt_summary output.

## bt_ok
Append *ok* status to the testlog.

## bt_ok_fexists filename
Append *ok* status to the testlog, if the specified file exists.

## bt_ok_dexists dirname
Append *ok* status to the testlog, if the specified directory exists.

## bt_nok
Append *not ok* status to the testlog.

## bt_skip reason
Append *skip* status to the testlog, and skip a test (still appending an *ok* status to the testlog).

# Testlog functions

## bt_summary_tap
Print summary of the testlog, using the [TAP](https://testanything.org/) protocol.

## bt_summary
Print summary of the testlog. According to *$BT_PROTOCOL*, the protocol is selected. Will flush the testlog.

# Other functions

## bt_selftest
Call a small selftest of *btest*.

# Author
Murat Ünalan <murat.uenalan@gmail.com>

