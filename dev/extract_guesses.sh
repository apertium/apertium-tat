#!/bin/bash


while IFS= read -r line; do
	string=`echo $line | hfst-proc ../tat.automorf.hfst | cg-conv -a 2>/dev/null | vislcg3 --grammar metrics.rlx`;
	IFS=$'\n';
	for fooline in $string; do
		guess=`echo $fooline | grep "guess_"`;
		word=`echo $guess | sed -E 's/.*\"\*(.*)\".*_([A-Z\-]*)/\1:\1 NP-\2 ; ! ""/'`;
		if [ ! "$word" == "" ]; then
			echo $word;
		fi;
	done;
done;