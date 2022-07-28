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