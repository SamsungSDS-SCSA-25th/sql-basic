-- `단일 열 서브쿼리`

-- Scalar (=, <, >)
-- 주문번호가 1인 사람의 주소와 같은 사람들을 출력하라
SELECT name,
       address
FROM users
WHERE address = (SELECT u.address
                 FROM orders o
                          JOIN users u ON u.user_id = o.user_id
                 WHERE o.order_id = 1);

-- Multi-Row (IN, ANY, ALL)
-- '전자기기' 카테고리의 적어도 하나보다 비싼 상품 찾기
-- (동치) "'전자기기' 가테고리의 가장 저렴한 상품보다 비싸면 됩니다."
SELECT name,
       price
FROM products
WHERE category != '전자기기'
  AND price > ANY (SELECT price
                   FROM products
                   WHERE category = '전자기기');

-- IN + MIN 으로 리팩토링 => ANY보다 더 직관적임
SELECT name,
       price
FROM products
WHERE category != '전자기기'
  AND price > (SELECT MIN(price)
                   FROM products
                   WHERE category = '전자기기');