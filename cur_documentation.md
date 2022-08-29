# AWS Cost and Usage Report Documentation

The [Developer's Guide to AWS Costs](https://github.com/getmacroscope/developer-cost-guide) is an open-source project that helps engineers understand their AWS costs. In the first post for the Developer's Guide to AWS Costs, we walked through how to create the Cost and Usage Report. This is the most detailed billing report AWS offers and is the only resource developer's need to start understanding what is driving their costs.

This report has over 200 descriptive fields and includes a line item for every resource, every hour it was running. To help engineers understand this immense amount of detail, we've decided to add this set of documentation to help add to the [AWS documentation](https://docs.aws.amazon.com/cur/latest/userguide/what-is-cur.html) already available. This set of documentation will be updated on a regular basis as AWS pricing models change and new products are introduced. 

Each field will be shown with the default field naming structure, will contain a description of what information that field holds, and will provide sample values. None of these fields will show an exhaustive list of possible field values.

<br>

## Data Categories

The following table shows the data categories in the Cost and Usage Report and their current status (not started, in progress, or up to date). 

| Category                | Status      |
| ----------------------- | ----------- |
| [Bill](##Bill)          | Up to date  |
| [Identity](##Identity)  | Up to date  |
| [Pricing](##Pricing)    | Up to date  |
| Line Item               | Not Started |
| Product                 | Not Started |
| Reservation             | Not Started |
| Savings Plan            | Not Started |

<br>



## Bill

Bill fields provide details that help users tie costs back to a specific invoice, identify the dates of that invoice, and distinguish between AWS and AWS Marketplace charges. 

### bill/InvoiceId

Once your bill is final, this field will be populated with a unique ID for the invoice each line item of cost is tied to. This can be helpful if your organization has multiple management accounts or makes purchases from the AWS  Marketplace.

**Sample Values**

`1082136945`<br>
`1082025277`

### bill/InvoicingEntity

The legal entity that is sending the invoice for your AWS spend. There are three  possible invoicing entities:<br>

1. Amazon Web Services EMEA SARL - used for customers based in Europe, the  Middle East, and Africa (excluding South Africa).

2. Amazon Internet Services Pvt. Ltd - used for customers based in  India.<br>
3. Amazon Web Services, Inc. - Issue to all other global customers.

**Sample Values**

`Amazon Web Services, Inc.`

### bill/BillingEntity

This is the seller of the services you are being billed for. This can be different from the invoicing entity. There are three possible values for this  field:<br>

1. AWS - Amazon Web Services sells the AWS services.<br>
2. AISPL - Amazon Internet Servies Pvt. Ltd which is the local reseller for  AWS services in India.<br>
3. AWS Marketplace - the AWS Marketplace is the billing entity for any third-party software purchased in the AWS Marketplace.

**Sample Values**

`AWS Marketplace`<br>
`AWS`

### bill/BillType

The bill type describes the type of charges covered in this report. There are three bill types:<br>

1. Anniversary - billing associated with the services used during the month.<br>
2. Purchase - line items for upfront service fees.<br>
3. Refund - any line items for refunds. This is particularly useful for isolating costs associated with Enterprise Discount Programs.

**Sample Values**

`Anniversary`

### bill/PayerAccountId

The account ID for the account paying the bill. If your team is using AWS  Organizations, this will be the account ID for the management account. 

**Sample Values**

`847782638323`

### bill/BillingPeriodStartDate

The start date of the billing period for each line item. Dates and times are in  UTC. The standard format for this field is: `YYYY-MMDDTHH:mm:ssZ`

**Sample Values**

`2022-03-01T00:00:00Z`

### bill/BillingPeriodEndDate

The end date of the billing period for each line item. Dates and times are in UTC.  The standard format for this field is: `YYYY-MMDDTHH:mm:ssZ`

**Sample Values**

`2022-04-01T00:00:00Z`

<hr/>

<br>

## Identity

Identity fields have a standard format that provides a unique ID for each line item in a single version of a CUR and a way to identify the time interval for that line item.

### identity/LineItemId

Unique  ID for a line item in a single version of the CUR. If multiple report versions are saved for the same day, this ID will be consistent across the multiple report versions. This field is 52-characters long.

**Sample Values**

`j082q1jy7b49ais76p31209n460020vhkjk4g4658bt89b90invt`<br>`m9381dlr3ojvwhx0ng533111y6v3s395uf42jso5wk30cwxsp341`<br>`9hlquybws83r6z3p3pvb195dbmyjj7jh786e3wc1tu8ikv5czh0x`<br>`45174wur23b82t68l1wkrr6pda5o40m79uuk3sgn593j99bfh251`<br>`xxgxbl63gcgu60oe07mnh1bu6202lm0r5pz107cv7b4iel19s9gl`

### Identity/TimeInterval

UTC time interval for the CUR report line item. CUR report intervals are either hourly or daily depending on the settings chosen when the report was created.  Standard format:
`YYYY-MM-DDTHH:mm:ssZ/YYYY-MM-DDTHH:mm:ssZ`

**Sample Values**

`2022-01-01T00:00:00Z/2022-01-02T00:00:00Z`<br>`2022-01-31T14:00:00Z/2022-01-31T15:00:00Z`

<hr/>

<br>

## Pricing

Pricing fields provide information on the rates, terms, and pricing units that are used to determine what AWS users are charged for each line item in the report. There is some duplication between these fields and the Reservation and Savings Plan fields for term and purchase options. 

### pricing/RateCode

A unique code for a product, offer, and pricing-tier combinations. 

**Sample Values**

`5HJE9C3BMY3VTT6B.JRTCKXETXF.6YS6EN2CT7`<br>`39YMM87R7C62S2FB.JRTCKXETXF.7A9VFYDHVN`

### pricing/RateId

The ID  of the rate for a line item. 

**Sample Values**

`123456789`

### pricing/currency

This is another field that provides a currency code. This field is inconsistent and does not populate for every line item. It is better to refer to the lineItem/CurrencyCode instead of this field.

**Sample Values**

`USD`

### pricing/publicOnDemandCost

The cost for the line item is based on public on-demand rates. If there are multiple rates available, the highest cost is used to calculate the cost.

**Sample Values**

Numerical value. Recommend rounding to 4 decimal places during analysis.

### pricing/publicOnDemandRate

The public on-demand instance rate for every line item of usage. If there are multiple rates, the highest rate is displayed. 

**Sample Values**

Numerical value. Recommend rounding to 4 decimal places during analysis.

### pricing/term

This field is ‘Reserved’ when your usage is reserved or ‘OnDemand’ if the usage is on-demand. In this case, ‘Reserved’ will also indicate the use of savings plans. 

**Sample Values**

`Reserved`<br>`OnDemand`

### pricing/unit

The different pricing units that are used to calculate costs. This is the unit the linItem/UsageAmount represents. This filter is helpful if you're trying to isolate costs that change based on how your resource is utilized.

**Sample Values**

`ACU-Hr`<br>`API Calls`<br>`API Requests`<br>`Alarms`<br>`CertificateAuthorities`<br>`ConfigRuleEvaluations`<br>`ConfigurationItemRecorded`<br>`ConsumerShardHour`<br>`Count`<br>`DPU-Hour` <br>`Dashboards`<br>`Dollar`<br>`Dollars`<br>`Events`<br>`GB`<br>`GB-Hours`<br>`GB-Mo`<br>`GB-month`<br>`GigaBytes`<br>`HostedZone`<br>`Hourly`<br>`Hours`

### pricing/LeaseContractLength

The length of time a Reserved Instance is reserved for.

**Sample Values**

`1yr`<br>`3yr`

### pricing/PurchaseOption

Purchase option is for reservations and savings plans. There are only three options for purchase reservations that can be populated here.

**Sample Values**

`All  Upfront`<br>`Partial Upfront`<br>`No Upfront`



