#!/bin/bash

# Echo message given in parameter with dynamically calculated number of tabs to align state result...
function echo_string()
{
# Is first parameter set?
if [ -z "${1}" ]; then
	echo "Parameter #1 is zero length"  # Or no parameter passed.
	echo "ERROR: no string given to function echo_string"
	echo "FAIL: aborting"
	exit 1
fi
# Get size of message
msize=${#1}
# Assuming a tab takes the same space as 8 characters
msize=$(( msize / 8 ))
if [ -t 1 ]; then
    tabmax=$(( $(tput cols) / 8 ))
else
# If not running in terminal (ie cron) tput is not usable so we enforce a value
    tabmax=10
fi
# Calculates the number of tabs to add to the line
tabsize=$(( tabmax - msize - 2))
tab=""
for i in $(seq 1 $tabsize);
do
	tab="${tab}	"
done
# Display the message with the tabs
echo -n "${1}"
echo -n "${tab}"
echo -n "[ "
}

# Echo working indicator... (rotating -\|/)
function echo_working()
{
# Is first parameter set?
if [ -z "${1}" ]; then
	echo "Parameter #1 is zero length"  # Or no parameter passed.
	echo "ERROR: no pid given to function echo_working"
	echo "FAIL: aborting"
	exit 1
fi
if [ -t 1 ]; then
    tabmax=$(( $(tput cols) / 8 ))
else
# If not running in terminal (ie cron) tput is not usable so we enforce a value
    tabmax=10
fi
# Calculates the number of tabs to add to the line
tabsize=$(( tabmax - 2  ))
tab=""
for i in $(seq 1 $tabsize);
do
	tab="${tab}	"
done
	sleep 2 &
	spin='-\|/'
	i=0
	while kill -0 "${1}" 2>/dev/null
	do
		i=$(( (i+1) %4 ))
		printf "\r%s %s" "${tab}" "${spin:$i:1}"
		sleep .1
done
printf "\r%s[ " "${tab}"
}

# Begin--

echo_string "Doing some stuff"
{ sleep 5 & } &>/dev/null # "&" runs the command in background and "&>/dev/null" redirects stdout and errors to /dev/null
pid=$! # put the PID of the previous command in var "pid"
echo_working "${pid}" # pass the PID to the function displaying the working indicator
wait "${pid}" # get the error code of the PID...
error=$? # ... and pass it to the "error" var
if [ "${error}" = 0 ]; then
	echo -e "\033[1;32mOK\033[0m ]" # Green OK
else
	echo -e "\033[0;31mFAIL\033[0m ]" # Red FAIL
#	echo -e "\033[1;33mSKIP\033[0m ]" # Yellow SKIP
fi

# --End
