# configure_package
Example package

# Description
An example package dynamically generated with configureplus.

# INSTALL
You can install it only locally for the user (userprofile), or system-wide.

## INSTALL userprofile (darwin19)

    $ echo $OSTYPE >.configure/global/CONFIGUREPLUS_SESSION
    $ ./bin/configureplus
    $ make install
      .. installing userprofile

    $ make uninstall
      .. uninstalling userprofile

## INSTALL systemwide (darwin19)

    $ echo $OSTYPE >.configure/global/CONFIGUREPLUS_SESSION
    $ ./bin/configureplus
    $ sudo make install-systemwide
      .. installing systemwide

# SYNOPSIS
