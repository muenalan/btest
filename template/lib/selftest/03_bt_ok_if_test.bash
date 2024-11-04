#!/bin/bash

source $BT_OPT_DIR/btest.bash

: <<'=cut'
=head1 NAME

bt_ok_if - Conditional test wrapper with visual feedback

=head1 SYNOPSIS

    bt_ok_if [ -f file.txt ] "Config file exists"
    bt_ok_if command -v git "Git is installed"
    
    if bt_ok_if [ -d /tmp ] "Temp directory exists"; then
        echo "Proceeding..."
    fi

=head1 DESCRIPTION

The bt_ok_if function provides a user-friendly wrapper around bash conditional tests,
displaying visual feedback with colored symbols and custom messages. It accepts
conditions in natural bash syntax without requiring quotes.

=head1 ARGUMENTS

=over 4

=item B<condition>

A bash conditional expression or command that returns an exit status.
Written in natural syntax without quotes.

=item B<message>

The last argument is used as the status message.

=back

=head1 RETURN VALUE

Returns 0 (success) if the condition is true, 1 (failure) if false.

=head1 EXAMPLES

    # Basic file operations
    bt_ok_if [ -f /etc/hosts ] "System hosts file exists"
    bt_ok_if [ -d /tmp ] "Temp directory exists"
    bt_ok_if [ -x /usr/bin/python ] "Python is executable"

    # Command availability checks
    bt_ok_if command -v git "Git is installed"
    bt_ok_if which python3 "Python 3 is in PATH"

    # User and permission checks
    bt_ok_if [ $(whoami) = root ] "Running as root"
    bt_ok_if [ -w /var/log ] "Log directory is writable"

    # Pattern matching and grep
    bt_ok_if grep -q something file.txt "Pattern found in file"

    # Using in conditional statements
    if bt_ok_if [ -d /tmp ] "Temp directory exists"; then
        echo "Proceeding with operation..."
    fi

    # Multiple conditions
    bt_ok_if [ -f config.ini ] && [ -r config.ini ] "Config is readable"

=head1 bash code

function bt_ok_if() {
    # Get the last argument as the message
    local message="${@: -1}"
    # Get all but the last argument as the condition
    local condition=("${@:1:$#-1}")
    
    if "${condition[@]}"; then
        echo -e "\e[32m✓ OK\e[0m - $message"
        return 0
    else
        echo -e "\e[31m✗ FAIL\e[0m - $message"
        return 1
    fi
}

=cut


function bt_selftest
{
    bt_begin bt_ok_if_1 1 

      bt_declare bt_ok_if_1

      bt_ok_if [ 1 ] "$BT_TITLE1"

    bt_end

    bt_begin bt_ok_if_0 1 

      bt_declare bt_ok_if_0

      bt_ok_if [ 0 ] "$BT_TITLE1"

    bt_end


}

bt_selftest



