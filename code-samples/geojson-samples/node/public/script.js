// set variables
const requestUrl =
  "https://www.fema.gov/api/open/v2/FemaRegions?$allrecords=true&$metadata=off";

// fetch geoJSON
async function fetchGeoJson() {
  // basic fetch request with error handling
  try {
    const res = await fetch(requestUrl);
    if (!res.ok) {
      throw new Error(
        `File could not be retrieved, server returned ${res.status}`
      );
    }
    const data = await res.json(); // get fresponse as JSON
    const regions = data["FemaRegions"]; // pull out the FemaRegion data from the response
    const regionGeometry = []; // holder for region geometry
    regions.forEach((region) => {
      // Pull out all region geometry values, skipping empty or null values
      if (region["regionGeometry"]) {
        regionGeometry.push(region["regionGeometry"]);
      }
    });
    console.log(regionGeometry);
    
    return regionGeometry;
  } catch (err) {
    throw new Error(err);
  }
}

async function makeMap() {
  const data = await fetchGeoJson();
  
  // configure the map
  const config = {
    minZoom: 2,
    maxZoom: 10,
  };
  // set the map default view
  const zoom = 5;
  const lat = 37.0902;
  const lang = -95.7129;

  // initialzie the map
  var map = L.map("map", config).setView([lat, lang], zoom);
  
  // Add the map tiles to the map
  L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
    attribution:
      '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>',
  }).addTo(map);

  // load the geoJson data and apply desired styles
  L.geoJSON(data, {
    style: { color: "#0000FF" },
  }).addTo(map);
}

// Call our function
makeMap()