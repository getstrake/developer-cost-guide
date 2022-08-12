#Existence Cost
##Provisioned IOPS (PIOPS) and Storage.
SELECT	
	[lineItem/ResourceID],
	round(sum([lineItem/UnblendedCost]), 4) as piops_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] is 'Usage'
	and [lineItem/Operation] LIKE 'CreateDBInstance%'
	and [lineItem/UsageType] LIKE '%PIOPS%'
GROUP BY
	[lineitem/ResourceID]
ORDER BY
	sum([lineItem/UnblendedCost]);
