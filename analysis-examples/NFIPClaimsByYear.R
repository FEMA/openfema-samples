# The following R code was created to answer a user question - show a count of claims 
# for each year from 2010-2022. Four techniques are shown, each having different benefits
# and performance. NOTE: Don't simply run this entire program. Pick one of the methods
# and comment the others out. For speed, Method 4 is prefered.

library(httr)       # wrapper for curl package - may require installation
library(jsonlite)   # simple JSON parser library - may require installation

# if you are behind a proxy, uncomment these lines and replace the domain name/ip
#Sys.setenv(http_proxy="http://xxx.xxx.xxx:80")
#Sys.setenv(https_proxy="http://xxx.xxx.xxx:80")

my_dict <- list()   # a list that will hold the results of the API call

#=========================================================================================
# Method 1 - fetch all data for each year between 2010 and 2022. While this is simple,
# it pulls a ton of unnecessary data just to do a count. Run took 10 minutes.
#=========================================================================================
start_time <- Sys.time()
# loop through the desired years
for (year in 2010:2022){
  # compose a key string for our dictionary
  key <- paste0("year_", year)

  # base API endpoint URL
  base <- 'https://www.fema.gov/api/open/v2/FimaNfipClaims?$top=0'

  # may be nice to know the total records found for which our criteria applies - note,
  # this can slow the retrieval of data as it forces the server to count the records
  rec_count <- '&$inlinecount=allpages'

  # compose the filter for this year (yearOfLoss = specified year) for final API call
  filtering <- '&$filter='
  year_date <- paste0('yearOfLoss%20eq%20',year)
  API_URL <- paste0(base, rec_count, filtering, year_date)
  
  # fetch the data, converting raw content to characters and then to a data frame
  raw_data <- GET(API_URL)
  jsonData <- fromJSON(rawToChar(raw_data$content), flatten = TRUE)
  
  # count the rows in the data frame and assign to an element in our dictionary
  my_dict[[key]] <- nrow(jsonData$FimaNfipClaims)
  
  print(paste0("Year ", year, " complete."))
}

#=========================================================================================
# Method 2 - fetch only one field for each year between 2010 and 2022. 
# Turn off $inlinecount and return of metadata. Run took 1 minute.
#=========================================================================================
start_time <- Sys.time()
# loop through the desired years
for (year in 2010:2022){
  # compose a key string for our dictionary
  key <- paste0("year_", year)

  # base API endpoint URL - turning off metadata and returning only one field
  base <- 'https://www.fema.gov/api/open/v2/FimaNfipClaims?$top=0&$select=id&$metadata=off'

  # compose the filter for this year (yearOfLoss = specified year) for final API call
  filtering <- '&$filter='
  year_date <- paste0('yearOfLoss%20eq%20',year)
  API_URL <- paste0(base, filtering, year_date)
  
  # fetch the data, converting raw content to characters and then to a data frame
  raw_data <- GET(API_URL)
  jsonData <- fromJSON(rawToChar(raw_data$content), flatten = TRUE)
  
  # count the rows in the data frame and assign to an element in our dictionary
  my_dict[[key]] <- nrow(jsonData$FimaNfipClaims)
  
  print(paste0("Year ", year, " complete."))
}

#=========================================================================================
# Method 3 - fetch the year and id for every year using the API $filter. Aggregrate or
# perform a "group by" using the data frame. Turn off $inlinecount and return of metadata.
# This essentially saves 12 calls to the API, but we must return a little more data than
# above. Does not save us much time but reduces the lines of code. Run took 50 seconds.
#=========================================================================================
start_time <- Sys.time()
# base API endpoint URL - get all records and 2 fields
base <- 'https://www.fema.gov/api/open/v2/FimaNfipClaims?$top=0&$metadata=off&$select=id,yearOfLoss'

# compose the filter for range of years for final API call
filtering <- '&$filter=yearOfLoss%20ge%202010%20and%20yearOfLoss%20le%202022'
API_URL <- paste0(base, filtering)
  
# fetch the data, converting raw content to characters and then to a data frame
raw_data <- GET(API_URL)
jsonData <- fromJSON(rawToChar(raw_data$content))

# use aggregate function to group by yearOfLoss and count the id's/records
x <- aggregate(jsonData$FimaNfipClaims$id ~ jsonData$FimaNfipClaims$yearOfLoss, jsonData, length)
  
print(x)

#=========================================================================================
# Method 4 - fetch only the metadata data for each year between 2010 and 2022, limiting to 
# one record and one field. Use the "count" from the metadata for results. The fastest.
# Run took 11 seconds.
#=========================================================================================
start_time <- Sys.time()
# loop through the desired years
for (year in 2010:2022){
  # compose a key string for our dictionary
  key <- paste0("year_", year)

  # base API endpoint URL - get only 1 record and 1 field
  base <- 'https://www.fema.gov/api/open/v2/FimaNfipClaims?$top=1&$select=id'

  # While this can slow the retrieval of data as it forces the server to count the records,
  # we are essentially using the API to do the counting work for us. No need to convert a 
  # bunch of records to a data frame and count. Just look at the metadata object.
  rec_count <- '&$inlinecount=allpages'

  # compose the filter for this year (yearOfLoss = specified year) for final API call
  filtering <- '&$filter='
  year_date <- paste0('yearOfLoss%20eq%20',year)
  API_URL <- paste0(base, rec_count, filtering, year_date)
  
  # fetch the data, converting raw content to characters and then to a data frame
  raw_data <- GET(API_URL)
  jsonData <- fromJSON(rawToChar(raw_data$content))

  # store the metadata count to an element in our dictionary
  my_dict[[key]] <- jsonData$metadata$count
  
  print(paste0("Year ", year, " complete."))
}


# display results
print(my_dict)
end_time <- Sys.time()
print(end_time - start_time)