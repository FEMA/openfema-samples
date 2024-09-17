# OpenFEMA Samples - Code 

Following are examples or recipes of commonly performed actions - many expressed in different programming or scripting languages. We will continue to expand this section. If you have code examples you would like to see or if you have code samples you would like to share, see the [Public Feedback & Contribution](https://github.com/FEMA/openfema-samples/blob/master/CONTRIBUTING.md) section of the openfema-samples repo. 

We recommend that you review the [OpenFEMA API Documentation](https://www.fema.gov/about/openfema/api) for a list of commands that can be used for each endpoint. As OpenFEMA’s main purpose is to act as a content delivery mechanism, each endpoint represents a dataset. Therefore, the documentation does not outline how to call each dataset endpoint; they all operate in the same manner. Metadata (e.g., content descriptions, update frequency, data dictionary) for each data set can be found on the individual dataset pages. The [OpenFEMA Data Sets](https://www.fema.gov/about/openfema/data-sets) page provides a list of the available endpoints.

In addition, we have prepared a tutorial series that demonstrates usage of the API. See the Jupyter notebooks in the [analysis-examples repository](https://github.com/FEMA/openfema-samples/tree/master/analysis-examples).

## Disclaimer
The point of these examples is to educate and inform. Therefore, they have been written in a manner to make them easy to read with the fewest number of external libraries as possible. There are more efficient, more concise, more structured, and/or more flexible ways to accomplish the same tasks. Take what you need and modify it for your situation. If you are writing production quality code, it is recommended that you follow industry best practices - evaluate returned values, add error handling, add logging, perform proper object cleanup, build for resilience by adding retries if failure, etc.

## Other OpenFEMA Resources for Developers

- The [OpenFEMA Changelog](https://www.fema.gov/about/openfema/changelog) identifies new, changing, and deprecated datasets, and describes new features to the API.
- The [API Specifics/Technical](https://www.fema.gov/about/openfema/faq) portion of the FAQ may be of particular interest to developers.
- The [OpenFEMA Guide to Large Data Sets](https://www.fema.gov/about/openfema/working-with-large-data-sets) provides recommendations and techniques for working with OpenFEMA's large data files. 

## Contents

__NOTE: If you are looking for paging code, please review the Paging Tutorial referenced below. It contains examples using the new $allrecords argument to retrieve data without having to iterate through data.__

- Paging Examples - The OpenFEMA API returns only 1,000 records at a time for performance reasons. If your query returns more than this, it will be necessary to make subsequent calls to capture all the records. This will require the use of the $top and $skip API parameters. See the API documentation for parameter specifics. See [OpenFEMA API Tutorial: Part 3 - Paging to Get Data](https://github.com/FEMA/openfema-samples/blob/master/analysis-examples/API_Tutorial_Part_3_PagingToGetData.ipynb) for a detailed walkthrough. 
- All Records Examples - OpenFEMA recently added a new parameter that permits all records matching criteria to be returned without paging. Several examples have been included to demonstrate this.
- Performing Updates - Code samples to illustrate retrieving dataset updates rather than download full datasets
- GeoJSON Samples - Examples on how to work with GeoJSON data.
- Parquet Samples - Examples on how to work with Parquet files.
- Miscellaneous 
  - AWK-samples.md - Bash script examples using AWK to pull NFIP data and aggregate financial values.
