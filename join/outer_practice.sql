-- Q. 한번도 주문하지 않은 고객은 누구인가
-- 이 사람들에게만 특별할인 쿠폰을 보내는 비즈니스 로직이 가능할 것이다.
SELECT u.user_id,
       u.name,
       o.user_id,
       o.order_id
FROM users u
         LEFT JOIN orders o
                   ON u.user_id = o.user_id
WHERE o.user_id IS NULL;
-- ORDER BY u.user_id;

-- Q. 한번도 팔리지 않은 상품 찾기
SELECT p.product_id,
       p.name,
       p.price
FROM products p
         LEFT JOIN orders o
                   ON p.product_id = o.product_id
WHERE o.order_id IS NULL;

-- LEFT와 RIGHT JOIN은 기능상 완전히 똑같아서, FROM에 기준 테이블을 작성하는 LEFT JOIN이 실무에 많이 쓰인다.