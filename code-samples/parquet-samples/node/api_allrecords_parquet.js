/* Data retrieval example using Node.jsand the fetch library to handle http requests
 * The results of the https requests are saved to a parquet file called 'DisasterDeclaration.parquet'.
 * This is a streaming data example, ideal for large datasets
 */

import { createWriteStream } from "fs";
import parquet from "@dsnp/parquetjs";

// define our variables
const url ="https://www.fema.gov/api/open/v2/DisasterDeclarationsSummaries.parquet"; 
const fileLocation = "DisasterDeclaration.parquet";

// creating our write stream object
const writeStream = createWriteStream(fileLocation); 

// We create an async method to handle the downloading and writing of the parquet file
async function downloadFile(url, fileLocation) {
  try {
    const response = await fetch(url);
    if (!response.ok) {
      throw new Error(
        `File could not be downloaded, server returned ${response.status}`
      );
    }
    console.log("saving file");
    for await (const chunk of response.body) {
      writeStream.write(chunk);
    }
    writeStream.end();
  } catch (error) {
    throw new Error(error);
  }
}

// Now that we've downloaded the file we want to manipulate it
async function testFile(fileLocation) {
  let reader = await parquet.ParquetReader.openFile(fileLocation); // an object to allow us to open parquet files
  let cursor = reader.getCursor(); // The cursor selects what we want to manipulate. It can be set to specific columns
  let record = null; // this will store the current record being manipulated
  let recordCount = 0;

  console.log("Counting records");

  // This will iterate through all the records, aditional data analysis can be performed here
  while ((record = await cursor.next())) {
    recordCount++; // In this example we are merely counting how many records we have
  }
  console.log("Record Count:", recordCount);
  await reader.close(); // After finishing the analysis, we must make sure to close the reader
}

// we initialize our program, downloading the file then running the tests after the program verifies the file is closed
downloadFile(url, fileLocation).then(() => {
  writeStream.on("finish", () => {
    console.log("file downloaded, running tests");
    testFile(fileLocation);
  });
});
