-- 단순 CASE문
SELECT order_id,
       user_id,
       product_id,
       quantity,
       status,
       CASE status
           WHEN 'PENDING' THEN '주문 대기'
           WHEN 'COMPLETED' THEN '결제 완료'
           WHEN 'SHIPPED' THEN '배송'
           WHEN 'CANCELLED' THEN '주문 취소'
           ELSE '알 수 없음' -- 예상치 못한 상태 값 처리
           END AS status_korean
FROM orders;

-- 조건 CASE문
SELECT name,
       price,
       CASE
           WHEN price >= 100000 THEN '고가'
           WHEN price >= 30000 THEN '중가'
           ELSE '저가'
           END AS price_level
FROM products;

-- 중




