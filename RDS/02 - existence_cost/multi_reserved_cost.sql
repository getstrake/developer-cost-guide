#Existence Cost
##Isolate the Multi-AZ, Reserved, running cost for an RDS Instance.
SELECT
	[lineItem/ResourceID],
	[product/instanceType],
	[product/region],
	round(sum([reservation/EffectiveCost]), 4) as multi_reserved_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'DiscountedUsage'
	and [lineItem/Operation] LIKE 'CreateDBInstance%'
	and [lineItem/UsageType] LIKE '%Multi-AZUsage:%'
GROUP BY
	[lineItem/ResourceID],
	[product/instanceType],
	[product/region]
ORDER BY
	sum([lineItem/UnblendedCost]);