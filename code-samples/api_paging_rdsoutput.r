# Paging example in R. Receiving data in JSON, saving in RDS - a single R object.

# There is now an option to retrieve data without using pagination. The new $allrecords flag forces all records to be
#   returned as part of a download rather than the maximum return limit in order to simplify the download of large sets of data. By
#   default, queries with more results than specified by $top will require pagination. By adding $allrecords=true you can override 
#   this behavior. For more information read openfema-samples/analysis-examples/API_Tutorial_Part_3_PagingToGetData.ipynb

require("httr")         # wrapper for curl package - may require installation

# This is a simple JSON parser library (may require installation), but since we are not 
#   really doing JSON manipulation to get the data, this is not needed.
#require("jsonlite") 

datalist = list()       # a list that will hold the results of each call

baseUrl <- "https://www.fema.gov/api/open/v2/FemaWebDisasterDeclarations?"

# Determine record count. Specifying only 1 column here to reduce amount of data returned. 
#   Remember to add criteria/filter here (if you have any) to get an accurate count.
result <- GET(paste0(baseUrl,"$inlinecount=allpages&$top=1&$select=id"))
jsonData <- content(result)         # should automatically parse as JSON as that is mime type
recCount <- jsonData$metadata$count

# calculate the number of calls we will need to get all of our data (using the maximum of 10000)
# the maximum was changed in 2023 from 1000 to 10000
top <- 10000
loopNum <- ceiling(recCount / top)

# send some logging info to the console so we know what is happening
print(paste0("START ",Sys.time(),", ", recCount, " records, ", top, " returned per call, ", loopNum," iterations needed."),quote=FALSE)

# Loop and call the API endpoint changing the record start each iteration. Each call will
# return results in a JSON format. The metadata has been suppressed as we no longer need it.
skip <- 0
for(i in seq(from=0, to=loopNum, by=1)){
    # As above, if you have filters, specific fields, or are sorting, add that to the base URL 
    #   or make sure it gets concatenated here.
    result <- GET(paste0(baseUrl,"$metadata=off&$top=",top,"&$skip=",i * top))
    jsonData <- content(result)         # should automatically parse as JSON as that is mime type

    # Here we are adding the resulting JSON return to a list that can be turned into a combined
    #   dataframe later or saved. You may encounter memory limitations with very large datasets.
    #   For those, inserting into a database or saving chunks of data may be desired.
    datalist[[i+1]] <- jsonData

    print(paste0("Iteration ", i, " done)"), quote=FALSE)
}

# binds many items in our list to one data frame
fullData <- dplyr::bind_rows(datalist)

# Save as one R object - probably more useful (and storage efficient) than CSV or JSON if doing
#   analysis within R.
saveRDS(fullData, file = "output.rds")

# open file just to verify that we got what we expect
my_data <- readRDS(file = "output.rds")
print(paste0("END ",Sys.time(), ", ", nrow(my_data), " records in file"))