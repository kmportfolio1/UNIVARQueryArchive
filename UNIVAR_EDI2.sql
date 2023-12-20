with x as(select created_by,sender_id,id,query_string19,created_on,query_String9,batch_id, query_string3
       from xml_invoice 
       where receiver_id = '640100'
		and query_string9 = 'UnivarGeneratedInvoice' and created_by = 'Vopak SystemUser'  
        and created_on > date_trunc('year', now())
        and status not in ('New', 'Deleted', 'Draft', 'ErrorDraft', 'DraftIncomplete'))
       select
       coalesce((select query_string6 from xml_org xo where x.sender_id = xo.id),'UNKNOWN') as Vendor_Number
       ,coalesce((select query_string11 from xml_org xo where x.sender_id = xo.id),'UNKNOWN') as Vendor_Name
       ,coalesce((select status from xml_org xo where x.sender_id = xo.id),'UNKNOWN') as Vendor_Status
       ,coalesce((select TO_CHAR(xu.created_on, 'MM/DD/YYYY') from xml_org xo, xml_user xu
                  where x.sender_id = xo.id and xo.id = xu.query_string2
                  order by xu.created_on asc limit 1),'--') as Vendor_Enrollment_Date
       ,coalesce((select xu.first_name || ' ' || xu.last_name from xml_org xo, xml_user xu
                 where x.sender_id = xo.id and xo.id = xu.query_string2 order by xu.created_on asc limit 1),'--') as Vendor_Enroller_Admin_Name
       ,coalesce((select xu.email from xml_org xo, xml_user xu where x.sender_id = xo.id and xo.id = xu.query_string2
        order by xu.created_on asc limit 1),'--') as Vendor_Enroller_Admin_Email
       ,(case when ((coalesce((select query_num2 from xml_org xo where x.sender_id = xo.id),0)) > 0) then 'Yes' else 'No' end) as Vendor_File_Upload_Status
       ,sum((CASE WHEN (query_string9 = 'CarolinasSubmittedInvoice' and created_by <> 'System User') or(query_string19 is not null and batch_id = '') THEN 1 ELSE 0 END)) as Po_Flip
       ,sum((CASE WHEN query_string19 is null and batch_id <>'' and (query_string3 = 'CarolinasStandardInvoiceWithPO' and query_string9 = 'CarolinasSubmittedInvoice') THEN 1 ELSE 0 END)) as File_Upload_PO
       ,sum((CASE WHEN query_string19 is null and batch_id <>'' and (query_string3 = 'CarolinasStandardInvoiceWithoutPO' and query_string9 = 'CarolinasSubmittedInvoice') THEN 1 ELSE 0 END)) as File_Upload_NonPO
       ,sum((CASE WHEN query_string19 is not null and batch_id <>'' and query_string3 = 'CarolinasStandardInvoiceWithPO' THEN 1 ELSE 0 END)) as ScanOne_PO
       ,sum((CASE WHEN query_string19 is not null and batch_id <>'' and query_string3 = 'CarolinasStandardInvoiceWithoutPO' THEN 1 ELSE 0 END)) as ScanOne_NonPO
       --,sum((CASE WHEN query_string19 is not null and query_string9 = 'CarolinasGeneratedInvoice' and created_by = 'System User' THEN 1 ELSE 0 END)) as Atrium_Health
	   ,sum(invoice_total) as spend
	   --,sum((Select invoice_total From x WHERE query_string9 <> 'CarolinasGeneratedInvoice' and created_by <> 'System User')) as Spend1
	   ,count(*) as Total
	   --,sum((CASE WHEN query_string9='CarolinasGeneratedInvoice' or created_by= 'System User'THEN 0 ELSE invoice_total END)) as total_spend
	   --(select sum(invoice_total) from x where query_string9<> 'CarolinasGeneratedInvoice' AND created_by <>'System User') as Spend
       from x
       where x.created_on between '2019-03-01 00:00:00' and '2020-03-23 23:59:59'
       group by 1,2,3,4,5,6,7
       order by 8,9 desc, 2