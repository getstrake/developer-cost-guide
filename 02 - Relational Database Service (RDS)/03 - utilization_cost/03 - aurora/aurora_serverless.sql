#Utilization
##Aurora Serverless Usage
SELECT
	[lineitem/ResourceID],
	round(sum([lineItem/UnblendedCost]), 4) as aurora_serverless_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] IS 'Usage'
	and [lineItem/Operation] LIKE 'CreateDBInstance%'
	and [lineItem/UsageType] LIKE 'Aurora:Serverless%'
GROUP BY
	[lineitem/ResourceID]
ORDER BY
	sum([lineItem/UnblendedCost]);
