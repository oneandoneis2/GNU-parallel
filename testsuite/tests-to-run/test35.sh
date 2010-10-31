#!/bin/bash

rsync -Ha --delete input-files/testdir/ tmp/
cd tmp

SERVER2=parallel@parallel-server2

echo $SERVER2 >~/.parallel/sshloginfile

echo '### Test -W newtempdir/newdir/tmp/ with space dirs'
ssh $SERVER2 rm -rf newtempdir
stdout parallel -k -W newtempdir/newdir/tmp/ --basefile 1-col.txt --trc {}.6 -S .. -v echo ">"{}.6 ::: './ ab/c"d/ef g' ' ab/c"d/efg' ./b/bar ./b/foo "./ ab /c' d/ ef\"g" ./2-col.txt './a b/cd / ef/efg'
# A few rmdir errors are OK as we have multiple files in the same dirs
find . -name '*.6'

echo '### Test -W /tmp/newtempdir/newdir/tmp/ with space dirs'
ssh $SERVER2 rm -rf /tmp/newtempdir
stdout parallel -k -W /tmp/newtempdir/newdir/tmp/ --basefile 1-col.txt --trc {}.7 -S .. -v echo ">"{}.7 ::: './ ab/c"d/ef g' ' ab/c"d/efg' ./b/bar ./b/foo "./ ab /c' d/ ef\"g" ./2-col.txt './a b/cd / ef/efg'
# A few rmdir errors are OK as we have multiple files in the same dirs
find . -name '*.7'

echo '### Test --workdir ...'
parallel -k --workdir ... --basefile 1-col.txt --trc {}.1 -S .. echo ">"{}.1 ::: 2-col.txt
find . -name '*.1'

echo '### Test -W ...'
parallel -k -W ... --basefile 1-col.txt --trc {}.2 -S .. -v echo ">"{}.2 ::: 2-col.txt
find . -name '*.2'

echo '### Test -W ... with space dirs'
stdout parallel -k -W ... --basefile 1-col.txt --trc {}.3 -S .. -v echo ">"{}.3 ::: './ ab/c"d/ef g' ' ab/c"d/efg' ./b/bar ./b/foo "./ ab /c' d/ ef\"g" ./2-col.txt './a b/cd / ef/efg'
# A few rmdir errors are OK as we have multiple files in the same dirs
find . -name '*.3'

echo '### Test -W tmpdir'
parallel -k -W tmpdir --basefile 1-col.txt --trc {}.4 -S .. -v echo ">"{}.4 ::: 2-col.txt
find . -name '*.4'

echo '### Test -W /tmp/ with space dirs'
stdout parallel -k -W /tmp/ --basefile 1-col.txt --trc {}.5 -S .. -v echo ">"{}.5 ::: './ ab/c"d/ef g' ' ab/c"d/efg' ./b/bar ./b/foo "./ ab /c' d/ ef\"g" ./2-col.txt './a b/cd / ef/efg'
# A few rmdir errors are OK as we have multiple files in the same dirs
find . -name '*.5'

cd ..
rm -rf tmp