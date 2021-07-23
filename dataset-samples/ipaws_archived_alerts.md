# IPAWS Archived Alerts Query Examples

The Integrated Public Alert and Warning System (IPAWS) Archived Alerts data set is unique among OpenFEMA data sets in that the information is hierarchical in nature. Performing searches through the API can be challenging and the ability to filter, search, and sort IPAWS data is limited. In most cases it will be necessary to first download a subset based on a filter to limit data to a region or date, and then post-process offline with external tools.

OpenFEMA generally uses utilities and tools built into the Linux operating system. For example, once downloaded a utility called jq can be used to extract and manipulate JSON data and even extract it into a CSV file. This has to be done with care however, because the hierarchical nature of CAP messages can introduce duplicate records in the results.

## Basic Filtering (via browser URL)
### By date

    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$filter=sent%20eq%20%272020-03-20%27

### By date range

    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$filter=sent%20gt%20%272020-03-20%27%20and%20sent%20lt%20%272020-03-21%27

### Search by event code – Child Abduction Emergency

    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$filter=contains(info/eventCode,%27{%22SAME%22:%20%22CAE%22}%27)&$top=10&$orderby=sent%20desc
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$filter=contains(info/eventCode,%27{%22SAME%22:%20%22CAE%22}%27)%20and%20contains(info/area/geocode,%27{%22SAME%22:%22051059%22}%27)&$top=1&$orderby=sent%20desc

### Search by event code – Silver Alerts for 11/09/2019

    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$filter=(contains(info/eventCode,%27{%22SAME%22:%20%22ADR%22}%27)%20and%20(sent%20ge%20%272019-11-09T00:00:00.000Z%27%20and%20sent%20lt%20%272019-11-10T00:00:00.000Z%27))&$orderby=sent%20desc

### Original CAP message only, by cogid

    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$filter=cogId%20eq%20200032&$select=originalMessage

## Retrieve Data by State

Selecting by state involves finding the state FIPS prefix and using a "startswith" operator on a hierarchical element within the structure.
    
    # IPAWS extract from OpenFEMA for California alerts between 1/1/2020 and 10/8/2020
    
    # Get IPAWS data from 01/01/2020 to 10/08/2020 3:00pm EST (IPAWS data on OpenFEMA has a 24 hour lag)
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$top=0&$filter=sent%20ge%20%272020-01-01%27%20and%20startswith(info/area/geocode/SAME,%27006%27)&$filename=ipaws_ca_cy2020.json
    
    # verified count of the records (9,753)
    jq '.IpawsArchivedAlerts | length' ipaws_ca_cy2020.json
    
    # extracting some data as a csv (no headers) - the -r parameter is important as it prevents duplicate double quotes
    jq -r '.IpawsArchivedAlerts[] | {cogId, identifier, sent, msgType, sender, eventCode: .info[].eventCode[].SAME, event: .info[].event, headline: .info[].headline, areaDesc: .info[].area[].areaDesc} | map(.) | @csv' ipaws_ca_cy2020.json >> ipaws_ca_cy2020.csv
    
    # The file called ipaws_ca_cy2020.json contains the OpenFEMA extract of the IPAWS data. This extract contains the raw CAP messages.
    
    
    # NOTE: IPAWS CAP messages have a hierarchical structure - there are many parent child relationships. Flattening
    #   the data into a CSV file as done above will result in duplicate records. A better approach is to specifically
    #   extract desired information from the CAP messages themselves.

## Retrieving Data by Event Type (and County)
The example below tries to identify those events associated with flooding. The following event codes are for alerts that are associated, but do not guarantee flooding:

- SVR - Severe Thunderstorm Warning
- FFW - Flash Flood Warning
- FLW - Flood Warning
- FLS - Flood Statement
- HLS - Hurricane Statement
- HUW - Hurricane Warning

<br>
    # The first 1,000 (out of 3,345) IPAWS records for Lycoming County, PA (FIPS code 042081)
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$filter=contains(info/area/geocode,%27{%22SAME%22:%22042081%22}%27)
    
    # The first 1,000 (out of 3,050) IPAWS records for Clinton County, PA (FIPS code 042035)
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$filter=contains(info/area/geocode,%27{%22SAME%22:%22042081%22}%27)
    
    # IPAWS records for Lycoming County, PA, Severe Thunderstorm Warning (181 records)
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$filter=(contains(info/area/geocode,%27{%22SAME%22:%22042081%22}%27))%20and%20(contains(info/eventCode,%27{%22SAME%22:%20%22SVR%22}%27))
    
    # IPAWS records for Clinton County, PA, Severe Thunderstorm Warning (32 records)
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$filter=(contains(info/area/geocode,%27{%22SAME%22:%22042035%22}%27))%20and%20(contains(info/eventCode,%27{%22SAME%22:%20%22FLW%22}%27))

## Execute a Geospatial Query

The entity/field/object to be searched is passed along with a bounding polygon or a point. The syntax for the polygon must be in the format of the example. Replace the coordinates with your own polygon coordinates in WKT (Well Known Text) format.

    # find alerts falling within the defined polygon 
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$filter=geo.intersects(searchGeometry, geography 'POLYGON((34.38 -86.65,34.2 -86.72,34.31 -86.99,34.4 -86.94,34.38 -86.65))')
    
## Retrieving Covid-19 Data

Currently the IPAWS Historical Archive does not permit free form text searches within the alert description or title fields, making it difficult to search on the term "covid". It is possible to filter on eventCode, however alert issuers may not have tagged COVID related alerts with the same code. It looks like most were issued with the CEM (Civil Emergency Message) event code. Some appear under the SPW (Shelter In-place) event code. There may be non-COVID civil emergency and shelter in place events in this list. There may exist other COVID related alerts that are not associated with these event codes. The following examples will pull by event codes. The resulting data could be further refined with post processing.

    #The following query pulls messages with the CEM event type code from 01/01/2020:
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$filter=sent%20gt%20%272020-01-01%27%20and%20contains(info/eventCode,%27{%22SAME%22:%20%22CEM%22}%27)
    
    #This will return SPW event codes:
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$filter=sent%20gt%20%272020-01-01%27%20and%20contains(info/eventCode,%27{%22SAME%22:%20%22SPW%22}%27)
    
    # Event code searches can be combined as in:
    https://www.fema.gov/api/open/v1/IpawsArchivedAlerts?$inlinecount=allpages&$filter=sent%20gt%20%272020-01-01%27%20and%20(contains(info/eventCode,%27{%22SAME%22:%20%22CEM%22}%27)%20or%20contains(info/eventCode,%27{%22SAME%22:%20%22SPW%22}%27))
