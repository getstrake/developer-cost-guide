#Existence Cost
##Isolate the Single-AZ, Reserved, running cost for an RDS Instance.
SELECT
	[lineItem/ResourceID],
	[product/instanceType],
	[product/region],
	round(sum([reservation/EffectiveCost]), 4) as single_reserved_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'DiscountedUsage'
	and [lineItem/Operation] LIKE 'CreateDBInstance%'
	and [lineItem/UsageType] LIKE '%InstanceUsage:%'
GROUP BY
	[lineItem/ResourceID],
	[product/instanceType],
	[product/region]
ORDER BY
	sum([reservation/EffectiveCost]);