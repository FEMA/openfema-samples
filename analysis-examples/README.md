# OpenFEMA Samples - Analysis Examples and Tutorials
Following are Jupyter notebooks containing analysis examples or code demonstrations using OpenFEMA data. We will continue to expand this section. If you have any Jupyter Notebooks/analysis that you would like to showcase, see the [Public Feedback & Contribution](https://github.com/FEMA/openfema-samples) section of the openfema-samples repo. 

We recommend that you review the [OpenFEMA API Documentation](https://www.fema.gov/about/openfema/api) for a list of commands that can be used with each endpoint. As OpenFEMA’s main purpose is to act as a content delivery mechanism, each endpoint represents a dataset. Therefore, the documentation does not outline each one; they all operate in the same manner. Metadata (e.g., content descriptions, update frequency, data dictionary) for each data set can be found on the individual data set pages. The [OpenFEMA Data Sets](https://www.fema.gov/about/openfema/data-sets) page provides a list of the available endpoints.

This repository also contains a series of OpenFEMA API tutorials. These tutorials are a great way to learn how to effectively use the APIs. 

## Other OpenFEMA Resources for Developers

- The [OpenFEMA Changelog](https://www.fema.gov/about/openfema/changelog) identifies new, changing, and deprecated datasets, and describes new features to the API.
- The [API Specifics/Technical](https://www.fema.gov/about/openfema/faq) portion of the FAQ may be of particular interest to developers.
- The [OpenFEMA Guide to Working with Large Datasets](https://www.fema.gov/about/openfema/working-with-large-data-sets) provides recommendations and techniques for working with OpenFEMA's large data files. 

## Contents

- FEMA_Region_GeoJson.ipynb - Pulls data from the OpenFEMA Regions endpoint and converts the geometry to GeoJson files.
- get_data-from_api_display_on_map.ipynb - Retrieves IHP Valid Registrant data for the state of LA, summarizes and graphs it, and displays values on a chloropleth map.
- COVID_Data_From_API.ipynb - Retrieves COVID data from a variety of OpenFEMA API endpoints.
- Tutorials:
  - API_Tutorial_Part_1_GettingStarted.ipynb - Basic tutorial on using the OpenFEMA API demonstrating a call to an endpoint.
  - API_Tutorial_Part_2_QueryParameters.ipynb - Provides usage examples for all of the API query parameters.
  - API_Tutorial_Part_3_PagingToGetData.ipynb - Illustrates making multiple endpoint calls to capture all the data.
  - API_Tutorial_Part_4_GettingDatasetUpdates.ipynb - Rather than perform full downloads, in many cases it is possible to retrieve only updates.