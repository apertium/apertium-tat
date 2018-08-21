#!/usr/bin/env bash

for test in tests/morphophonology/new.yaml ; do
    /usr/local/bin/aq-morftest -i "$test" > /dev/null
    if [ $? -eq 0 ]; then
        echo "$test passed"
    else echo "$test failed"
        exit 1
    fi ;
done
exit 0
