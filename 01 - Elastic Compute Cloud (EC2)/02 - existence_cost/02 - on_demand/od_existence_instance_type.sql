#On-Demand existence cost
##On-demand existence cost by instance type & region

SELECT
	[product/instanceType],
	[product/region],
	round(sum([lineItem/UnblendedCost]), 4) as existence_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonEC2'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/UsageType] LIKE '%BoxUsage%'
	and [lineItem/Operation] LIKE 'RunInstances%'
GROUP BY
	[product/instanceType],
	[product/region]
ORDER BY
	sum([lineItem/UnblendedCost]);
