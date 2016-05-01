# if [ $(cat test1.txt) == $(cat test2.txt) ]
# then echo "all test ok"
# else -e "wrong"
# fi

test1=$(cat test1.txt)
test2=$(cat test2.txt)

if [ "$test1" = "$test2" ]
then echo "all test ok"
else echo "wrong"
fi



for i in $( ls ); do
    echo item: $i
        done
