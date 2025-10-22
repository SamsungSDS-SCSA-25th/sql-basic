-- 문제1
DROP VIEW IF EXISTS v_customer_email_list;

CREATE VIEW v_customer_email_list AS
    SELECT
        user_id,
        name,
        email
    FROM users;

SELECT * FROM v_customer_email_list;

-- 문제2
DROP VIEW IF EXISTS v_order_summary;

CREATE VIEW v_order_summary AS
    SELECT order_id,
           u.name AS 고객명,
           p.name AS 상품명,
           o.quantity AS 주문수량,
           o.status AS 주문상태
    FROM users u
             JOIN orders o ON u.user_id = o.user_id
             JOIN products p ON p.product_id = o.product_id;

SELECT * FROM v_order_summary;

-- 문제3
DROP VIEW IF EXISTS v_electronic_sales_status;

CREATE VIEW v_electronic_sales_status AS
    SELECT category,
           COUNT(order_id)           AS total_orders,
           SUM(o.quantity * p.price) AS total_sales
    FROM products p
             JOIN orders o ON p.product_id = o.product_id
    GROUP BY category;

SELECT *
FROM v_electronic_sales_status
WHERE category = '전자기기';

-- 문제4
ALTER VIEW v_electronic_sales_status AS
    SELECT category,
           COUNT(order_id)           AS total_orders,
           SUM(o.quantity * p.price) AS total_sales,
           AVG(o.quantity * p.price) AS avg_sales
    FROM products p
             JOIN orders o ON p.product_id = o.product_id
    GROUP BY category;

SELECT *
FROM v_electronic_sales_status
WHERE category = '전자기기';