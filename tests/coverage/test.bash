#!/usr/bin/env bash

## Test current coverage of tat-morph on frequency list and compare it
## to coverage of last version of tat-morph. Return success if the
## coverage  hasn't decreased, fail otherwise.
##
## By `last version' we mean:
## - HEAD if apertium-tat.git repo has local changes
## - HEAD~1 if it doesn't (when testing via `make check' is done on travis)
##
## Frequency list is a tsv file, first two fields of which are:
## - frequency
## - wordform
##
## Frequency list is not tracked in the repository. It is fetched from a URL
## given in the frequency_list.url.txt file.

if [ ! -f frequency_list.tsv ]; then
    wget -i frequency_list.url.txt -O frequency_list.tsv.bz2
    bzip2 -dk frequency_list.tsv.bz2
fi

FREQ_LIST=$(realpath frequency_list.tsv)

LAST=$(mktemp -d /tmp/XXXXX)

cp -r ../../ ${LAST}

pushd ${LAST}

git diff-index --quiet HEAD --
if [ $? -eq 0 ]; then
    git reset --hard HEAD~1
else
    git reset --hard HEAD
fi

popd

unrecognized () {
    ## monolingpackagedir textfile -> number
    pushd $1 > /tmp/log 2>&1
    ./autogen.sh >> /tmp/log 2>&1
    make clean >> /tmp/log 2>&1
    make >> /tmp/log 2>&1
    cat $2 | apertium -d . tat-morph | grep -c "*"
    popd >> /tmp/log 2>&1
}

if [ $(unrecognized ../../ ${FREQ_LIST}) -le  $(unrecognized ${LAST} ${FREQ_LIST}) ]; then
    printf "Success!\n"
    exit 0
else
    printf "Fail!\n"
    exit 1
fi
