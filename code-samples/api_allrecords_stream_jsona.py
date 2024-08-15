# Data retrieval example using Python 3 with JSON Array (jsona) output which allows each item to be
#   returned as a JSON object inside of an array instead of as one large JSON object. This example 
#   utilizes the requests library and data streams so that the entire query does not need to be stored 
#   in memory it is more complicated but well suited for large dataset downloads. 

# define URL for the Disaster Declarations Summaries endpoint
baseUrl = "https://www.fema.gov/api/open/v2/DisasterDeclarationsSummaries"

import requests
import json

# create a dictionary to define our parameters
queryParameters = {
    '$select': 'disasterNumber,declarationDate,declarationTitle,state',     # leave this parameter out if you want all fields
    '$filter': 'state%20ne%20%27FL%27',                                     # for purposes of example, exclude Florida
    '$orderby': 'id',                                                       # order is unimportant to me, so I am ordering by id
    '$format': 'jsona',                                                       # request csv because that's the type we wish to output
    '$allrecords': 'true',                                                  # set $allrecords to true to avoid dealing with pagination
    '$metadata': 'off'
}

# location for where the query results are saved
saveLocation = './out.json'

def saveLargeQuery(baseUrl, queryParameters, saveLocation):
    try:
        # issue the api call as a stream
        with requests.get(baseUrl, params=queryParameters, stream=True) as response:
            # raises an exception when there is a server or network error
            response.raise_for_status() 

            # creates a file with if none exists, otherwise overwrites it
            #   we use the 'wb' mode to specify that we are writing as a binary so windows 
            #   does not add unneeded carriage returns
            with open(saveLocation, 'wb') as f:
                for chunk in response.iter_content(): 
                    # we iterate through the chunks and write them to the, you can apply 
                    #   additional processing as well
                    f.write(chunk)
                print('File finished')
    except:
        # any additional logic to do when a request fails, such as trying again goes here
        print(f'file could not be downloaded, server returned ${response.status_code}')

def verifyFileDownload(saveLocation):
    with open(saveLocation, "r") as readfile:
        try:
            my_data = json.load(readfile)
            print(str(len(my_data)) + " records in file")
        except Exception as error:
            print(error)
        except:
            print("Something went wrong, the records could not be counted")
        
# Run the dave method
saveLargeQuery(baseUrl, queryParameters, saveLocation)

# Now that we have saved the csv file, we can use our verification method to open it to verify the download 
#   worked and check the total number of records
verifyFileDownload(saveLocation)