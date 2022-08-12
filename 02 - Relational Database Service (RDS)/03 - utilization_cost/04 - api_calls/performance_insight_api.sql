#Utilization
##API Calls for performance insights
SELECT
	[lineitem/ResourceID],
	round(sum([lineItem/UsageAmount]), 4) as api_call_count,
	round(sum([lineItem/UnblendedCost]), 4) as api_call_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] IS 'Usage'
	and [lineItem/Operation] IS 'Call'
	and [lineItem/UsageType] LIKE '%API%'
GROUP BY
	[lineitem/ResourceID]
ORDER BY
	sum([lineItem/UnblendedCost]);
