/* A very basic express app to serve a static HTML page for viewing geojson data. All of the actual code
 *  is in /public
*/

const express = require('express')
const app = express()

const port = 3000 // set the port it will display on

app.use(express.static('public'));
app.get('/', (req,res)=>{
    res.sendFile('index.html')
})

app.listen(port, ()=>{
    console.log(`Server is listening on http://localhost:${port}`);
})