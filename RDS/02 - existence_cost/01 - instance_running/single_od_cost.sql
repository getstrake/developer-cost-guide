#Existence Cost
##Isolate the Single-AZ, OnDemand, running cost for an RDS Instance.
SELECT
	[lineItem/ResourceID],
	[product/instanceType],
	[product/region],
	round(sum([lineItem/UnblendedCost]), 4) as single_od_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/Operation] LIKE 'CreateDBInstance%'
	and [lineItem/UsageType] LIKE '%InstanceUsage:%'
GROUP BY
	[lineItem/ResourceID],
	[product/instanceType],
	[product/region]
ORDER BY
	sum([lineItem/UnblendedCost]);