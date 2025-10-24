-- INSERT
INSERT INTO CUSTOMER
VALUES (1, 'Sam', 'd@gmail.com', 'M');

INSERT INTO CUSTOMER (CUSTOMER_ID, CUSTOMER_NAME, CUSTOMER_EMAIL, CUSTOMER_GENDER)
VALUES (2, 'Aaron', 'a@gmail.com', 'M');

INSERT INTO CUSTOMER (CUSTOMER_ID, CUSTOMER_NAME, CUSTOMER_EMAIL, CUSTOMER_GENDER)
VALUES (3, 'Leo', 'l@gmail.com', 'M');

SELECT * FROM CUSTOMER;

-- UPDATE
UPDATE CUSTOMER
SET CUSTOMER_GENDER = 'F'
WHERE CUSTOMER_ID = 1;

SELECT * FROM CUSTOMER;

-- !!! 중요한 기법
-- sequence를 활용한 INSERT
DROP SEQUENCE order_seq;
CREATE SEQUENCE order_seq;

INSERT INTO ORDER_INFO(order_no, order_dt, order_id)
VALUES (order_seq.nextval, SYSDATE, 1);

INSERT INTO ORDER_INFO(order_no, order_dt, order_id)
VALUES (order_seq.nextval, SYSDATE, 2);

-- 날짜 연산하기
-- TO_CHAR로 형식을 정하여 비교한다
SELECT *
FROM ORDER_INFO
WHERE TO_CHAR(order_dt, 'YYYYMMDD') = TO_CHAR(SYSDATE, 'YYYYMMDD');

SELECT * FROM CUSTOMER;
SELECT * FROM ORDER_INFO;

INSERT INTO ORDER_INFO(order_no, order_dt, order_id)
VALUES (order_seq.nextval, SYSDATE, 3);

-- INSERT가 실패해도, 위 nextval seqence는 계속 증가한다 (주의)
SELECT order_seq.currval;
