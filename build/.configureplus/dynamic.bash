
echo_local_level 1 '$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/'="$CONFIGUREPLUS_DIR_OUT_SESSIONS/$CONFIGUREPLUS_SESSION/"

echo_local_level 1 Updating CONFIGURE/BASH_PROFILE_FILE

configureplus_set CONFIGURE/BASH_PROFILE_FILE "$HOME/.bash_profile"

echo_local_level 1 Updating CONFIGUREPLUS/DIR_CONFIG

configureplus_set CONFIGUREPLUS/DIR_CONFIG    "$HOME/.config/$CONFIGURE_PKG"

echo_local_level 1 Updating CONFIGURE/OSTYPE

configureplus_set CONFIGURE/OSTYPE            "$OSTYPE"

echo_local_level 1 Updating CONFIGURE/MKTEMP

configureplus_set CONFIGURE/MKTEMP            `mktemp -d` 

echo_local_level 1 Updating CONFIGURE/FLAG_TOOL_BTEST

configureplus_set CONFIGURE/FLAG_TOOL_BTEST   `which btest`

echo_local_level 1 Updating CONFIGURE/TIMESTAMP

configureplus_set CONFIGURE/TIMESTAMP         `date`
