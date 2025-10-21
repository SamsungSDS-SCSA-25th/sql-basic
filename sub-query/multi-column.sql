-- 다중 열 서브쿼리

-- 단일 행
-- 고객번호=2 & 주문번호=3 & '주문처리'상태인 주문 찾기
SELECT order_id,
       user_id,
       status,
       order_date
FROM orders
WHERE (user_id, status) = (SELECT user_id, status
                           FROM orders
                           WHERE order_id = 3)
  AND order_id != 3; -- 자기 자신은 제외

-- 다중 행
-- 각 고객별로 가장 먼저한 주문의 (주문번호, 고객번호, 고객이름, 제품이름, 주문 날짜) 조회
SELECT o.order_id,
       o.user_id,
       u.name,
       p.name,
       o.order_date
FROM orders o
         JOIN users u ON o.user_id = u.user_id
         JOIN products p ON o.product_id = p.product_id
WHERE (o.user_id, o.order_date) IN (SELECT user_id,
                                           MIN(order_date)
                                    FROM orders
                                    GROUP BY user_id);