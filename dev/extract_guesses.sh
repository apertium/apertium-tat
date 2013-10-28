#!/bin/bash


IFS= read -r var

string=`echo $var | hfst-proc ../tat.automorf.hfst | cg-conv -a | vislcg3 --grammar metrics.rlx`;
IFS=$'\n';
for line in $string; do
	guess=`echo $line | grep "guess_"`;
	word=`echo $guess | sed -E 's/.*\"\*(.*)\".*_([A-Z\-]*)/\1:\1 NP-\2 ; ! ""/'`;
	if [ ! "$word" == "" ]; then
		echo $word;
	fi;
done;