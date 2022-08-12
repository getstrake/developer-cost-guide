#Existence Cost
##Isolate the Multi-AZ, OnDemand, running cost for an RDS Instance.
SELECT
	[lineItem/ResourceID],
	[product/instanceType],
	[product/region],
	round(sum([lineItem/UnblendedCost]), 4) as multi_od_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/Operation] LIKE 'CreateDBInstance%'
	and [lineItem/UsageType] LIKE '%Multi-AZUsage:%'
GROUP BY
	[lineItem/ResourceID],
	[product/instanceType],
	[product/region]
ORDER BY
	sum([lineItem/UnblendedCost]);
