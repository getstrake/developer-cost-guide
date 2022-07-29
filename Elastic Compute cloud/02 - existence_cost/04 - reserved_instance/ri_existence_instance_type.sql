#Reserved instance existence cost
##Reserved instance existence cost by instance type, region

SELECT
	[product/instanceType],
	[product/region],
	round(sum([reservation/EffectiveCost]), 4) as existence_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonEC2'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'DiscountedUsage'
GROUP BY
	[product/instanceType],
	[product/region]
ORDER BY
	sum([lineItem/UnblendedCost]);