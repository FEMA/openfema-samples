# OpenFEMA Samples - Code 

Following are examples or recipes of commonly performed actions - many expressed in different programming or scripting languages. We will continue to expand this section. If you have code examples you would like to see or if you have code samples you would like to share, see the [Public Feedback & Contribution](openfema-samples/README.MD) section of the openfema-samples repo. 

We recommend that you review the [OpenFEMA API Documentation](https://www.fema.gov/about/openfema/api) for list of commands that can be used for each endpoint. As OpenFEMA’s main purpose is to act as a content delivery mechanism, each endpoint represents a data set. Therefore, the documentation does not outline each one; they all operate in the same manner. Metadata (content descriptions, update frequency, data dictionary, etc.) for each data set can be found on the individual data set pages. The [Data Sets](https://www.fema.gov/about/openfema/data-sets) page provides a list of the available endpoints.

## Disclaimer
The point of these examples is to educate and inform. Therefore they have written in a manner to make them easy to read with the fewest number of external libraries as possible. There are more efficient or more concise or more structured or more flexible ways to accomplish the same tasks. Take what you need and modify it for your situation.

## Other OpenFEMA Resources for Developers

- The [Changelog](https://www.fema.gov/about/openfema/changelog) identifies new, changing, and deprecated datasets, and describes new features to the API.
- The [API Specifics/Technical](https://www.fema.gov/about/openfema/faq) portion of the FAQ may be of particular interest to developers.
- The [Large Data Set Guide](https://www.fema.gov/about/openfema/working-with-large-data-sets) provides recommendations and techniques for working with OpenFEMA's large data files. 

## Contents
### Paging Examples

The OpenFEMA API returns only 1,000 records at a time for performance reasons. If your query returns more than this, it will be necessary to make subsequent calls to capture all the records. This will require the use of the $top and $skip API parameters. See the API documentation for parameter specifics. The following files illustrate this concept using different languages, and in some cases, different output formats.

- api_paging_rdsoutput.r - Retrieving data in json format, but saving as RDS file.
- api_paging_csvoutput.sh
- api_paging_csvoutput.js
- api_paging_jsonoutput.sh
- api_paging_jsonoutput.py

### Coming Soon

- .NET and Java paging examples (if you have any, please consider contributing)
- Downloading full files
- Periodic updates instead of full downloads
- Checking for dataset data updates
- Converting JSON to a different format
- Working with different time formats
- Using the metadata endpoints