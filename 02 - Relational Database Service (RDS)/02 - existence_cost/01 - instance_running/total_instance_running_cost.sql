#Existence Cost 
##Total instance running costs combining Single, Multi-AZ on-demand and Reserved instance costs
WITH single_od_cost AS (
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
	sum([lineItem/UnblendedCost])
)
, single_reserved_cost AS (
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
	sum([reservation/EffectiveCost])
)
, multi_od_cost AS (
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
	sum([lineItem/UnblendedCost])
)
, multi_reserved_cost AS (
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
	sum([lineItem/UnblendedCost])
)
SELECT
	CUR.[lineItem/ResourceID],
	CUR.[product/instanceType],
	CUR.[product/region],
	COALESCE(single_od_cost.single_od_cost, 0) as single_od_cost,
	COALESCE(single_reserved_cost.single_reserved_cost, 0) as single_reserved_cost,
	COALESCE(multi_od_cost.multi_od_cost, 0) as multi_od_cost,
	COALESCE(multi_reserved_cost.multi_reserved_cost, 0) as multi_reserved_cost,
	(COALESCE(single_od_cost.single_od_cost, 0)+COALESCE(single_reserved_cost.single_reserved_cost, 0)+COALESCE(multi_od_cost.multi_od_cost, 0)+COALESCE(multi_reserved_cost.multi_reserved_cost, 0)) as total_running_cost
FROM CUR
LEFT JOIN
	single_od_cost
	ON single_od_cost.[lineItem/ResourceID] = CUR.[lineItem/ResourceID]
LEFT JOIN
	single_reserved_cost
	ON single_reserved_cost.[lineItem/ResourceID] = CUR.[lineItem/ResourceID]
LEFT JOIN
	multi_od_cost
	ON multi_od_cost.[lineItem/ResourceID] = CUR.[lineItem/ResourceID]
LEFT JOIN
	multi_reserved_cost
	ON multi_reserved_cost.[lineItem/ResourceID] = CUR.[lineItem/ResourceID]
WHERE 
	CUR.[lineItem/ProductCode] is 'AmazonRDS'
	and CUR.[product/instanceType] <> ""
	and CUR.[lineitem/ResourceId] <> ""
GROUP BY
	CUR.[lineitem/ResourceId],
	CUR.[product/instanceType],
	CUR.[product/region]
ORDER BY
	total_running_cost;