export PYTHONPATH=/usr/local/lib/python3.5/site-packages/:$PYTHONPATH

for f in `find ~/src/turkiccorpora/ -type f -name "tat.*.txt"`; do
    printf "Corpus: $f\n"
    aq-covtest $f tat.automorf.bin
    printf "\n";
done > dev/coverage.txt
