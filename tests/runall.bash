#!/usr/bin/env bash

alltestspass=true

cd morphophonology/; python3 test.py tat
if [ $? -ne 0 ] ; then
    alltestspass=false
fi

cd ../coverage/; bash test.bash
if [ $? -ne 0 ] ; then
   alltestspass=false
fi

if [ $alltestspass = "true" ] ; then
    exit 0
else
    exit 1
fi
