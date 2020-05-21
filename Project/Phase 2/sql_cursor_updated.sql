use sync;
DELIMITER //
CREATE PROCEDURE getEvidenceByCursor()
BEGIN
			DECLARE done INT DEFAULT FALSE;
			DECLARE m_id INT;
            DECLARE ar_id INT;
			DECLARE time datetime;
            DECLARE start_time time;
            DECLARE end_time time;
           	DECLARE m_requestor varchar(20);
            DECLARE ar_requestor varchar(20);
           	DECLARE m_role varchar(15);
            DECLARE ar_role varchar(15);
           	DECLARE m_component varchar(10);
			DECLARE ar_component varchar(10);
           	DECLARE m_request_type varchar(10);
            DECLARE ar_request_type varchar(10);
           	DECLARE violation_type varchar(30);
           	DECLARE score varchar(5);
            
  DECLARE cur1 CURSOR FOR 
		SELECT m_id, time, requestor, role, component, request_type, violation_type, score
		FROM MODEL WHERE score = 'TRUE';
        
  DECLARE cur2 CURSOR FOR 
		SELECT ar_id,role,start_time,end_time,component,request_type,requestor
		FROM ACCESSRULE;
        
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN cur1;
  OPEN cur2;

  read_loop: LOOP
    FETCH cur1 INTO m_id, time, m_requestor, m_role, m_component, m_request_type, violation_type, score;
    FETCH cur2 INTO ar_id, ar_role, start_time,end_time,ar_component,ar_request_type,ar_requestor;
    
    IF done THEN
      LEAVE read_loop;
    END IF;
    IF (m_role <> ar_role AND (time NOT BETWEEN start_time AND end_time) AND m_component <> ar_component 
		AND m_request_type <> ar_request_type AND m_requestor <> ar_requestor)
	THEN
      INSERT INTO DISCREPANCY VALUES (m_id, ar_id, time, requestor, role, component, request_type, violation_type, score);
	END IF;
  END LOOP;

  CLOSE cur1;
  CLOSE cur2;
END //

DELIMITER ;

call getEvidenceByCursor();

###### I am not getting any error while execution that's why I am unable to figure out exact cause of cursor failure. ###########