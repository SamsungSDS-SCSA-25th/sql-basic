-- 문제1
SELECT name,
       category,
       CASE
           WHEN category = '전자기기' THEN 'Electronics'
           WHEN category = '도서' THEN 'Books'
           WHEN category = '패션' THEN 'Fashion'
           ELSE 'Others'
           END AS category_english
FROM products;

-- 문제2
SELECT order_id,
       quantity,
       CASE
           WHEN quantity >= 2 THEN '다량 주문'
           ELSE '단일 주문'
           END AS order_type
FROM orders
ORDER BY order_type;

-- 문제3 ***
SELECT CASE
           WHEN stock_quantity >= 50 THEN '재고 충분'
           WHEN stock_quantity >= 20 THEN '재고 보통'
           ELSE '재고 부족'
           END AS stock_level,
       COUNT(*) AS product_count
FROM products
GROUP BY stock_level;

-- 문제4 ***
SELECT users.name             AS user_name,
       COUNT(orders.order_id) AS total_orders,
       SUM(CASE
               WHEN products.category = '전자기기' THEN 1
               ELSE 0 END
       )                      AS electronic_orders,
       SUM(CASE
               WHEN products.category = '도서' THEN 1
               ELSE 0 END
       )                      AS book_orders,
       SUM(CASE
               WHEN products.category = '패션' THEN 1
               ELSE 0 END
       )                      AS fashion_orders
FROM orders
         JOIN products ON orders.product_id = products.product_id
         JOIN users ON orders.user_id = users.user_id
GROUP BY user_name;