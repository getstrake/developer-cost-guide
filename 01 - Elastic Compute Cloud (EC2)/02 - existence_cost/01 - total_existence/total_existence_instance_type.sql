#Total existence cost for EC2
##Total existence cost by instance type, region

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
	CUR.[product/instanceType],
	CUR.[product/region]
ORDER BY
	total_existence_cost;
