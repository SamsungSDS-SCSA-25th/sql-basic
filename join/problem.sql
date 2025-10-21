-- 문제1
SELECT p.name,
       p.price
FROM products p
         LEFT JOIN orders o
                   ON p.product_id = o.product_id
WHERE p.category = '전자기기' AND o.order_id IS NULL;

-- 문제2
SELECT u.name,
       COUNT(order_id)
FROM users u
         LEFT JOIN orders o
                   ON u.user_id = o.user_id
GROUP BY u.name
ORDER BY u.name;

-- 문제3
SELECT u.name,
       u.email
FROM orders o
         RIGHT JOIN users u
                    ON o.user_id = u.user_id
WHERE o.order_id IS NULL;

-- 문제4 ***
SELECT u.name AS user_name,
       p.name AS product_name
FROM orders o
         RIGHT JOIN users u
                   ON u.user_id = o.user_id
         LEFT JOIN products p
                   ON p.product_id = o.product_id
ORDER BY user_name, product_name;

-- 서울 지역 고객의 총 주문금액 계산하기
SELECT u.name,
       SUM(p.price * o.quantity) AS total_spent
FROM orders o
         JOIN users u ON u.user_id = o.user_id
         JOIN products p ON o.product_id = p.product_id
WHERE u.address LIKE '서울%'
GROUP BY u.name
ORDER BY total_spent DESC;