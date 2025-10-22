-- SELECT Subquery

-- 비상관 Subquery
-- 여기는 스칼라 Subquery만 가능하다.
-- 잘 사용안할 것 같음 => 아래 상관 서브쿼리 형태로 많이 사용할듯?
SELECT
    product_id,
    name,
    (SELECT AVG(price) FROM products) AS avg_price
FROM products;

-- 상관 Subquery
-- `실무에서 많이 사용한다`
SELECT product_id,
       name,
       price,
       (SELECT COUNT(*)
        FROM orders o
        WHERE o.product_id = p.product_id)
           AS order_count
FROM products p;

-- JOIN으로 리팩토링
SELECT p.product_id,
       p.name,
       p.price,
       COUNT(o.order_id) AS order_count
FROM products p
         LEFT JOIN orders o
                   ON o.product_id = p.product_id
GROUP BY p.product_id, p.name, p.price;