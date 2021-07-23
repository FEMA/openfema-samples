# OpenFEMA Samples - Analysis
Following are Jupyter Notebooks containing analysis examples or code demonstrations using OpenFEMA data. We will continue to expand this section. If you have any Jupyter Notebooks/analysis that you would like to showcase, see the [Public Feedback & Contribution](openfema-samples/README.MD) section of the openfema-samples repo. 

We recommend that you review the [OpenFEMA API Documentation](https://www.fema.gov/about/openfema/api) for list of commands that can be used for each endpoint. As OpenFEMA’s main purpose is to act as a content delivery mechanism, each endpoint represents a data set. Therefore, the documentation does not outline each one; they all operate in the same manner. Metadata (content descriptions, update frequency, data dictionary, etc.) for each data set can be found on the individual data set pages. The [Data Sets](https://www.fema.gov/about/openfema/data-sets) page provides a list of the available endpoints.

## Other OpenFEMA Resources for Developers

- The [Changelog](https://www.fema.gov/about/openfema/changelog) identifies new, changing, and deprecated datasets, and describes new features to the API.
- The [API Specifics/Technical](https://www.fema.gov/about/openfema/faq) portion of the FAQ may be of particular interest to developers.
- The [Large Data Set Guide](https://www.fema.gov/about/openfema/working-with-large-data-sets) provides recommendations and techniques for working with OpenFEMA's large data files. 

## Contents

- FEMA_Region_GeoJson.ipynb - Pulls data from the OpenFEMA Regions endpoint and converts the geometry to GeoJson files.
- get_data-from_api_display_on_map.ipynb - Retrieves IHP Valid Registrant data for the state of LA, summarizes and graphs it, and displays values on a chloropleth map.