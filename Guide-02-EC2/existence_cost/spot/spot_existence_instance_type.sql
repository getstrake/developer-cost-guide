#Spot existence cost
##Spot existence cost by instance type, region

SELECT
	[product/instanceType],
	[product/region],
	round(sum([lineItem/UnblendedCost]), 4) as existence_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonEC2'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/UsageType] LIKE '%SpotUsage%'
	and [lineItem/Operation] LIKE 'RunInstances%'
GROUP BY
	[product/instanceType],
	[product/region]
ORDER BY
	sum([lineItem/UnblendedCost]);