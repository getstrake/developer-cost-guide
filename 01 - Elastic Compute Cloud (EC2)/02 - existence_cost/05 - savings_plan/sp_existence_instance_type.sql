#Savings plan existence cost
##Savings plan existence cost by instance type, region

SELECT 
	[product/instanceType],
	[product/region],
	round(sum([savingsPlan/SavingsPlanEffectiveCost]), 4) as existence_cost
FROM CUR
WHERE
	[lineItem/ProductCode] = 'AmazonEC2'
	and [product/instanceType] <> ""
	and [lineItem/LineItemType] is 'SavingsPlanCoveredUsage'
GROUP BY 
	[product/instanceType],
	[product/region]
ORDER BY
	sum([savingsPlan/SavingsPlanEffectiveCost]);
