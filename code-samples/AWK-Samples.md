# AWK Samples

This example uses the standard linux bash command line curl command to request the redacted FimaNfipClaims data API and produces a csv file that
then gets run through AWK to sum the amountPaidOnContentsClaim and amountPaidOnBuildingClaims fields on each row along with a total (expressed as a new field), and is output as comma separated values. The output can be copied into whatever you need.

- Pull the first 1000 rows from the API (run this on a Linux command line)

    curl 'https://www.fema.gov/api/open/v1/FimaNfipClaims?$select=state,countyCode,yearOfLoss,amountPaidOnContentsClaim,amountPaidOnBuildingClaim&$format=csv' | sort > claimsdata

- Calculate row totals, summing the claim field amounts together by reading from the claimsdata file row by row for all rows (run this on a Linux command line)

    awk '// {FS = ","};{print $1","$2","$3","$4","$5"," $4+$5}' claimsdata

Then you will have the output written to the screen.

From here on you could modify the AWK command to do paging and subtotaling by yearOfLoss, state, county fips code and you can edit the curl API call to filter and select the fields you wish to deal with.

For more AWK help see the manual at
https://www.gnu.org/software/gawk/manual/gawk.html

If you have AWK questions please email me at michael.mcginn@geekzonehosting.com
