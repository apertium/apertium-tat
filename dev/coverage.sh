for f in `find ~/src/turkiccorpora/ -type f -name "tat.*.txt"`; do printf "Corpus: $f\n"; aq-covtest $f tat.automorf.bin; printf "\n"; done > dev/coverage.txt
