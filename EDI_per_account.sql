SELECT *
FROM xml_org
WHERE query_string3 =':640100:'
AND misc5 like '%EDI%' 
OR misc5 like '%XML%' 
OR misc5 like '%CIDX%'
--AND misc5 <>''
AND status ='ACTIVE'
AND created_on > date_trunc('year', now())
Group by 


