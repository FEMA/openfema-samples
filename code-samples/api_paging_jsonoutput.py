#!/usr/bin/env python3
# Paging example using Python 3. Output in JSON.

# There is now an option to retrieve data without using pagination. The new $allrecords flag forces all records to be
#   returned as part of a download rather than the maximum return limit in order to simplify the download of large sets of data. By
#   default, queries with more results than specified by $top will require pagination. By adding $allrecords=true you can override 
#   this behavior. For more information read openfema-samples/analysis-examples/API_Tutorial_Part_3_PagingToGetData.ipynb

import sys
import urllib.request
import json
import math
from datetime import datetime

# Base URL for this endpoint. Add filters, column selection, and sort order to this.
baseUrl = "https://www.fema.gov/api/open/v1/FemaWebDisasterDeclarations?"

top = 10000      # number of records to get per call, this value was increased from 1000 to 10000 in 2023
skip = 0        # number of records to skip

# Return 1 record with your criteria to get total record count. Specifying only 1
#   column here to reduce amount of data returned. Need inlinecount to get record count. 
webUrl = urllib.request.urlopen(baseUrl + "$inlinecount=allpages&$select=id&$top=1")
result = webUrl.read()
jsonData = json.loads(result.decode())

# calculate the number of calls we will need to get all of our data (using the maximum of 10000). 
recCount = jsonData['metadata']['count']
loopNum = math.ceil(recCount / top)

# send some logging info to the console so we know what is happening
print("START " + str(datetime.now()) + ", " + str(recCount) + " records, " + str(top) + " returned per call, " + str(loopNum) + " iterations needed.")

# Initialize our file. Only doing this because of the type of file wanted. See the loop below.
#   The root json entity is usually the name of the dataset, but you can use any name.
outFile = open("output2.json", "a")
outFile.write('{"femawebdisasterdeclarations":[')

# Loop and call the API endpoint changing the record start each iteration. The metadata is being
#   suppressed as we no longer need it.
i = 0
while (i < loopNum):
    # By default data is returned as a JSON object, the data set name being the root element. Unless
    #   you extract records as you process, you will end up with 1 distinct JSON object for EVERY 
    #   call/iteration. An alternative is to return the data as JSONA (an array of json objects) with 
    #   no root element - just a bracket at the start and end. This is easier to manipulate.
    webUrl = urllib.request.urlopen(baseUrl + "&$metadata=off&$format=jsona&$skip=" + str(skip) + "&$top=" + str(top))
    result = webUrl.read()
    
    # The data is already returned in a JSON format. There is no need to decode and load as a JSON object.
    #   If you want to begin working with and manipulating the JSON, import the json library and load with
    #   something like: jsonData = json.loads(result.decode())

    # Append results to file, trimming off first and last JSONA brackets, adding comma except for last call,
    #   AND root element terminating array bracket and brace to end unless on last call. The goal here is to 
    #   create a valid JSON file that contains ALL the records. This can be done differently.
    if (i == (loopNum - 1)):
        # on the last so terminate the single JSON object
        outFile.write(str(result[1:-1],'utf-8') + "]}")
    else:
        outFile.write(str(result[1:-1],'utf-8') + ",")

    # increment the loop counter and skip value
    i+=1
    skip = i * top

    print("Iteration " + str(i) + " done")

outFile.close()

# lets re-open the file and see if we got the number of records we expected
inFile = open("output2.json", "r")
my_data = json.load(inFile)
print("END " + str(datetime.now()) + ", " + str(len(my_data['femawebdisasterdeclarations'])) + " records in file")
inFile.close()