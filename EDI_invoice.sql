SELECT *
FROM xml_invoice
WHERE receiver_id = '640100'
AND created_by='Univar SystemUser'
or created_by='Volpak SystemUser'
AND created_on between '2020-01-01 00:00:00' and '2020-08-13 23:59:59'
--AND created_on > date_trunc('year', now())
AND query_string3 like 'merch%'
limit 100
--string 12 will be UnivarCA's Lawson Accounting Unit -->
--<!-- date 4 will be the date that the invoice was submitted (same as the invoice date) -->
--<!-- string 4 will be the credit type (Credit or Not) -->
