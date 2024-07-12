# Data retrieval example using Python 3 with json output. This example utilizes the urllib 
#   library and $allrecords, storing the entire query in memory before writing it to a file 
#   it is simpler however may crash if there is insufficient memory, especially with the largest datasets
#   when handling large amounts of data look at one of the code examples with streaming instead

import urllib.request
import json

# define URL for the Disaster Declarations Summaries endpoint
baseUrl = "https://www.fema.gov/api/open/v2/DisasterDeclarationsSummaries"

# define a query using parameters 
select = "?$select=disasterNumber,declarationDate,declarationTitle,state"    # leave this parameter out if you want all fields
filter = "&$filter=state%20ne%20%27FL%27"                                    # for purposes of example, exclude Florida
orderby = "&$orderby=id"                                                     # order unimportant to me, so use id
format = "&$format=json"    
other = "&$allrecords=true&$metadata=off"                                    # return all records, suppress metadata

# location for where the query results are saved
saveLocation = './out.json'

# issue api call
request = urllib.request.urlopen(baseUrl + select + filter + orderby + format + other)
result = request.read()
    
# The data is already returned in a json format. There is no need to decode and load as a JSON object.
#   If you want to begin working with and manipulating the JSON, import the json library and load with
#   something like: jsonData = json.loads(result.decode())

# save to file: NOTE: this example saves all records to a variable, this is faster and works well for smaller querries, 
#   with the larger datasets, this can cause memory problems and lead to crashes
with open(saveLocation, "w") as writefile:
    writefile.write(str(result,'utf-8'))


# lets re-open the file and see if we got the number of records we expected
with open(saveLocation, "r") as readfile:
    try:
        my_data = json.load(readfile)
        print(str(len(my_data['DisasterDeclarationsSummaries'])) + " records in file")
    except Exception as error:
        print(error)
    except:
        print("Something went wrong, the records could not be counted")
