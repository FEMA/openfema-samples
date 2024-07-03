# The following R code was created to download a full set of data based on one set of criteria. 
#   It was done like this because sometimes users have trouble paging through 60+ million records.
#   So, this breaks the request into more managable, roughly equal chuncks. If you really need
#   the full Policies file, the better approach is to download from the following URL:
#       https://www.fema.gov/about/reports-and-data/openfema/FimaNfipPolicies.csv
# 
#	To download the NFIP policies full file using a paging technique, either modify this code 
#   to cycle through the below filters, or run the code once, changing the filter each time. 
#   Also the default code was written to get data in a json format (this is faster to process 
#   than csv, but more data to download) and save it as an R rds file. Change to what you want.
#
# The filter line that will have to be changed is when the record count is retrieved and also inside
#	the loop where each paging call is performed.
#
# Sample final url: https://www.fema.gov/api/open/v1/FimaNfipPolicies?$filter=policyEffectiveDate%20le%20%272021-03-31%27%20and%20policyTerminationDate%20gt%20%272021-03-31%27&$inlinecount=allpages&$top=10
#
# As of 5/3/2021, here are API criteria along with record counts for the NFIP Policies data set:
# $filter=policyEffectiveDate lt '2010-07-01'						--7,329,017
# $filter=policyEffectiveDate ge '2010-07-01' and policyEffectiveDate lt '2012-01-01'	--7,666,149
# $filter=policyEffectiveDate ge '2012-01-01' and policyEffectiveDate lt '2013-07-01'	--7,257,774
# $filter=policyEffectiveDate ge '2013-07-01' and policyEffectiveDate lt '2015-01-01'	--7,221,958
# $filter=policyEffectiveDate ge '2015-01-01' and policyEffectiveDate lt '2017-01-01'	--8,921,380
# $filter=policyEffectiveDate ge '2017-01-01' and policyEffectiveDate lt '2019-01-01'	--8,881,873
# $filter=policyEffectiveDate ge '2019-01-01' and policyEffectiveDate lt '2021-01-01'	--8,840,536
# $filter=policyEffectiveDate ge '2021-01-01'						--994,966


# Paging example in R. Receiving data in JSON, saving in RDS - a single R object.

require("httr")         # wrapper for curl package - may require installation

# This is a simple JSON parser library (may require installation), but since we are not 
#   really doing JSON manipulation to get the data, this is not needed.
#require("jsonlite") 

# There is now have an option to retrieve data without using pagination. The new $allrecords flag forces all records to be
#   returned as part of a download rather than the maximum return limit in order to simplify the download of large sets of data. By
#   default, queries with more results than specified by $top will require pagination. By adding $allrecords=true you can override 
#   this behavior. For more information read openfema-samples/analysis-examples/API_Tutorial_Part_3_PagingToGetData.ipynb

datalist = list()       # a list that will hold the results of each call

baseUrl <- "https://www.fema.gov/api/open/v1/FimaNfipPolicies?"

# Determine record count. Specifying only 1 column here to reduce amount of data returned. 
#   Remember to add criteria/filter here (if you have any) to get an accurate count.
result <- GET(paste0(baseUrl,"$inlinecount=allpages&$top=1&$select=id"))
jsonData <- content(result)         # should automatically parse as JSON as that is mime type
recCount <- jsonData$metadata$count

# calculate the number of calls we will need to get all of our data (using the maximum of 10000)
# the maximum was changed in 2023 from 1000 to 1000
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