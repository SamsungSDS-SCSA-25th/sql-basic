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
FROM products
ORDER BY CASE
             WHEN price >= 100000 THEN 0
             WHEN price >= 30000 THEN 1
             ELSE 2
             END;

-- CASE문 그룹핑 (실무에서 많음!!!)
-- Q. 1990, 1980, 그 이전 '분류' -> 각 그룹에 고객이 몇명 '집계'?
SELECT CASE
           WHEN year(birth_date) >= 1990 THEN '1990년대생'
           WHEN year(birth_date) >= 1980 THEN '1980년대생'
           ELSE '그 이전 출생'
    END         AS birth_group
     , COUNT(*) AS count
FROM users
GROUP BY birth_group; -- MySQL에서 별칭 허용 / 논리적으로는 안됨

-- CASE 조건부 집계
-- 집계함수 내에서 CASE 사용하는 사례
-- 서브쿼리로 컬럼만큼 COUNT()하는 것보다 빠름 / 한번의 조회로 컬럼처리하므로
SELECT
    COUNT(*) AS total_count,
    SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count,
    SUM(CASE WHEN status = 'SHIPPED' THEN 1 ELSE 0 END) AS shipped_count,
    SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) AS pending_count
FROM orders;

-- 위에서 카테고리별로 정리하라고 요구사항 추가됨 ***
SELECT category,
       COUNT(*)                                              AS total_count,
       SUM(CASE WHEN status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count,
       SUM(CASE WHEN status = 'SHIPPED' THEN 1 ELSE 0 END)   AS shipped_count,
       SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END)   AS pending_count
FROM orders
         JOIN products ON orders.product_id = products.product_id
GROUP BY category;