
n_fail=`cat apertium-tat.tat.lexc | grep -v '^!' | grep 'гы:.*N1' | tee /tmp/lint-fail.0 | wc -l`;
ex_fail=`head -3 /tmp/lint-fail.0 | tr '\n' '\t'`;
echo -e "$n_fail\t-гы N1\t$ex_fail";

n_fail=`cat apertium-tat.tat.lexc | grep '\([а-я][a-z]\|[а-я][a-z]\)' | tee /tmp/lint-fail.1 | wc -l`;
ex_fail=`head -3 /tmp/lint-fail.1 | tr '\n' '\t'`;
echo -e "$n_fail\tmixed script\t$ex_fail"

rm /tmp/lint-fail.*
