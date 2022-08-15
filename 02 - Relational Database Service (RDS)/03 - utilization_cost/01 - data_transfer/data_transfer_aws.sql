#Utilization
##Data Transfer for RDS to/from AWS Service or Region
SELECT
	[lineitem/ResourceID],
	[lineItem/UsageType],
	round(sum([lineItem/UsageAmount]), 4) as aws_data_transfer_gb,
	round(sum([lineItem/UnblendedCost]), 4) as aws_data_transfer_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] IS 'Usage'
	and [lineItem/Operation] IS 'Not Applicable'
	and [lineItem/UsageType] LIKE '%-AWS-%'
GROUP BY
	[lineitem/ResourceID],
	[lineItem/UsageType]
ORDER BY
	sum([lineItem/UnblendedCost]);
