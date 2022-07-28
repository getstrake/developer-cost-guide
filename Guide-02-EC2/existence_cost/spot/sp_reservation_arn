#Savings plan existence cost
##Savings plan ARN information

SELECT
	[savingsPlan/SavingsPlanARN],
	[product/region],
	round(sum([savingsPlan/SavingsPlanEffectiveCost]), 4) as existence_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonEC2'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'SavingsPlanCoveredUsage'
GROUP BY
	[savingsPlan/SavingsPlanARN],
	[product/region]
ORDER BY
	sum([savingsPlan/SavingsPlanEffectiveCost]);