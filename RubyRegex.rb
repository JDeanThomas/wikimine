
# revmove lines ending with "(UTC)"
ruby -i.bak -ne 'print if not /\(UTC\)$/' sample.txt

# remove lines that begin with whitespace or end with punctuation 
ruby -i.bak -ne 'print if /^\s+|[[:punct:]]$/' sample.txt 

[.?!]$

# remove any lines contaning "[Mm]ay refer to:"
ruby -i.bak -ne 'print if not /([Mm]ay)\s(refer)\s(to)[:]$/' colon.txt

# remove "In:Out:"
ruby -i.bak -ne 'print if not /(In[:]Out[:])$/' colon.txt

# remove lodged update records
# removed any line with "[Uu]pdate" that ends with :
ruby -i.bak -ne 'print if not /([Uu]pdate)/ && /[:]$/' colon.txt



grep -v '[^:]$' sample.txt > colon.txt

awk '{gsub(("?<![A-Z][a-z])([!?.])(?=[[:space:]][A-Z])[[:space:]]*",".\n");print}' news.txt

sed -e '?<![A-Z][a-z])([!?.])(?=[[:space:]][A-Z])[[:space:]]*' -e 's/\.$/.\n/g' news.txt

awk '{gsub('?<![A-Z][a-z])([!?.])(?=[[:space:]][A-Z])[[:space:]]*',".\n");print}' news.txt > news2.txt

sed '?<![A-Z][a-z])([!?.])(?=[[:space:]][A-Z])[[:space:]]* */.\
/g'