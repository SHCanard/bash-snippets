#!/bin/bash

## Vars declaration

# Name of the program
PROGNAME=$(basename "${0}")
# Labels colors
d1color=219
d2color=81
# Max size of horizontal bars in number of "|" characters
hbmax=$(( $(tput cols) - 60 ))
# Color to start bars with
b1startcolor=214
b2startcolor=76
b3startcolor=100
# Number of colors with start color to use in a bar
palette=6
palette=$(( hbmax / palette ))
palette=$(( palette + 1 ))

## Dummy data values
data1=10
data1max=25
data2=20
data3=30

## Functions declaration

# Handling of errors
function error_handling() # 2 args, 3rd is optionnal
{
# Is first parameter set?
if [ -z "${1}" ]; then
	echo "-Parameter #1 is zero length.-"  # Or no parameter passed.
	echo "ERROR: Can't determine error status of previous command"
	echo "FAIL: Aborting"
	exit 1
fi
if [ -z "${2}" ]; then
# Is second parameter set?
	echo "-Parameter #2 is zero length.-"  # Or no parameter passed.
	echo "WARNING: Can't determine object of error status"
	object="undefined object"
else
	object=${2}
fi
# Is error status different from 0?
if [ "${1}" != 0 ]; then
# It is: something went wrong
	echo "ERROR: It seems something went wrong: ${object}"
	if [ -z "${3}" ]; then
# Exit parameter not defined means no exit of program
		:
	else
# Any other value means exit of program
		echo "FAIL: Aborting"
		exit 1
	fi
fi
}

# Drawing of bar
function bar_drawing() # 2 args
{
# Is first parameter set?
if [ -z "${1}" ]; then
	echo "-Parameter #1 is zero length.-"  # Or no parameter passed.
	echo "ERROR: Can't determine the length of the bar to draw"
	return 1
fi
if [ -z "${2}" ]; then
# Is second parameter set?
	echo "-Parameter #2 is zero length.-"  # Or no parameter passed.
	echo "ERROR: Can't determine the color of the bar"
	return 1
fi
# Loop for drawing the bar
for (( i=0; i<${1}; i++ )); do
	# Calculate the increment to add to the start color to have a nice color pogression
	colorincrement=$(( i / palette ))
	# Calculate the color with the increment
	color=$(( ${2} + colorincrement ))
	# Drow the character with the color
	echo -n -e "\e[38;5;${color}m|\e[0m" # "|" is used as a character to draw bars
done
return 0
}

# Drawing of bar on background
function bar_drawing_on_back () # 4 args
{
# Is first parameter set?
if [ -z "${1}" ]; then
	echo "-Parameter #1 is zero length.-"  # Or no parameter passed.
	echo "ERROR: Can't determine the length of the first bar to draw"
	return 1
fi
if [ -z "${2}" ]; then
# Is second parameter set?
	echo "-Parameter #2 is zero length.-"  # Or no parameter passed.
	echo "ERROR: Can't determine the color of the first bar"
	return 1
fi
if [ -z "${3}" ]; then
# Is second parameter set?
	echo "-Parameter #3 is zero length.-"  # Or no parameter passed.
	echo "ERROR: Can't determine the length of the background"
	return 1
fi
if [ -z "${4}" ]; then
# Is second parameter set?
	echo "-Parameter #4 is zero length.-"  # Or no parameter passed.
	echo "ERROR: Can't determine the color of the background"
	return 1
fi
# Loop for drawing the first bar
for (( i=0; i<${1}; i++ )); do
	# Calculate the increment to add to the start color to have a nice color pogression
	colorincrement=$(( i / palette ))
	# Calculate the color with the increment
	color=$(( ${2} + colorincrement ))
	# Drow the character with the color
	echo -n -e "\e[38;5;${color}m|\e[0m" # "|" is used as a character to draw bars
done
# Loop for drawing the second bar
for (( j=${1}; j<${3}; j++ )); do
	# Calculate the increment to add to the start color to have a nice color pogression
	colorincrement=$(( (j - ${1}) / palette ))
	# Calculate the color with the increment
	color=$(( ${4} + colorincrement ))
	# Drow the character with the color
	echo -n -e "\e[38;5;${color}m-\e[0m" # "-" is used as a character to draw bars
done
return 0
}

## Begin----

# Display nicely values with bars
echo "
Graph title:
"
echo -n -e "| \e[38;5;${d1color}mData1\e[0m		|	"
if [ "${data1max}" != 0 ]; then
	limit=$(( hbmax * data1 / data1max ))
	bar_drawing ${limit} ${b1startcolor}
	error=$?
	error_handling ${error} "drawing text bars"
fi
echo "	${data1}
"

echo -n -e "| \e[38;5;${d2color}mData2\e[0m	    |	"
if [ "${data2}" != 0 ]; then
	limit1=$(( hbmax * data2 / data3 ))
	limit2=$hbmax
	bar_drawing_on_back ${limit1} ${b2startcolor} ${limit2} ${b3startcolor}
	error=$?
	error_handling ${error} "drawing total bars"
fi
echo "	${data2} / ${data3}
"

## ----End
exit 0
