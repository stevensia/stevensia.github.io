find . -name "2016*" -exec awk 'BEGIN{a=0;b=0}/---/{a+=1;next}a<2{print}END{print FILENAME;print "\n"}' {} \; > /tmp/layout.txt

