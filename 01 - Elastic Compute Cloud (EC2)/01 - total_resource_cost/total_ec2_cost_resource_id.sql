#Total Resource Cost for EC2
##Combine existence and utilization costs to get a total EC2 instance cost by EC2 resource ID.

WITH resource_existence_cost AS (
WITH on_demand_existence AS (
	SELECT
		[lineItem/ResourceId],
		round(sum([lineItem/UnblendedCost]), 4) as existence_cost
	FROM CUR
	WHERE
		[lineItem/ProductCode] = 'AmazonEC2'
		and [product/instanceType] <> ""
		and [lineItem/LineItemType] is 'Usage'
		and [lineItem/UsageType] LIKE '%BoxUsage%'
		and [lineItem/Operation] LIKE 'RunInstances%'
	GROUP BY
		[lineItem/ResourceId]
)
, spot_existence AS (
	SELECT
		[lineItem/ResourceId],
		round(sum([lineItem/UnblendedCost]), 4) as existence_cost
	FROM CUR
	WHERE
		[lineItem/ProductCode] = 'AmazonEC2'
		and [product/instanceType] <> ""
		and [lineItem/LineItemType] is 'Usage'
		and [lineItem/UsageType] LIKE '%SpotUsage%'
		and [lineItem/Operation] LIKE 'RunInstances%'
	GROUP BY
		[lineItem/ResourceId]
)
, reserved_existence AS (
	SELECT
		[lineItem/ResourceId],
		round(sum([reservation/EffectiveCost]), 4) as existence_cost
	FROM CUR
	WHERE
		[lineItem/ProductCode] = 'AmazonEC2'
		and [product/instanceType] <> ""
		and [lineItem/LineItemType] is 'DiscountedUsage'
	GROUP BY
		[lineItem/ResourceId]
)
, savings_plan_existence AS (
	SELECT 
		[lineItem/ResourceId],
		round(sum([savingsPlan/SavingsPlanEffectiveCost]), 4) as existence_cost
	FROM CUR
	WHERE
		[lineItem/ProductCode] = 'AmazonEC2'
		and [product/instanceType] <> ""
		and [lineItem/LineItemType] is 'SavingsPlanCoveredUsage'
	GROUP BY 
		[lineItem/ResourceId]
)
SELECT
	CUR.[lineItem/ResourceId],
	CUR.[product/instanceType],
	CUR.[product/region],
	COALESCE(on_demand_existence.existence_cost, 0) as on_demand_existence_cost,
	COALESCE(spot_existence.existence_cost, 0) as spot_existence_cost,
	COALESCE(reserved_existence.existence_cost, 0) as reserved_existence_cost,
	COALESCE(savings_plan_existence.existence_cost, 0) as savings_plan_existence_cost,
	(COALESCE(on_demand_existence.existence_cost, 0) + COALESCE(spot_existence.existence_cost, 0) + COALESCE(reserved_existence.existence_cost, 0) + COALESCE(savings_plan_existence.existence_cost, 0)) AS total_existence_cost
FROM CUR
LEFT JOIN 
	on_demand_existence
	ON on_demand_existence.[lineItem/ResourceId] = CUR.[lineItem/ResourceId]
LEFT JOIN 
	spot_existence
	ON spot_existence.[lineItem/ResourceId] = CUR.[lineItem/ResourceId]
LEFT JOIN 
	reserved_existence
	ON reserved_existence.[lineItem/ResourceId] = CUR.[lineItem/ResourceId]
LEFT JOIN 
	savings_plan_existence
	ON savings_plan_existence.[lineItem/ResourceId] = CUR.[lineItem/ResourceId]
WHERE 
	CUR.[lineItem/ProductCode] is 'AmazonEC2'
	and CUR.[product/instanceType] <> ""
	and CUR.[lineitem/ResourceId] <> ""
GROUP BY
	CUR.[lineItem/ResourceId],
	CUR.[product/instanceType],
	CUR.[product/region]
)
, resource_utilization_cost AS (
SELECT
	[lineItem/ResourceId],
	[lineItem/Operation],
	round(sum([lineItem/UnblendedCost]), 4) as total_utilization_cost
FROM CUR
WHERE
	[lineItem/ProductCode] is 'AmazonEC2'
	and [lineItem/ResourceId] LIKE 'i-%'
	and [lineItem/UsageType] NOT LIKE '%BoxUsage%'
	and [lineItem/Operation] NOT LIKE 'RunInstances%'
	and [lineItem/LineItemType] is 'Usage'
GROUP BY
	[lineItem/ResourceId],
	[lineItem/Operation]
)
SELECT
	CUR.[lineItem/ResourceId],
	CUR.[product/instanceType],
	CUR.[product/region],
	COALESCE(resource_existence_cost.total_existence_cost, 0) as total_existence_cost,
	COALESCE(resource_utilization_cost.total_utilization_cost, 0) as total_utilization_cost,
	(COALESCE(resource_existence_cost.total_existence_cost, 0) + COALESCE(resource_utilization_cost.total_utilization_cost, 0)) AS ec2_total_cost
FROM CUR
LEFT JOIN
	resource_existence_cost
	ON resource_existence_cost.[lineItem/ResourceId] = CUR.[lineItem/ResourceId]
LEFT JOIN
	resource_utilization_cost
	ON resource_utilization_cost.[lineItem/ResourceId] = CUR.[lineItem/ResourceId]
WHERE 
	CUR.[lineItem/ProductCode] is 'AmazonEC2'
	and CUR.[product/instanceType] <> ""
	and CUR.[lineitem/ResourceId] <> ""
GROUP BY
	CUR.[lineItem/ResourceId],
	CUR.[product/instanceType],
	CUR.[product/region]
ORDER BY
	total_existence_cost;
