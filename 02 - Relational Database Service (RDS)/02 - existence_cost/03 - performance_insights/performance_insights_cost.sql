#Existence Cost
##Performance Insights Retention Usage
SELECT
	[lineitem/ResourceID],
	round(sum([lineItem/UnblendedCost]), 4) as pi_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/Operation] LIKE 'Retention'
	and [lineItem/UsageType] LIKE '%PI%'
GROUP BY
	[lineitem/ResourceID]
ORDER BY
	sum([lineItem/UnblendedCost]);
