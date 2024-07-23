# Data retrieval example using Python 3 with json output. This example utilizes a very simple log file of when the data was last pulled 
#   so that only new or refreshed records are pulled. It stores the entire query in memory before writing it to a file.
#   While this can cause problems with large queries, it should be more than sufficient for most update queries as they should
#   only contain a small subset of the total dataset

import requests
import json
from datetime import datetime
import pytz
import os.path

# A helper function to check our simple log file for the last time we pulled the data
def checkLastRunDate(logfile):
    # Since our log entries are chronological already, the last entry will be the last time we ran the query
    try:
        with open(logfile, 'r') as log:
            logEntries = log.readlines()
            lastEntry = logEntries[-1]
            return lastEntry
    # If the file cannot be found or is empty the last rundate is False and the system will treat it as the first time pulling data
    except:
        return False

# A helper function to compare the dataset lastDatasetRefresh date to the last time we pulled the data
def datasetHasRefreshed(datasetName, datasetVersion, lastRun):
    from datetime import datetime
    from dateutil import parser
     # Define URL for the Data Sets endpoint and a subsequent query
    endpointUrl = baseUrl + "v1/DataSets"
    
    # If lastRun is False then we don't need to know if the dataset has been refreshed since we are pulling the data for the first time
    if(not lastRun):
        return True

    # Create a dictionary to define our parameters
    queryParameters = {
    '$select': 'lastDataSetRefresh',                                                                    # we only need the date
    '$filter': 'name%20eq%20%27' + datasetName + '%27%20and%20version%20eq%20' + str(datasetVersion),   # We only need info on our dataset
    '$metadata': 'off'
    }
    # define the request, read the data, transform to dictionary
    try:
        with requests.get(endpointUrl, queryParameters) as response:
        # Raises an exception when there is a server or network error
            response.raise_for_status()
            lastDatasetRefresh = parser.parse(response.json()['DataSets'][0]['lastDataSetRefresh'])
            lastRunDatetime = parser.parse(lastRun)
            return lastDatasetRefresh > lastRunDatetime
    except Exception as error:
        raise Exception(error) 
    except:
        raise Exception('unable to compare dates')

# Set our variables
datasetName = "DisasterDeclarationsSummaries"
datasetVersion = 2
baseUrl = "https://www.fema.gov/api/open/"
logfile = 'code-samples/api-data-update-samples/py_log.txt'

saveLocation = "code-samples/api-data-update-samples/DDSV2_updates.json"

lastRun = checkLastRunDate(logfile)


# Do comparison
try:
    if (datasetHasRefreshed(datasetName, datasetVersion, lastRun)):
        print("The dataset has been refreshed since the last call. Do stuff.")

        # If there is no previous value for lastRun, then we set it to 0 so that we can pull all data
        if (lastRun == False):
            lastRun = '0'
        
        # Define URL for the endpoint
        endpointUrl = baseUrl + "v" + str(datasetVersion) + "/" + datasetName
        queryParameters = {
            '$format': 'json',                                         # return json
            '$filter': 'lastRefresh%20gt%20%27' + lastRun + '%27',     # define filter, to get all the data the first time, use a date value of "0"
            '$metadata': 'off',                                        # we don't need the metadata
            '$allrecords': 'true'                                      # we want all records without paging
            }

        # Combine url and args and make api call
        with requests.get(endpointUrl, queryParameters) as response:
        # Raises an exception when there is a server or network error
            response.raise_for_status()
            result = response.json()

             # WE HAVE THE DATA, any processing can happen here

            # Let's save to a file: NOTE: we are storing all of the data as a variable that we then write to the file, with the larger datasets, this can cause
            #   memory problems and lead to crashes, but it should be sufficient for pulling update data
            with open(saveLocation, "w") as writefile:
                json.dump(result, writefile )
            
            # Now let's update our log file with today's date as the most recent successful data update
            with open(logfile, "a") as log:
                # Creates a utc timestamp with timezone as a string
                currentDateTime = str(datetime.now(pytz.utc))           
                # If the last run is '0' then this is the first date in the log and doesn't need a new line
                if(lastRun == '0'):
                    log.write(currentDateTime)
                # Writes the new date time to the log on a new line
                else:
                    log.write('\n' + currentDateTime)                    

            # Let's check our file by opening it up again and displaying the count of json records
            with open(saveLocation, "r") as readfile:
                try:
                    my_data = json.load(readfile)
                    print(str(len(my_data['DisasterDeclarationsSummaries'])) + " records in file")
                except Exception as error:
                    print(error)
                except:
                    print("Something went wrong, the records could not be counted")

    # If nothing has been updated, no action needs to be taken
    else:
        print("The dataset has not been refreshed since the last call.")

except Exception as error:
    print(f'ERROR!: {error}')

print("Done")

