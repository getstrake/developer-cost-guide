#Subresource Costs
##Subresource costs by Resource ID

SELECT DISTINCT
	[lineItem/ResourceId],
	round(sum([lineItem/UnblendedCost]), 4) as subresource_cost
FROM CUR
WHERE
	[lineItem/ProductCode] is 'AmazonEC2'
	and [lineItem/ResourceId] NOT LIKE 'i-%'
GROUP BY
	[lineItem/ResourceId]
ORDER BY
	sum([lineItem/UnblendedCost]);
