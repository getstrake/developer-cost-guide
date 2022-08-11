#Existence Cost
##Provisioned GP2 Storage
SELECT
	[lineItem/ResourceID],
	round(sum([lineItem/UnblendedCost]), 4) as gp2_storage_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/Operation] LIKE 'CreateDBInstance%'
	and [lineItem/UsageType] LIKE '%GP2-Storage%'
GROUP BY
	[lineitem/ResourceID]
ORDER BY
	sum([lineItem/UnblendedCost]);	