SELECT  to_char(ual.created_on,'MM/DD/YYYY') as month_and_year,
         count(distinct ual.userid), 
		 org.query_string6 as vendor_number,
		 usr.email,
CASE WHEN org.query_string3 =':14764459200:' THEN 'Univar Canada'
		  WHEN org.query_string3 =':640100:' THEN 'Univar US' END as LBO
FROM xml_user usr, user_audit_log ual, xml_org org
WHERE ual.userid = usr.user_id 
AND usr.query_string3 = org.id
AND org.query_string3 in (':14764459200:',':640100:')
AND ual.created_on > date_trunc('year', now())
AND ual.action='SUCCESSFUL_LOGON'
Group by to_char(ual.created_on,'MM/DD/YYYY'), org.query_string3,usr.email,org.query_string6 ORDER BY 1
