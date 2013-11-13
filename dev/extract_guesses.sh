#!/bin/bash

APERTIUMPATH=~/apertium

while IFS= read -r line; do
	string=`echo $line | lt-proc $APERTIUMPATH/languages/apertium-tat/tat.automorf.bin | cg-conv -a 2>/dev/null | vislcg3 --grammar $APERTIUMPATH/languages/apertium-tat/dev/metrics.rlx`;
	IFS=$'\n';
	for fooline in $string; do
		guess=`echo $fooline | grep "guess_"`;
		word=`echo $guess | sed -E 's/.*\"\*(.*)\".*_([A-Z\-]*)/\1:\1 NP-\2 ; ! ""/'`;
		if [ ! "$word" == "" ]; then
			echo $word $line;
		fi;
	done;
done;