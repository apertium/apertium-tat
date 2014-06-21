#!/bin/bash

# Takes the basename of the test scrpt in /test-scripts as an argument,
# an additional argument if the test script requires it, and runs the test.
#
# Usage: ./qa.sh (will default to './qa.sh tat')

if [ $# -eq 0 ]
then
    testToRun=tat.test
else
    testToRun=$1.test
fi

bash "test-scripts/$testToRun" "$2"
