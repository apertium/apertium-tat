# A stub for the makefile which trims the Tatar transducer to prefixes in
# /prefixes and expands trimmed transducers into text files in the current
# directory.
# Was adopted from the apertium-tat-rus makefile.

all: A1.txt V-TV-IR.txt

.deps/.d:
	test -d .deps || mkdir .deps
	touch $@

.PRECIOUS: .deps/.d



.deps/%.prefix.bin: prefixes/%.prefix.dix .deps/.d
	lt-comp lr $< $@

.deps/%.prefix.att: .deps/%.prefix.bin
	lt-print $< | sed 's/ /@_SPACE_@/g' > $@

.deps/%.prefix.hfst: .deps/%.prefix.att
	hfst-txt2fst -e ε < $< > $@

.deps/%.prefix.upper: .deps/%.prefix.hfst
	hfst-project -p upper $< > $@

.deps/any-symbol.hfst:
	echo " ?* " | hfst-regexp2fst > $@

.deps/%.prefixes: .deps/%.prefix.upper .deps/any-symbol.hfst
	hfst-concatenate -1 $< -2 .deps/any-symbol.hfst -o $@

.deps/tat.automorf.hfst: ../../tat.automorf.att.gz
	zcat $< | hfst-txt2fst > $@

.deps/%.hfst: .deps/%.prefixes .deps/tat.automorf.hfst 
	hfst-compose-intersect -1 .deps/tat.automorf.hfst -2 $< -o $@

%.txt: .deps/%.hfst
	hfst-fst2strings $< > $@
