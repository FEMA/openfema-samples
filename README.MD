# OpenFEMA Samples

This repository contains code, dataset, and analysis samples that utilize the OpenFEMA API as a data source. This will provide an additional mechanism for the public and FEMA's Whole Community partners to collaborate with FEMA. Each folder contains a README file with additional information.

## OpenFEMA

FEMA collects data on multiple aspects of emergency management—Disaster Information, Individual Assistance, Public Assistance, Hazard Mitigation, National Flood Insurance Program (NFIP), Emergency Management, Preparedness, and Grants. OpenFEMA is the public’s resource for this data. OpenFEMA’s mission is to promote a culture of Open Government within FEMA and increase transparency, participation, and collaboration among the Whole Community in support of FEMA’s mission of helping people before, during, and after disasters.

See the [OpenFEMA website](https://www.fema.gov/open) to access dataset downloads and the application programming interface (API) that provides data in an easily digestible, machine readable format.

## Public Feedback & Contribution

We encourage your feedback and contributions to this repository. Content suggestions and discussions (specific to OpenFEMA) can be communicated in the following ways:

- GitHub “issues.” Each issue is a conversation about specific project work initiated by a member of the public.
- GitHub "discussions". Each discussion is a project communication forum. Discussions are not specific to elements of work like a pull request. We encourage you to browse and join in on discussions or start a new conversation by creating a new discussion.
- Direct changes and line edits to the content may be submitted through a "pull request" by clicking "Edit this page" on any site page in the repository. You do not need to install any software to suggest a change. You can use GitHub's in-browser editor to edit files and submit a pull request for your changes to be merged into the document. Directions on how to submit a pull request can be found on GitHub. 
- Send your content suggestions or proposed revisions to the OpenFEMA team via email to openfema@fema.dhs.gov. Please note that all comments received may or may not be posted publicly on this page.

OpenFEMA now uses GovDelivery to inform users of system outages, dataset deprecations, new datasets, and new API features. Notifications will be infrequent - probably no more than one per month. FEMA respects your privacy and will never use your email for purposes other than OpenFEMA notifications. You may unsubscribe at any time. If interested, subscribe to [GovDelivery for OpenFEMA](https://public.govdelivery.com/accounts/USDHSFEMA/signup/31270).

We encourage you to read this project's [Code of Conduct](CODE_OF_CONDUCT.md) [CONTRIBUTING](CONTRIBUTING.md) policy and its [LICENSE](LICENSE.md).

## Third-Party Uses of OpenFEMA

The following GitHub projects are included here as examples of tools and analysis that users of OpenFEMA have created. If you would like a project mentioned here, send an email to openfema@fema.gov. We don't expect production quality code but the code must run and have reasonably good documentation. Tool repositories without activity for more than 5 years will be removed from this list. Analysis repositories will remain.

Note: FEMA does not endorse any of the projects mentioned in this list. FEMA did not create these projects and applications, has not tested them, and makes no claim as to the assurance of their efficacy, security, or reliability. They are used here for illustrative purposes only.

### Tools

- [OpenFEMANgClient](https://github.com/EOCOnline/openFemaNgClient) - An Angular (i.e., 'Ng') and Typescript application that provides a sample approach for accessing a few of the disaster related datasets. A proof-of-concept tool with a focus on emergency operations.
- [openfema-api-python-client](https://github.com/schemeflex/openfema-api-python-client) - A Python wrapper for the OpenFEMA API. Currently in beta and only works for 3 datasets.
- [rfema (R FEMA)](https://github.com/ropensci/rfema) - An R framework for accessing the OpenFEMA API. Well documented and works for all OpenFEMA datasets.
- [NFHL: National Flood Hazard Layers](https://github.com/mikejohnson51/NFHL) - Although not OpenFEMA related, this deserves mention. It is an R implementation/wrapper for the NFHL API.

### Analysis

- [Analyzing FEMA's National Flood Insurance Program (NFIP) Data With DuckDB](https://github.com/mebauer/duckdb-fema-nfip/) - A Jupyter notebook demonstrating the use of the Python DuckDB library to perform NFIP analysis.
- [Exploration of FEMA National Flood Insurance Program Data](https://github.com/samroeslin/National-Flood-Insurance-Program) - A casual project whose intent was to develop a procedure for developing insights from flood claims data and to enable identification of critical parameters affecting losses. Jupyter notebooks.
- [Exploring National Flood Insurance Program (NFIP) Data for New York City](https://github.com/mebauer/fema-nfip-nyc) - A set of Jupyter notebooks that perform analysis on NFIP data using the Python programming language.
- [How Disasters Affect Housing Prices](https://github.com/bandipara/fema_analytics) - FEMA data correlated to Zillow data to explore the relationship between disasters and housing prices.
- [Predicting Disaster Costs using OpenFEMA](https://github.com/gcox32/FEMA) - A series of Jupyter notebooks that use OpenFEMA data as part of a statistical analysis and machine learning project.

## Public domain

This project is in the worldwide [public domain](LICENSE.md). As stated in [CONTRIBUTING](CONTRIBUTING.md):

> This project is in the public domain within the United States, and copyright and related rights in the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
>
> All contributions to this project will be released under the CC0 dedication. By submitting a pull request, you are agreeing to comply with this waiver of copyright interest.
