SELECT  to_char(ual.created_on,'MM/DD/YYYY') as month_and_year,
         count(distinct ual.userid), 
		 usr.email
--CASE WHEN org.query_string3 =':14764459200:' THEN 'Univar Canada'
		  --WHEN org.query_string3 =':640100:' THEN 'Univar US' END as LBO
FROM xml_user usr, user_audit_log ual
WHERE usr.user_id=ual.userid
--AND usr.query_string3 = ual.id
AND usr.query_string3 in ('640100')
AND ual.created_on > date_trunc('year', now())
AND ual.action='SUCCESSFUL_LOGON'
AND usr.email like '%@univar%'
Group by to_char(ual.created_on,'MM/DD/YYYY'),usr.email