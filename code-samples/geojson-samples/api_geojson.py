# Data retrieval working with GeoJSON within python3. Uses folium for handling of map data 
#   and displays the output in the browser. 

import json
import requests
import folium
import webbrowser
import os

# define the api query and variables
baseURL = "https://www.fema.gov/api/open/v2/FemaRegions?"
fileName = "geojson.html"

# call api 
response = requests.get(baseURL + '$metadata=off')
jsonData = response.json()

# initialize a feature collection to hold all regions 
featureCollection = {
    'type': 'FeatureCollection',
    'features': []
}

# iterate through regions and add geometry to feature follection
for region in jsonData['FemaRegions']:
    if(region["regionGeometry"]):
        featureCollection['features'].append(region["regionGeometry"])

# initialize the map
m = folium.Map(location=(43,-100), zoom_start=4)
# add the geoJSON features
folium.GeoJson(featureCollection, name="regions").add_to(m)
# save to file
m.save(fileName)

# Open the map file in default browser
webbrowser.open('file://' + os.path.realpath(fileName) )