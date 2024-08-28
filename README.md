# btest: Bash Testing Framework

## Description

btest is a lightweight, flexible testing framework for Bash scripts. It provides a simple yet powerful way to organize, execute, and report on tests for shell scripts and command-line tools.

## Features

- Group tests into logical blocks for better organization
- Execute tests as standalone scripts
- Run batches of tests across multiple files or directories
- TAP (Test Anything Protocol) compatible output
- Conditional test execution
- Time tracking for performance analysis
- Detailed reporting and summaries
- Test file generation
- Parallel test execution
- Dry run mode
- Verbose output and configurable log levels

## Installation

```bash
git clone https://github.com/muenalan/btest.git
cd btest
sudo make install
```

## Quick Start

1. Generate a test file:

```bash
btest generate my_first_test
```

2. Edit the generated file `my_first_test.bash`:

```bash
#!/bin/bash

# BT_DIR will be set by btest at runtime

source $BT_DIR/btest.bash

bt_begin "My First Test" 2

  bt_declare "Subtest 1"
  bt_ok_if [[ 2 -eq 2 ]]

  bt_declare "Subtest 2"
  bt_ok_if [[ -f /etc/passwd ]]

bt_end
```

3. Run the test:

```bash
btest file my_first_test.bash
```

## Usage

btest supports a subcommand structure similar to docker:

```
Usage: btest <command> [options]

Commands:
  file       Run tests on specific files
  folder     Run tests on all files in a folder
  generate   Generate a new test file
  status     Show available tests
  help       Display help for a specific command

Global Options:
  -v, --version   Display the version of btest
  -h, --help      Display this help message
```

### Running Tests on Specific Files

```bash
btest file [options] <file1> [file2 ...]

Options:
  -r <reporter>   Specify the reporter to use (default: tap)
  -o <file>       Write output to a file instead of stdout
  -v, --verbose   Enable verbose output
  -l, --loglevel  Set the log level
  -d, --dry-run   Perform a dry run without executing tests

Environment variables:
  BTEST_REPORTER      Set the default reporter
  BTEST_OUTPUT_FILE   Set the default output file
  BTEST_VERBOSE       Set verbose mode (0 or 1)
  BTEST_LOG_LEVEL     Set the default log level
  BTEST_DRY_RUN       Set dry run mode (0 or 1)
```

### Running Tests in Folders

```bash
btest folder [options] <folder1> [folder2 ...]

Options:
  -r <reporter>   Specify the reporter to use (default: tap)
  -o <file>       Write output to a file instead of stdout
  -v, --verbose   Enable verbose output
  -l, --loglevel  Set the log level
  -p, --parallel  Run tests in parallel
  -d, --dry-run   Perform a dry run without executing tests

Environment variables:
  BTEST_REPORTER
```

## Documentation

For detailed usage instructions, API reference, and examples, please see the [full documentation](docs/README.md).

## Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details on how to submit pull requests, report issues, or suggest improvements.

## License

This project is licensed under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.

## Author

Murat Ünalan <murat.uenalan@gmail.com>

## Acknowledgments

Thanks to all contributors and users of btest who have helped improve and shape this project.
