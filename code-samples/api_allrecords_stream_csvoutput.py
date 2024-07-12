# Data retrieval example using Python 3 with csv output. This example utilizes the requests 
#   library and data streams so that the entire query does not need to be stored in memory 
#   it is more complicated but well suited for large dataset downloads. 

# define URL for the Disaster Declarations Summaries endpoint
baseUrl = "https://www.fema.gov/api/open/v2/DisasterDeclarationsSummaries"

import requests
import csv

# create a dictionary to define our parameters
queryParameters = {
    '$select': 'disasterNumber,declarationDate,declarationTitle,state',     # leave this parameter out if you want all fields
    '$filter': 'state%20ne%20%27FL%27',                                     # for purposes of example, exclude Florida
    '$orderby': 'id',                                                       # order is unimportant to me, so I am ordering by id
    '$format': 'csv',                                                       # request csv because that's the type we wish to output
    '$allrecords': 'true',                                                  # set $allrecords to true to avoid dealing with pagination
    '$metadata': 'off'
}

# location for where the query results are saved
saveLocation = './out.csv'

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

def verifyCsvDownload(saveLocation):
    try:
        # opens the csv file using 'with/as' syntax which handles the closing of the file when needed
        with open(saveLocation, "r") as csvfile:            
            csv_reader = csv.reader(csvfile)
            next(csv_reader, None)                          # skips the header row
            record_count = sum(1 for row in csv_reader)     # count records
            if(record_count <1):                            # if no records throw an exception
                raise Exception("No data found in the specified file")
        print(f'Record Count: {record_count}')
    except Exception as error:                              # logic for displaying thrown exceptions
        print(error)
    except:                                                 # catch all error when something else goes wrong
        print('The file was unable to be read, there may be something wrong with the file')
        
# Run the dave method
saveLargeQuery(baseUrl, queryParameters, saveLocation)

# Now that we have saved the csv file, we can use our verification method to open it to verify the download 
#   worked and check the total number of records
verifyCsvDownload(saveLocation)