# A stub for the makefile which trims the Tatar transducer to prefixes in
# /prefixes and expands trimmed transducers into text files in the cd.
# Was adopted from the apertium-tat-rus makefile.

# given that we use dix format for prefixes
.deps/A1.prefixes: prefixes/A1.prefix.dix
	lt-comp lr prefixes/A1.prefix.dix .deps/A1.prefix.bin
	lt-print .deps/A1.prefix.bin | sed 's/ /@_SPACE_@/g' > .deps/A1.prefix.att
	hfst-txt2fst -e ε <  .deps/A1.prefix.att > .deps/A1.prefix.hfst
	hfst-project -p upper .deps/A1.prefix.hfst > .deps/A1.prefix.upper
	echo " ?* " | hfst-regexp2fst > .deps/any-symbol.hfst
	hfst-concatenate -1 .deps/A1.prefix.upper -2 .deps/any-symbol.hfst -o .deps/A1.prefixes

A1.txt: ../../tat.automorf.att.gz .deps/A1.prefixes
	zcat $< | hfst-txt2fst > .deps/tat.automorf.hfst
	hfst-compose-intersect -1 .deps/tat.automorf.hfst -2 .deps/A1.prefixes -o .deps/A1.hfst
	hfst-fst2strings .deps/A1.hfst > $@

# given that we use lexc format for prefixes
# (this would free us from the lt-comp | lt-print | hfst-txt2fst commands above.
# It's hfst transducers which get intersected, so probably better idea to store
# prefixes in a lexc file and compile them into hfst transducers directly).
