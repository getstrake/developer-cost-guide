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