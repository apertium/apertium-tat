###############################################################################
## Makefile for apertium-tat
###############################################################################

RELEASE=0.2
VERSION=0.2.0
LANG1=tat
BASENAME=apertium-$(LANG1)

TARGETS_COMMON =			\
	$(LANG1).automorf.hfst		\
	$(LANG1).automorf.bin		\
	$(LANG1).automorf.att.gz	\
	$(LANG1).autogen.hfst		\
	$(LANG1).autogen.bin		\
	$(LANG1).autogen.att.gz		\
	$(LANG1).autopgen.bin		\
	$(LANG1).rlx.bin

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################
## Tatar transducer
###############################################################################

.deps/$(LANG1).err.hfst: $(BASENAME).err.twol .deps/.d
	hfst-twolc $< -o $@

.deps/$(LANG1).twol.hfst: $(BASENAME).$(LANG1).twol .deps/.d
	hfst-twolc $< -o $@

.deps/$(LANG1).RL.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v -e 'Dir/LR' -e 'Err/Orth' > $@

.deps/$(LANG1).LR.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v -e 'Dir/RL' > $@

.deps/$(LANG1).EL.lexc: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v -e 'Err/Orth' > $@

.deps/$(LANG1).RL.lexc.hfst: .deps/$(LANG1).RL.lexc
	hfst-lexc --Werror $< -o $@ -v

.deps/$(LANG1).LR.lexc.hfst: .deps/$(LANG1).LR.lexc
	hfst-lexc --Werror $< -o $@ -v

.deps/$(LANG1).EL.lexc.hfst: .deps/$(LANG1).EL.lexc
	hfst-lexc --Werror $< -o $@ -v

.deps/$(LANG1).RL.hfst: .deps/$(LANG1).RL.lexc.hfst .deps/$(LANG1).twol.hfst
	hfst-compose-intersect -1 .deps/$(LANG1).RL.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

# We make an tat.LR.err.hfst by taking the transducer produced from the 
# twol file with error rules (apertium-tat.err.twol), we then remove all the
# strings from that which are in the normative orthography transducer.
# After that we append <err_orth> to the tag string.
.deps/$(LANG1).LR.err.hfst: .deps/$(LANG1).LR.lexc.hfst .deps/$(LANG1).err.hfst .deps/$(LANG1).LR.hfst
# lexc + error model twol
	hfst-compose-intersect -1 .deps/$(LANG1).LR.lexc.hfst -2 .deps/$(LANG1).err.hfst | hfst-minimise -o .deps/$(LANG1).LR.err.hfst.tmp
# extract valid surface forms
	hfst-project -p output .deps/tat.LR.hfst | hfst-minimise -o .deps/$(LANG1).LR.corr.hfst.tmp
# get the valid surface forms that are in the error model
	hfst-invert .deps/$(LANG1).LR.err.hfst.tmp | hfst-compose -1 .deps/$(LANG1).LR.corr.hfst.tmp -2 - | hfst-invert -o .deps/$(LANG1).LR.err.hfst.tmp2
# subtract the valid surface forms from the error model
	hfst-subtract -1 .deps/$(LANG1).LR.err.hfst.tmp -2 .deps/$(LANG1).LR.err.hfst.tmp2 -o .deps/$(LANG1).LR.err.hfst.tmp3
# append the error tag to the error model strings
	echo "<err_orth>:0" | hfst-strings2fst -e 0 -S | hfst-concatenate -1 .deps/$(LANG1).LR.err.hfst.tmp3 -2 - -o $@

# This is the normative transducer, using the standard lexc and the full twol file
.deps/$(LANG1).LR.hfst: .deps/$(LANG1).LR.lexc.hfst .deps/$(LANG1).EL.lexc.hfst .deps/$(LANG1).twol.hfst
	hfst-compose-intersect -1 .deps/$(LANG1).EL.lexc.hfst -2 .deps/$(LANG1).twol.hfst | hfst-minimise -o $@

# The final analyser is a combination of the normative analyser and the error analyser.
$(LANG1).automorf.hfst: .deps/$(LANG1).LR.hfst .deps/$(LANG1).LR.err.hfst
	hfst-union -1 .deps/$(LANG1).LR.hfst -2 .deps/$(LANG1).LR.err.hfst | hfst-invert | hfst-fst2fst -w -o $@

$(LANG1).autogen.hfst: .deps/$(LANG1).RL.hfst
	hfst-fst2fst -w $< -o $@

$(LANG1).autogen.att.gz: $(LANG1).autogen.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

$(LANG1).automorf.att.gz: $(LANG1).automorf.hfst
	hfst-fst2txt $< | gzip -9 -c -n > $@

$(LANG1).autogen.bin: $(LANG1).autogen.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).autogen.att
	lt-comp lr .deps/$(LANG1).autogen.att $@

$(LANG1).automorf.bin: $(LANG1).automorf.att.gz .deps/.d
	zcat < $< > .deps/$(LANG1).automorf.att
	lt-comp lr .deps/$(LANG1).automorf.att $@

$(LANG1).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	lt-comp lr $< $@

###############################################################################
## Debugging transducers (for testvoc)
###############################################################################

debug: .deps/$(LANG1).LR-debug.hfst .deps/$(LANG1).lexc.hfst

.deps/$(LANG1).LR-debug.hfst: $(BASENAME).$(LANG1).lexc .deps/.d
	cat $< | grep -v 'Dir/RL' | grep -v 'Use/Circ' > .deps/$(LANG1).LR-debug.lexc
	hfst-lexc --Werror .deps/$(LANG1).LR-debug.lexc -o .deps/$(LANG1).LR-debug.lexc.hfst -v
	hfst-compose-intersect -1 .deps/$(LANG1).LR-debug.lexc.hfst -2 .deps/$(LANG1).twol.hfst -o $@

.deps/$(LANG1).lexc.hfst: .deps/$(LANG1).RL.lexc.hfst
	hfst-fst2fst -w -i $< -o $@

###############################################################################
## Disambiguation rules
###############################################################################

$(LANG1).rlx.bin: $(BASENAME).$(LANG1).rlx $(CGCOMP)
	$(CGCOMP) $< $@

###############################################################################
## Spell checker
###############################################################################

$(LANG1).zhfst: .deps/acceptor.default.hfst .deps/errmodel.default.hfst
	rm -f $@
	zip -j $@ .deps/acceptor.default.hfst .deps/errmodel.default.hfst speller/index.xml

.deps/errmodel.default.hfst: .deps/words.default.hfst .deps/strings.default.hfst
	python dev/editdist.py -v -s -d 1 -e '@0@' -i speller/editdist.default.txt -a .deps/acceptor.default.hfst \
	| hfst-txt2fst  -e '@0@' -o .deps/editdist.default.hfst
	hfst-disjunct .deps/strings.default.hfst .deps/editdist.default.hfst \
	| hfst-minimise | hfst-repeat -f 1 -t 2 -o .deps/editstrings.default.hfst
	hfst-disjunct .deps/words.default.hfst .deps/editstrings.default.hfst \
	| hfst-fst2fst  -f olw -o $@

.deps/words.default.hfst: speller/words.default.txt
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j -o $@

.deps/strings.default.hfst: speller/strings.default.txt .deps/anystar.hfst
	grep -v -e "^#" -e "^$$" $< | hfst-strings2fst  -j | hfst-concatenate .deps/anystar.hfst - |\
	hfst-concatenate - .deps/anystar.hfst -o $@

.deps/anystar.hfst:
	echo "?*;" | hfst-regexp2fst -S -o $@

.deps/acceptor.default.hfst: $(LANG1).autogen.hfst
	cat $< | hfst-fst2fst -t | hfst-project  --project=lower | hfst-minimise |hfst-fst2fst  -f olw -o $@


###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(LANG1).lexc		\
		$(BASENAME).$(LANG1).twol	\
		$(BASENAME).$(LANG1).rlx	\
		$(BASENAME).post-$(LANG1).dix	\
		$(BASENAME).err.twol			\
		$(LANG1).prob			\
		modes.xml

###############################################################################
## Installation stuff
###############################################################################
#
#   apertium_tat_dir: This is where the compiled binaries go
#   apertium_tat_srcdir: This is where the source files go

apertium_tatdir=$(prefix)/share/apertium/$(BASENAME)/
apertium_tat_srcdir=$(prefix)/share/apertium/$(BASENAME)/

EXTRA_TARGETS=

if HAVE_HFSTOSPELL
EXTRA_TARGETS += $(LANG1).zhfst
endif # HAVE_HFSTOSPELL

apertium_tat_DATA=$(TARGETS_COMMON) $(EXTRA_TARGETS) \
				$(LANG1).prob $(BASENAME).$(LANG1).mb.rlx \
				$(BASENAME).$(LANG1).lexc $(BASENAME).$(LANG1).twol \
				$(BASENAME).$(LANG1).rlx $(BASENAME).post-$(LANG1).dix

pkgconfigdir = $(prefix)/share/pkgconfig
pkgconfig_DATA = $(BASENAME).pc

noinst_DATA=modes/$(LANG1)-morph.mode

install-data-local: install-modes
uninstall-local: uninstall-modes

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	apertium-regtest test

check: all
	cd tests/; bash runall.bash

