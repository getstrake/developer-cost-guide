SELECT
	[lineitem/ResourceID],
	round(sum([lineItem/UsageAmount]), 4) as backup_storage_db,
	round(sum([lineItem/UnblendedCost]), 4) as backup_storage_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/UsageType] LIKE '%ChargedBackupUsage%'
GROUP BY
	[lineitem/ResourceID]
ORDER BY
	sum([lineItem/UnblendedCost]);