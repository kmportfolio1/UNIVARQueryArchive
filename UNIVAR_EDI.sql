SELECT query_string6 as vendor_number,query_string11 as vendor_name, misc5 as IS
FROM xml_org
WHERE query_string3=':640100:'
AND misc5 like '%EDI%'
AND query_string7='ACTIVE'
