# Data retrieval example using Python 3 and parquet output, an ideal way of downloading large
#   files as it is column based and thus allows for per column data compression.

# define URL for the Disaster Declarations Summaries endpoint
baseUrl = "https://www.fema.gov/api/open/v2/DisasterDeclarationsSummaries.parquet"
import requests
import pandas as pd

# location for where the query results are saved
saveLocation = 'python_output.parquet'

def saveLargeQuery(baseUrl, saveLocation):
    try:
        # issue the api call as a stream
        with requests.get(baseUrl, stream=True) as response:
            # raises an exception when there is a server or network error
            response.raise_for_status() 

            # creates a file with if none exists, otherwise overwrites it
            #   we use the 'wb' mode to specify that we are writing as a binary so windows 
            #   does not add unneeded carriage returns
            with open(saveLocation, 'wb') as f:
                print('Saving file')
                for chunk in response.iter_content(): 
                    # we iterate through the chunks and write them to the, you can apply 
                    #   additional processing as well
                    f.write(chunk)
                print('File finished')
    except:
        # any additional logic to do when a request fails, such as trying again goes here
        print(f'file could not be downloaded, server returned ${response.status_code}')    

# Now we can use pandas to verify the record count or further analyze the data
def verifyFileDownload(saveLocation):
    print('Counting Records')
    df = pd.read_parquet(saveLocation)  # We create a dataframe with the file we just saved
    count = df[df.columns[0]].count()   # Here we are counting the number of non null records in the id column
    print('Record Count:', count)

# Run the save method
saveLargeQuery(baseUrl, saveLocation)
verifyFileDownload(saveLocation)