-- 문제1
-- Q. products 테이블에서 가장 비싼 상품?
SELECT product_id,
       name,
       price
FROM products
WHERE price = (SELECT MAX(price) FROM products);

-- 문제2
-- Q. order_id=1 과 동일한 상품을 주문한 (product_id 동일) 주문을 조회 (본인 제외)
SELECT order_id,
       user_id,
       order_date
FROM orders
WHERE product_id = (SELECT product_id FROM orders WHERE order_id = 1)
  AND order_id != 1;

-- 문제3
-- Q. 고객별 총 주문횟수는? user_id 기준 오름차순 -> 상관 서브쿼리 사용해라
SELECT
    name AS `고객명`,
    (SELECT COUNT(*) FROM orders o WHERE o.user_id = u.user_id) AS `총 주문횟수`
FROM users u
ORDER BY user_id;