This example uses the standard linux bash command line curl command to request the redacted FimaNfipClaims data api and produces a csv file that
then gets run through AWK to sum the amountPaidOnContentsClaim and amountPaidOnBuildingClaims fields on each row and produce a
sum of them into a new field for each row to produce a simple output of the values separated by commas. Then you can copy the output into what ever you need.

Pull the first 1000 rows from the api.

Run this on a Linux command line.

curl 'https://www.fema.gov/api/open/v1/FimaNfipClaims?$select=state,countyCode,yearOfLoss,amountPaidOnContentsClaim,amountPaidOnBuildingClaim&$format=csv' | sort > claimsdata

Calculate row totals summing the claim field amounts together by reading from the claimsdata file row by row for all rows

Run this on your linux command line
awk '// {FS = ","};{print $1","$2","$3","$4","$5"," $4+$5}' claimsdata

Then you will have the output written to the screen.

From here on you could modify the awk command to do paging and subtotaling by yearOfLoss, state, county fips code and you can edit the curl api call to filter and select the fields you wish to deal with.

For more AWK help see the manual at
https://www.gnu.org/software/gawk/manual/gawk.html

If you have awk questions please email me at michael.mcginn@geekzonehosting.com
