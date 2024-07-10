/* Data retrieval example using Node.js, the node fetch api introduced in node v16.15.0, and async/await to return data.
 * The results of the https requests are saved to a CSV file called out.csv. This method stores the full query result in memory
 * before writing it to the file and should not be used with the largest datasets as it can crash if the computer runs out of memory.
 */

const fs = require('fs')

// define the base url
let baseUrl = "https://www.fema.gov/api/open/v2/DisasterDeclarationsSummaries"

// define a query using parameters 
select = "?$select=disasterNumber,declarationDate,declarationTitle,state"    // leave this parameter out if you want all fields
filter = "&$filter=state%20ne%20%27FL%27"                                    // for purposes of example, exclude Florida
orderby = "&$orderby=id"                                                     // order unimportant to me, so use id
format = "&$format=csv"                                                      // set the format to csv
other = "&$allrecords=true&$metadata=off"                                    // return all records, suppress metadata

// set the name of the output file
let csvFile = './out.csv'
// total number of records recorded
let totalDocs = 0

// async function handles all data manipulation
const fetchData = async ()=> {
    try{
        // issue api call
        const res = await fetch(baseUrl + select + filter + orderby + format + other)
        const data = await res.text() // parse as text since csv is not natively supported within node

        // Check results prior to processing
        const status = res.status //get endpoint status
        const isCsv = res.headers.get("content-type").includes('text/csv') //check that the response is a csv file
        if(status == 200 && isCsv){
            // write result to file
            fs.writeFile(csvFile, data, (error)=>{
                // put any additional error handling if the file does not save properly
                if(error){
                    throw(error);
                }
            })
            // log information upon completion
            totalDocs = data.split(/\r\n|\r|\n/).length - 1 //we split the data by record and count rows, subtracting 1 to account for the header
            console.log(`Total Records: ${totalDocs}`);
            console.log(`${csvFile} saved`); // writes a notice to the console upon completion
            
        } else {
            // Error handling for if the endpoint cannot be reached or if the result is not a csv file
            if(!isCsv){
                console.log('file type was not csv, file not saved');
            } else {
                console.error(`file could not be downloaded, server returned ${status}`)
            }
            
        }
    }
    catch(error){
        console.error(error)
    }
}

// run the api call
fetchData()

