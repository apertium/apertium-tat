LANG=tat
STAMP=$(shell date)
DATE=$(shell date +%Y-%m-%d.%H:%M)
LOG=history.log
SRC=src.1000.txt
REF=ref.1000.txt
TST=tst.1000.txt.$(DATE)
all:
	cat $(SRC) | LANG=ca_AD.utf8 lt-proc -w ../$(LANG).automorf.bin > $(TST)
	echo -ne $(STAMP)"\t" >> $(LOG)
	LANG=ca_AD.utf8 python3 evaluate-morph.py $(TST) $(REF) 2>> $(LOG)
