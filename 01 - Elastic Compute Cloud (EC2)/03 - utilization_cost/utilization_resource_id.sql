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
