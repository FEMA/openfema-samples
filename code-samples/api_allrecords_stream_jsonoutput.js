/* Data retrieval example using Node.js, the node fetch api introduced in node v16.15.0. This example takes advantage of browser support
 * for streaming data to process larger files. The results of the https requests are saved to a JSON file called out.json.
 */

const fs = require("fs");

// define the base url
let baseUrl = "https://www.fema.gov/api/open/v2/DisasterDeclarationsSummaries";

// define a query using parameters
select = "?$select=disasterNumber,declarationDate,declarationTitle,state"; // leave this parameter out if you want all fields
filter = "&$filter=state%20ne%20%27FL%27"; // for purposes of example, exclude Florida
orderby = "&$orderby=id"; // order unimportant to me, so use id
format = "&$format=json"; // set the format to json, json is the default format
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
        const recordCount = fileData["DisasterDeclarationsSummaries"].length // count how many records are returned
        console.log(`Record Count: ${recordCount}`);
    })
  }
};

// run the api call
saveStreamingData();
