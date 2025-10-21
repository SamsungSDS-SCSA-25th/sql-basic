-- 기초
SELECT *
FROM orders -- 기준
         INNER JOIN users -- 대상
                    ON orders.user_id = users.user_id;


-- 필요한 열만 뽑기 (열이름이 하나만 있으면 테이블명 생략가능)
-- 순서
-- FROM/JOIN -> WHERE -> SELECT
-- MySQL 내부 엔진 -> 쿼리최적화로 물리적 순서는 달라질 수 있음
SELECT u.user_id,
       u.name,
       o.order_date
FROM orders o -- 기준 / (AS) 별칭 -> FROM에서는 보통 AS 생략
         INNER JOIN users u -- 대상 / (AS) 별칭
                    ON o.user_id = u.user_id
WHERE o.status = 'COMPLETED';


-- 문제1
SELECT o.order_id,
       p.name,
       o.quantity
FROM orders o
         INNER JOIN products p
                    ON o.product_id = p.product_id
ORDER BY o.order_id;


-- 문제2
SELECT o.order_id,
       u.name,
       p.name,
       o.order_date
FROM orders o
         INNER JOIN products p
                    ON o.product_id = p.product_id
         INNER JOIN users u
                    ON o.user_id = u.user_id
WHERE o.status = 'SHIPPED'
ORDER BY o.order_id;

-- 문제3
SELECT u.name,
      SUM(p.price * o.quantity) AS total_purchase_amount -- 집계함수 써야함 GROUP BY 때문
FROM orders o
         INNER JOIN products p
                    ON o.product_id = p.product_id
         INNER JOIN users u
                    ON o.user_id = u.user_id
GROUP BY u.name
ORDER BY total_purchase_amount DESC;