#Utilization
##Aurora Storage utilization costs
SELECT
	[lineitem/ResourceID],
	[lineItem/UsageType],
	round(sum([lineItem/UnblendedCost]), 4) as storage_usage_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] IS 'Usage'
	and [lineItem/Operation] LIKE 'CreateDBInstance%'
	and [lineItem/UsageType] IS 'Aurora:StorageUsage'
GROUP BY
	[lineitem/ResourceID],
	[lineItem/UsageType]
ORDER BY
	sum([lineItem/UnblendedCost]);