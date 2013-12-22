#!/bin/sh
####################################################################################################
#
# More information: http://macmule.com/2013/12/22/how-to-change-the-apple-software-update-server-sync-interval/
#
# GitRepo: https://github.com/macmule/ChangeASUSSyncInterval/
#
# License: http://macmule.com/license/
#
####################################################################################################

# HARDCODED VALUES ARE SET HERE

# Hour for the launchAgent to be ran on.
launchAgentHour=""

# Minute for the launchAgent to be ran on.
launchAgentMinute=""

# Day for the launchAgent to be ran on.
launchAgentDay=""

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "claunchAgentHour"
if [ "$4" != "" ] && [ "$launchAgentHour" == "" ];then
    launchAgentHour=$4
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "launchAgentMinute"
if [ "$5" != "" ] && [ "$launchAgentMinute" == "" ];then
    launchAgentMinute=$4
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 6 AND, IF SO, ASSIGN TO "launchAgentDay"
if [ "$6" != "" ] && [ "$launchAgentDay" == "" ];then
    launchAgentDay=$4
fi

####################################################################################################

# Error if either variable $4 is empty
if [ "$launchAgentHour" == "" ]; then
	echo "Error:  No value was specified for the launchAgentHour variable..."
	exit 1
fi	

# Error if either variable $5 is empty
if [ "$launchAgentMinute" == "" ]; then
	echo "Error:  No value was specified for the launchAgentMinute variable..."
	exit 1
fi	

####################################################################################################

# Unload com.apple.swupdate.sync.plist
sudo launchctl unload -w /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.sync.plist

# Delete the existing Array
sudo /usr/libexec/PlistBuddy -c "Delete :StartCalendarInterval array" /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.sync.plist

# Write to the plist the Hour the sync is wanted to be run
sudo /usr/libexec/PlistBuddy -c "Add :StartCalendarInterval:Hour integer $launchAgentHour" /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.sync.plist 

# Write to the plist the Minute the sync is wanted to be run
sudo /usr/libexec/PlistBuddy -c "Add :StartCalendarInterval:Minute integer $launchAgentMinute" /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.sync.plist

# If a value is passed to $launchAgentDay then proceed, ignore if not which will make this run daily
if [ -n "$launchAgentDay" ]; then
	# Write to the plist the Day the sync is wanted to be run
	sudo /usr/libexec/PlistBuddy -c "Add :StartCalendarInterval:Weekday integer $launchAgentDay" /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.sync.plist
fi

# Reload com.apple.swupdate.sync.plist
sudo launchctl load -w /Applications/Server.app/Contents/ServerRoot/System/Library/LaunchDaemons/com.apple.swupdate.sync.plist
