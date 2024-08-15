/* This example is identical to the regular json streaming data example except that it
 * returns the file with the JSON Array (jsona) file format which allows for each item
 * to be returned as an individual json object. This is good for streaming data as it can
 * faciliate chunking and streaming data, however if the stream is lost mid entry, there can
 * be data loss
 */

const fs = require("fs");

// define the base url
let baseUrl = "https://www.fema.gov/api/open/v2/DisasterDeclarationsSummaries";

// define a query using parameters
select = "?$select=disasterNumber,declarationDate,declarationTitle,state"; // leave this parameter out if you want all fields
filter = "&$filter=state%20ne%20%27FL%27"; // for purposes of example, exclude Florida
orderby = "&$orderby=id"; // order unimportant to me, so use id
format = "&$format=jsona"; // set the format to json, json is the default format
other = "&$allrecords=true&$metadata=off"; // return all records, suppress metadata

let jsonFile = "./out.json"; // set the name of the output file
const  writeStream = fs.createWriteStream(jsonFile); // set up the file to receive streaming data, if file exists, overwrites it

// async function handles all data manipulation
const saveStreamingData = async () => {
  try {
    // issue api call
    const response = await fetch(
      baseUrl + select + filter + orderby + format + other
    );
    // if the response is not ok, abort
    if (!response.ok) {
      throw new Error(
        `file could not be downloaded, server returned ${response.status}`
      );
    }

    for await (const chunk of response.body) {
      const decoder = new TextDecoder("utf-8");
      let data = decoder.decode(chunk);
      writeStream.write(data)
    }
    writeStream.end()
  } catch(error) {
    console.error(error)
  }
  finally{
    console.log('file successfully saved')
    // lets check the file 
    fs.readFile(jsonFile, (error, data)=>{ // read the file we just created
        if(error){ // log any errors with reading the file and stop
            console.error(error)
            return
        }
        const fileData = JSON.parse(data) 
        const recordCount = fileData.length // count how many records are returned
        console.log(`Record Count: ${recordCount}`);
    })
  }
};

// run the api call
saveStreamingData();
