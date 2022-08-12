#Spot existence cost
##Spot existence by usage start date, instance type, region

SELECT
	[lineItem/UsageStartDate],
	[product/instanceType],
	[product/region],
	[lineItem/UnblendedCost]/[lineItem/UsageAmount] as spot_rate
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonEC2'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/UsageType] LIKE '%SpotUsage%'
	and [lineItem/Operation] LIKE 'RunInstances:SV%'
GROUP BY
	[product/instanceType],
	[lineItem/UsageStartDate],
	[product/region]
ORDER BY
	[lineItem/UnblendedCost]/[lineItem/UsageAmount];
