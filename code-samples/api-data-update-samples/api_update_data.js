/* Data retrieval example using Node.js, the node fetch api introduced in node v16.15.0, and async/await to return data.
 * This example utilizes a very simple log file of when the data was last pulled so that only new or refreshed records are pulled.
 * It stores the entire query in memory before writing it to a file. While this can cause problems with large queries, it should be
 * more than sufficient for most update queries as they should only contain a small subset of the total dataset.
 */

// this example relies on async/await functions for readability so we utilize the promise version of fs
const fs = require("fs").promises;

// define our variables
const datasetName = "DisasterDeclarationsSummaries";
const datasetVersion = 2;
const baseUrl = "https://www.fema.gov/api/open/";
const logfile = "code-samples/api-data-update-samples/js_log.txt";
const saveLocation = "code-samples/api-data-update-samples/DDSV2_updates.json";

// a helper function that reads the log and returns the last date
// TODO: handle when there is no file yet
async function getLastRunDate(logPath) {
  // define a query using parameters
  select = "?$select=lastDataSetRefresh"; // leave this parameter out if you want all fields
  filter = `&$filter=name%20eq%20%27${datasetName}%27%20and%20version%20eq%20${datasetVersion}`; // for purposes of example, exclude Florida
  format = "&$format=json"; // set the format to json
  other = "&$metadata=off"; // suppress metadata
  try {
    const data = await fs.readFile(logPath);
    let dates = data.toString().split("\n"); // convert the buffer object to a string and split by line break
    const lastLine = dates[dates.length - 1]; // get the last line from the log
    return lastLine;
  } catch (error) {
    // console.error(`Got an error trying to read the file: ${error.message}`);
    console.log("No log file found, a new log file will be created");
    return false;
  }
}

// A helper function that returns true or false based on if the dataset has refreshed since the last time this code was run
async function datasetHasRefreshed(lastRun) {
  // Define URL for the Data Sets endpoint and a subsequent query
  const endpointUrl = baseUrl + "v1/DataSets";
  // if there is no lastrun value, assume that this code has never been run before
  if (!lastRun) {
    return true;
  }
  try {
    // issue api call
    const response = await fetch(
      endpointUrl + select + filter + format + other
    );
    // if the response is not ok, abort
    if (!response.ok) {
      throw new Error(
        `last dataset refresh date could not be found, server returned ${response.status}`
      );
    } else {
      // compare the lastDataSetRefresh date from the api to the last date the code was run
      const data = await response.json();
      const lastDataSetRefresh = data["DataSets"][0]["lastDataSetRefresh"];
      var isDate = function (date) {
        return new Date(date) !== "Invalid Date" && !isNaN(new Date(date));
      };
      if (isDate(lastRun) && isDate(lastDataSetRefresh)) {
        return new Date(lastDataSetRefresh) > new Date(lastRun);
      } else {
        // if the last entry in the log cannot be read, no action will be taken
        console.log(
          `${lastRun} or ${lastDataSetRefresh} is not a date, take no action.`
        );
        return false;
      }
    }
  } catch (error) {
    // if something goes wrong, abort
    console.error(error);
  }
}

// Pull updated data
async function updateData() {
  try {
    let lastRun = await getLastRunDate(logfile);
    let hasRefreshed = await datasetHasRefreshed(lastRun);
    if (hasRefreshed) {
      console.log("The dataset has been updated, do something");
      // If there is no previous value for lastRun, then we set it to 0 so that we can pull all data
      if (lastRun == false) {
        lastRun = "0";
      } else {
        // We convert the lastRun data from a string to a date for the api call
        lastRun = new Date(lastRun);
      }
      // Query parameters
      const filter = "?$filter=lastRefresh%20gt%20%27" + lastRun + "%27"; // for purposes of example, exclude Florida
      const format = "&$format=json"; // set the format to json
      const other = "&$metadata=off&$allrecords=true"; // suppress metadata

      const endpointUrl = baseUrl + "v" + datasetVersion + "/" + datasetName;
      // Fetch the data
      const response = await fetch(endpointUrl + filter + format + other);
      // If the response has an error, abort
      if (!response.ok) {
        throw new Error(
          `last dataset refresh date could not be found, server returned ${response.status}`
        );
      } else {
        // compare the lastDataSetRefresh date from the api to the last date the code was run
        const data = await response.json();

        // Any sort of processing can happen here
        // Let's save to a file: NOTE: we are storing all of the data as a variable that we then write to the file, with the larger datasets, this can cause
        //     memory problems and lead to crashes, but it should be sufficient for pulling update data
        fs.writeFile(saveLocation, JSON.stringify(data, null, 4)).then(() => {
          const dateTime = new Date().toISOString();
          if (lastRun == "0") {
            fs.appendFile(logfile, dateTime);
          } else {
            fs.appendFile(logfile, "\n" + dateTime);
          }
        });
      }
    } else {
      console.log("The dataset has not been refreshed since the last call.");
    }
  } catch (error) {
    // if something goes wrong, abort
    throw new Error(error);
  }
}

// Initiate the function
updateData().then(async () => {
  console.log("file successfully saved");
  // lets check the file
  const data = await fs.readFile(saveLocation);
  const fileData = JSON.parse(data);
  const recordCount = fileData["DisasterDeclarationsSummaries"].length; // count how many records are returned
  console.log(`Record Count: ${recordCount}`);
});
