#!/bin/bash
# Paging example using bash. Output in CSV.

# Base URL for this endpoint with $inlinecount set to return total record count. Add 
#   filters, column selection, and sort order to the end of the baseURL
baseUrl='https://www.fema.gov/api/open/v1/FemaWebDisasterDeclarations?$inlinecount=allpages'

# Return 1 record with your criteria to get total record count. Specifying only 1
#   column here to reduce amount of data returned. The backslashes are needed before
#   the API parameters otherwise bash will interpret them as variables. The -s switch
#   in the curl command will suppress its download status information.
result=$(curl -s -H "Content-Type: application/json" "$baseUrl&\$select=id&\$top=1")

# use jq (a json parser) to extract the count - not included in line above for clarity
recCount=$(echo "$result" | jq '.metadata.count')

# calculate the number of calls we will need to get all of our data (using the maximum of 1000)
top='1000'
loopNum=$((($recCount+$top-1)/$top))

# send some logging info to the console so we know what is happening
echo "START "$(date)", $recCount records, $top returned per call, $loopNum iterations needed."

# Loop and call the API endpoint changing the record start each iteration. NOTE: Each call will
# return results in a JSON format along with a metadata object. Returning data in a CSV format 
# will not include the metadata so there is no need to use the $metadata parameter to suppress it.
i=0
skip=0
while [ "$i" -lt $loopNum ]
do
    # Execute API call, skipping records we have already retrieved. NOTE: The curl content type
    #   has been changed. Now we expect csv text not json.
    results=$(curl -s -H 'Content-type: text/csv' "$baseUrl&\$metadata=off&\$format=csv&\$skip=$skip&\$top=$top")

    # Append results to file. NOTE: Quotes around the bash variable being echoed. If this is not
    #   done, record terminators (line feeds) will not be preserved. Each call will result in one
    #   very long line.
    echo "$results" >> "output.csv"
    
    i=$(( i + 1 ))       # increment the loop counter
    skip=$((i * $top))   # number of records to skip on next iteration

    echo "Iteration $i done"
done

# Each call will return data that INCLUDES the field headers. We need to remove these. The
#   following line uses sed (a stream editor program) to do this. The following command uses 
#   a regular expression to find exact matches to the header line and remove them. This can
#   also be done using awk, or by editing the file after the fact - open in a spreadsheet, 
#   sort, and delete the duplicate header lines. NOTE: The -i switch edits the file inline -
#   that is, the original file is permanently altered.
sed -i -r "1h;1!G;/^(.*)\n\1/d;P;D" output.csv

# Use wc command to count the lines in the file to make sure we got what we expected. It 
#   will be 1 line longer because of the field header.
echo "END "$(date)", $(wc -l output.csv) records in file"