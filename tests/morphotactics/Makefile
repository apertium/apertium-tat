# A stub for the makefile which trims the Tatar transducer to prefixes in
# /prefixes and expands trimmed transducers into text files in the current
# directory.
# Was adopted from the apertium-tat-rus makefile.

all: A1.txt

.deps/.d:
	test -d .deps || mkdir .deps
	touch $@

.PRECIOUS: .deps/.d

.deps/A1.prefixes: prefixes/A1.prefix.dix .deps/.d
	lt-comp lr prefixes/A1.prefix.dix .deps/A1.prefix.bin
	lt-print .deps/A1.prefix.bin | sed 's/ /@_SPACE_@/g' > .deps/A1.prefix.att
	hfst-txt2fst -e ε <  .deps/A1.prefix.att > .deps/A1.prefix.hfst
	hfst-project -p upper .deps/A1.prefix.hfst > .deps/A1.prefix.upper
	echo " ?* " | hfst-regexp2fst > .deps/any-symbol.hfst
	hfst-concatenate -1 .deps/A1.prefix.upper -2 .deps/any-symbol.hfst -o $@

A1.txt: ../../tat.automorf.att.gz .deps/A1.prefixes
	zcat $< | hfst-txt2fst > .deps/tat.automorf.hfst
	hfst-compose-intersect -1 .deps/tat.automorf.hfst -2 .deps/A1.prefixes -o .deps/A1.hfst
	hfst-fst2strings .deps/A1.hfst > $@
