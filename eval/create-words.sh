bzcat tat.rferl.news.20070227-20120310.txt.bz2 tat.wikipedia.2013-02-25.txt.bz2  | apertium -d ~/source/apertium/languages/apertium-tat/ tat-morph | sed 's/\$\W*\^/$\n^/g' > /tmp/tatwords
cat /tmp/tatwords | cut -f2 -d'^' | cut -f1 -d'/' | grep -v '[a-zA-Z]'  | grep -P '\W' | unsort | head -1500 > /tmp/tatwords.1500
