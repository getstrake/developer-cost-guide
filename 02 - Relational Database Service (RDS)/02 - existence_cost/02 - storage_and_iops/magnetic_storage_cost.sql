#Existence Cost
##Provisioned Magnetic Storage
SELECT
	[lineItem/ResourceID],
	round(sum([lineItem/UnblendedCost]), 4) as magnetic_storage_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/Operation] LIKE 'CreateDBInstance%'
	and [lineItem/UsageType] LIKE '%StorageUsage'
GROUP BY
	[lineitem/ResourceID]
ORDER BY
	sum([lineItem/UnblendedCost]);	