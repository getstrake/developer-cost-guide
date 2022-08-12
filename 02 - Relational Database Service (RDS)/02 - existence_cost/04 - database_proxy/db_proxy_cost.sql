#Existence Cost
##RDS Proxy Usage
SELECT
	[lineitem/ResourceID],
	round(sum([lineItem/UnblendedCost]), 4) as db_proxy_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/Operation] LIKE 'CreateDBProxy%'
	and [lineItem/UsageType] LIKE '%ProxyUsage'
GROUP BY
	[lineitem/ResourceID]
ORDER BY
	sum([lineItem/UnblendedCost]);
