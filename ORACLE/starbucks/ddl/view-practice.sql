-- 뷰 생성 권한 부여하기 -> system 유저 로그인 후 수행
GRANT CREATE VIEW TO starbucks;

-- CREATE VIEW
-- ALTER <- REPLACE로 한다
CREATE OR REPLACE VIEW v_category_order_status AS
SELECT *
FROM customer c
         JOIN ORDER_INFO o ON o.ORDER_ID = c.customer_id;

-- SELECT VIEW
SELECT * FROM v_category_order_status;

-- DROP VIEW
DROP VIEW v_category_order_status;