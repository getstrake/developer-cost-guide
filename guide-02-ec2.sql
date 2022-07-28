#Guide 01 - EC2
#Version 1.0
#July 2022


#Existence Costs
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

#On-Demand existence cost
##On-demand existence cost by resource ID
SELECT
	[lineItem/ResourceId],
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
	[lineItem/ResourceId],
	[product/region]
ORDER BY
	sum([lineItem/UnblendedCost]);


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


#Reserved instance existence cost
##Reserved instance existence cost by instance type, region
SELECT
	[product/instanceType],
	[product/region],
	round(sum([reservation/EffectiveCost]), 4) as existence_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonEC2'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'DiscountedUsage'
GROUP BY
	[product/instanceType],
	[product/region]
ORDER BY
	sum([lineItem/UnblendedCost]);

#Reserved instance existence cost
##Reserved instance ARN information
SELECT 
	[reservation/ReservationARN],
	[product/instanceType],
	[product/region],
	round(sum([reservation/EffectiveCost]), 4) as existence_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'DiscountedUsage'
GROUP BY 
	[reservation/ReservationARN],
	[product/instanceType],
	[product/region]
ORDER BY
	sum([reservation/EffectiveCost]);


#Savings plan existence cost
##Savings plan existence cost by instance type, region
SELECT 
	[product/instanceType],
	[product/region],
	round(sum([savingsPlan/SavingsPlanEffectiveCost]), 4) as existence_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonEC2'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'SavingsPlanCoveredUsage'
GROUP BY 
	[product/instanceType],
	[product/region]
ORDER BY
	sum([savingsPlan/SavingsPlanEffectiveCost]);

#Savings plan existence cost
##Savings plan ARN information
SELECT
	[savingsPlan/SavingsPlanARN],
	[product/region],
	round(sum([savingsPlan/SavingsPlanEffectiveCost]), 4) as existence_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonEC2'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'SavingsPlanCoveredUsage'
GROUP BY
	[savingsPlan/SavingsPlanARN],
	[product/region]
ORDER BY
	sum([savingsPlan/SavingsPlanEffectiveCost]);


#Total existence cost for EC2
##Total existence cost by resource ID
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
	CUR.[lineitem/ResourceId],
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
	CUR.[lineitem/ResourceId],
	CUR.[product/instanceType],
	CUR.[product/region]
ORDER BY
	total_existence_cost;

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




#Utilization Costs
##Utilization costs for EC2 by line item operation
SELECT
	[lineItem/Operation],
	round(sum([lineItem/UnblendedCost]), 4) as utilization_cost
FROM CUR
WHERE
	[lineItem/ProductCode] is 'AmazonEC2'
	and [lineItem/ResourceId] LIKE 'i-%'
	and [lineItem/UsageType] NOT LIKE '%BoxUsage%'
	and [lineItem/Operation] NOT LIKE 'RunInstances%'
	and [lineItem/LineItemType] is 'Usage'
GROUP BY
	[lineItem/LineItemType],
	[lineItem/Operation]
ORDER BY
	sum([lineItem/UnblendedCost]);

#Utilization Costs
##Utilization costs for EC2 by usage stard date and line item operation
SELECT
	[lineItem/UsageStartDate],
	[lineItem/Operation],
	round(sum([lineItem/UnblendedCost]), 4) as utilization_cost
FROM CUR
WHERE
	[lineItem/ProductCode] is 'AmazonEC2'
	and [lineItem/ResourceId] is 'i-XXXXXXXXXXXXXXXX'
	and [lineItem/UsageType] NOT LIKE '%BoxUsage%'
	and [lineItem/Operation] NOT LIKE 'RunInstances%'
	and [lineItem/LineItemType] is 'Usage'
GROUP BY
	[lineItem/UsageStartDate],
	[lineItem/Operation]
ORDER BY
	sum([lineItem/UnblendedCost]);

#Utilization Costs
##Utilization costs for EC2 by resource ID
SELECT
	[lineItem/ResourceId],
	[lineItem/Operation],
	round(sum([lineItem/UnblendedCost]), 4) as resource_utilization_cost
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
ORDER BY
	sum([lineItem/UnblendedCost]);




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


#Total Resource Cost for EC2
##Combine existence and utilization costs to get a total EC2 instance cost grouped by instance type and region.
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
	COALESCE(savings_plan_existence.existence_cost,0) as savings_plan_existence_cost,
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
	CUR.[product/instanceType],
	CUR.[product/region]
ORDER BY
	total_existence_cost;




#Subresource Costs
##Subresource costs by Resource ID
SELECT DISTINCT
	[lineItem/ResourceId],
	round(sum([lineItem/UnblendedCost]), 4) as subresource_cost
FROM CUR
WHERE
	[lineItem/ProductCode] is 'AmazonEC2'
	and [lineItem/ResourceId] NOT LIKE 'i-%'
GROUP BY
	[lineItem/ResourceId]
ORDER BY
	sum([lineItem/UnblendedCost]);

#Subresource Costs
##Subresource costs for EBS Volumes
SELECT DISTINCT
	[lineItem/ResourceID],
	[lineItem/LineItemType],
	[lineItem/Operation],
	round(sum([lineItem/UnblendedCost]), 4) as subresource_cost
FROM CUR
WHERE
	[lineItem/ProductCode] is 'AmazonEC2'
	and [lineItem/ResourceId] LIKE 'vol-%'
GROUP BY
	[lineItem/ResourceID],
	[lineitem/lineitemtype],
	[lineItem/Operation]
ORDER BY
	sum([lineItem/UnblendedCost]);

#Subresource Costs
##Subresource costs for EBS Volume Snapshots
SELECT DISTINCT
	[lineItem/ResourceID],
	[lineItem/LineItemType],
	[lineItem/Operation],
	round(sum([lineItem/UnblendedCost]), 4) as subresource_cost
FROM CUR
WHERE
	[lineItem/ProductCode] is 'AmazonEC2'
	and [lineItem/ResourceId] LIKE '%snapshot%'
GROUP BY
	[lineItem/ResourceID],
	[lineitem/lineitemtype],
	[lineItem/Operation]
ORDER BY
	sum([lineItem/UnblendedCost]);

#Subresource Costs
##Subresource costs for NAT Gateways
SELECT DISTINCT
	[lineItem/ResourceID],
	[lineItem/LineItemType],
	[lineItem/Operation],
	round(sum([lineItem/UnblendedCost]), 4) as subresource_cost
FROM CUR
WHERE
	[lineItem/ProductCode] is 'AmazonEC2'
	and [lineItem/ResourceId] LIKE '%natgateway%'
GROUP BY
	[lineItem/ResourceID],
	[lineitem/lineitemtype],
	[lineItem/Operation]
ORDER BY
	sum([lineItem/UnblendedCost]);










