#!/bin/bash
# Paging example using bash. Output in JSON.

baseUrl='https://www.fema.gov/api/open/v2/FemaWebDisasterDeclarations?$inlinecount=allpages'

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

# Initialize our file. Only doing this because of the type of file wanted. See the loop below.
#   The root json entity is usually the name of the dataset, but you can use any name.
echo '{"femawebdisasterdeclarations":[' >> output.json

# Loop and call the API endpoint changing the record start each iteration. NOTE: Each call will
# return the metadata object along with the results. This should be striped off before appending 
# to the final file or use the $metadata parameter to suppress it.
i=0
skip=0
while [ "$i" -lt $loopNum ]
do
    # Execute API call, skipping records we have already retrieved, excluding metadata header, in jsona.
    # NOTE: By default data is returned as a JSON object, the data set name being the root element. Unless
    #   you extract records as you process, you will end up with 1 distinct JSON object for EVERY call/iteration.
    #   An alternative is to return the data as JSONA (an array of json objects) with no root element - just
    #   a bracket at the start and end. Again, one bracketed array will be returned for every call. Since I
    #   want 1 JSON array, not many, I have stripped off the the closing bracket and added a comma. For the
    #   last iteration, do not add a comma and terminate the object with a bracket and brace. This certainly
    #   can be done differently, it just depends on what you are ultimately trying to accomplish.
    results=$(curl -s -H "Content-Type: application/json" "$baseUrl&\$metadata=off&\$format=jsona&\$skip=$skip&\$top=$top")

    # append results to file - the following line is just a simple append
    #echo $results >> "output.json"
    
    # Append results to file, trimming off first and last JSONA brackets, adding comma except for last call,
    #   AND root element terminating array bracket and brace to end unless on last call. The goal here is to 
    #   create a valid JSON file that contains ALL the records. This can be done differently.
    if [ "$i" -eq "$(( $loopNum - 1 ))" ]; then
        # on the last so terminate the single JSON object
        echo "${results:1:${#results}-2}]}" >> output.json
    else
        echo "${results:1:${#results}-2}," >> output.json
    fi

    i=$(( i + 1 ))       # increment the loop counter
    skip=$((i * $top))   # number of records to skip on next iteration

    echo "Iteration $i done"
done
# use jq to count the JSON array elements to make sure we got what we expected
echo "END "$(date)", $(jq '.femawebdisasterdeclarations | length' output.json) records in file"