/* Paging example using Node.js and Javascript promises to make API calls to OpenFEMA via https requests.
 * The results of the https requests are saved to a CSV file called out.csv
 */

const https = require('https');
const fs = require('fs')

let csvFile = './out.csv'
var writeStream = fs.createWriteStream(csvFile, {flags:'a'});
let skip = "skip=0"
let metadataUrl = 'https://tdl.gis.fema.gov/openfema/api/open/v1/DisasterDeclarationsSummaries?$inlinecount=allpages&$top=1'
let url = 'https://tdl.gis.fema.gov/openfema/api/open/v1/DisasterDeclarationsSummaries?$format=csv&$top=1000&$' + skip
let totalDocs = 0
let firstApiCall = true
let csvHeader = ''
let metadataApiCall = true

// function returns a Promise
function getPromise(url) {
    return new Promise((resolve, reject) => {
        https.get(url, (response) => {
            let chunks_of_data = [];
            let arr = [];

            response.on('data', (fragments) => {
                // enter this block to get the total doc count using a call to the api that includes the metadata
                if (totalDocs === 0) {
                    arr = fragments.toString().split(",") // isolate count from metadata
                    totalDocs = parseInt(arr[2].slice(8), 10) // parse count into numerical value
                }
                // enter this block to write the csv header
                if (firstApiCall && !metadataApiCall) {
                    csvHeader = fragments.toString();
                    chunks_of_data.push(fragments);
                    firstApiCall = false
                }
                // prevents csv header from being written with every api request
                if (!firstApiCall && totalDocs > 0 && fragments.toString() !== csvHeader) {
                    chunks_of_data.push(fragments);
                }
            });

            response.on('end', () => {
                let response_body = Buffer.concat(chunks_of_data);
                resolve(response_body.toString());
                metadataApiCall = false
            });

            response.on('error', (error) => {
                reject(error);
            });
        });
    });

// async function to make http request
async function makeSynchronousRequest(url) {
    try {
        let http_promise = getPromise(url);
        let response_body = await http_promise;

        // holds response from server that is passed when Promise is resolved
        writeStream.write(response_body)
    }
    catch(error) {
        // Promise rejected
        console.log(error);
    }

// anonymous async function to execute some code synchronously after http request
(async function () {
    if (totalDocs === 0) {
        await makeSynchronousRequest(metadataUrl);
        console.log("Total Expected Documents: " + totalDocs)
    }

    writeStream.write(csvHeader)

    let skipCount = 0
    // wait to http request to finish
    do {
        await makeSynchronousRequest(url);
        // below code will be executed after http request is finished
        skipCount += 1000
        url = url.replace(skip, "skip=" + skipCount);
        skip = "skip=" + skipCount
    } while (skipCount < totalDocs)
    console.log("Finished writing to file")
    getTotalRows()
})();

/**
 * Calculates the number of rows in out.csv file.
 * This is done to make sure the number of rows in out.csv equals the number of expected rows.
 */
function getTotalRows(){
    var i;
    var numRows = 0;
    require('fs').createReadStream(csvFile)
        .on('data', function(chunk) {
            for (i=0; i < chunk.length; ++i)
                if (chunk[i] == 10) numRows++; // 10 is th ascii character for a new line which indicates a row
        })
        .on('end', function() {
            console.log("Total documents written to file ", numRows - 1);// we subtract 1 to account for the header
        });
