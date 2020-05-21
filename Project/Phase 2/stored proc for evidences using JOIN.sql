/*Stored Procedure to insert records o	For each row from MODEL table having score TRUE, 
fetch each row from ACCESSRULE table and insert ar_id, m_id into Comparison table */

DELIMITER //

create procedure insertComparison()
BEGIN 

insert into Comparison (A_ar_id,M_m_id)
select ar_id, m_id
from ACCESSRULE, MODEL
where score = 'TRUE';

select * from Comparison;

END //

DELIMITER ;


/* Created a stored procedure i.e. getEvidence() to get all evidence of discrepancies 
happened during comparison between MODEL and ACCESSRULE table. 

NOTE: We have called insertComparison() stored procedure in getEvidence() stored procedure, so we can run getEvidence() procedure once directly
		to get the actual results */


DELIMITER //

create procedure getEvidence()
BEGIN

call insertComparison();

insert into DISCREPANCY (m_id,ar_id,time,requestor,role,component,request_type,violation_type,score)
select m.m_id,c.A_ar_id,m.time,m.requestor,m.role,m.component,m.request_type,m.violation_type,m.score
from 
MODEL m
left join Comparison c
on m.m_id = c.M_m_id
left join ACCESSRULE ar
on ar.ar_id = c.A_ar_id
where 
m.role <> ar.role
and m.requestor <> ar.requestor
and m.request_type <> ar.request_type
and m.time NOT between ar.start_time and ar.end_time
and m.component <> ar.component
order by m.m_id, ar.ar_id;

END //

DELIMITER ;





#### Call to getEvidence() stored procedure ######

call getEvidence();

