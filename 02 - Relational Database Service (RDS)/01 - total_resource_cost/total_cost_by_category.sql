#Total RDS Cost By Category
##Total cost by line item type, operation and usage type.
SELECT
	[lineItem/LineItemType],
	[lineItem/Operation],
	[lineItem/UsageType],
	round(sum([lineItem/UsageAmount]), 4) as usage_amount,
	[pricing/unit],
	round(sum([lineItem/UnblendedCost]), 4) as unblended_cost,
	round(sum([reservation/EffectiveCost]), 4) as reserved_cost
FROM cur
WHERE
	[lineItem/ProductCode] = 'AmazonRDS'
	and [lineItem/LineItemType] <> 'Tax'
GROUP BY
	[lineItem/LineItemType],
	[lineItem/Operation],
	[lineItem/UsageType],
	[pricing/unit]
ORDER BY
	[lineItem/LineItemType],
	[lineItem/Operation],
	[lineItem/UsageType],
	sum([lineItem/UnblendedCost]);
