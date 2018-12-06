wget https://dumps.wikimedia.org/ttwiki/20181201/ttwiki-20181201-pages-articles-multistream.xml.bz2
wget https://svn.code.sf.net/p/apertium/svn/trunk/apertium-tools/WikiExtractor.py -O WikiExtractor.py
python3 WikiExtractor.py --infn ttwiki-20181201-pages-articles-multistream.xml.bz2
grep -o "[^ ]\+" wiki.txt | grep -v "[a-zA-Z]" | grep -v "*" | sort | uniq > /tmp/hit

cat /tmp/hit | apertium -d . tat-morph | grep "*" > /tmp/unk_now
git checkout HEAD^
make
cat /tmp/hit | apertium -d . tat-morph | grep "*" > /tmp/unk_before

unknow="$(wc -l /tmp/unk_now | cut -d ' ' -f1)"
unkbefore="$(wc -l /tmp/unk_now | cut -d ' ' -f1)"
covnow="$(calc "$(wc -l /tmp/unk_now | cut -d ' ' -f1) / $(wc -l /tmp/hit | cut -d ' ' -f1) * 100")"
covbefore="$(calc "$(wc -l /tmp/unk_before | cut -d ' ' -f1) / $(wc -l /tmp/hit | cut -d ' ' -f1) * 100")"

if [ "$unknow" -le "$unkbefore" ]
then
    echo "PASS!"
    echo "Coverage before: ${covbefore}"
    echo "Coverage now: ${covnow}"
    exit 0
else
    echo "FAIL!"
    echo "Coverage before: ${covbefore}"
    echo "Coverage now: ${covnow}"
    exit 1
fi
