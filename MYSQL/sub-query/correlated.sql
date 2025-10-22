-- 상관 서브쿼리
-- 메인과 서브쿼리가 서로 영향을 준다는 의미

-- 각 상품별로, 자신이 속한 카테고리의 평균가격 이상의 상품들을 찾아라
SELECT product_id,
       name,
       category,
       price
FROM products p1
WHERE price >= (SELECT AVG(price)
                FROM products p2
                WHERE p2.category = p1.category); -- FROM에서 테이블을 2개로 보고 자신과 비교

-- products 테이블에는 있지만, orders 테이블에 한번도 등장하지 않은 `재고`를 제외하고, 실제 주문이 발생한 상품의 이름과 가격을 조회
-- => Table을 만들고, IN `안티패턴`
SELECT name,
       price
FROM products
WHERE product_id IN (SELECT DISTINCT product_id
                     FROM orders);


-- 리팩토링 (product_id 집합없이, 존재하면 바로 탈출하는 로직)
-- => 행을 쭉 돌다가, 주문목록에 존재하면 EXISTS 바로 탈출 break
SELECT product_id,
       name,
       price
FROM products p
WHERE EXISTS (SELECT 1
              FROM orders o
              WHERE o.product_id = p.product_id); -- 행이 존재하면 `true` 바로 탈출!

-- (참고) 재고 상품찾기
SELECT product_id,
       name,
       price
FROM products
WHERE NOT EXISTS (SELECT 1
                  FROM orders o
                  WHERE o.product_id = products.product_id);

-- 상관 서브쿼리는 성능에 유의하자!
-- 메인 쿼리의 행 수만큼 서브쿼리가 반복 수행하기 때문.
-- JOIN이 어렵거나, EXISTS 실행 가능하다면, 상관 서브쿼리 ok

-- DISTINCT로 중복 제거 (JOIN 사용)
SELECT DISTINCT p.product_id,
                p.name,
                p.price
FROM products p
         JOIN orders o
              ON o.product_id = p.product_id;