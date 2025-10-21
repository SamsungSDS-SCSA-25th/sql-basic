-- 문제1
SELECT name, email
FROM users
UNION
SELECT name, email
FROM retired_users;

-- 문제2
SELECT u.name, u.email
FROM users u
WHERE u.user_id IN (SELECT o.user_id
                    FROM orders o
                             JOIN products p ON o.product_id = p.product_id
                    WHERE p.category = '전자기기')
UNION ALL
SELECT u.name, u.email
FROM users u
WHERE user_id IN (SELECT user_id
                  FROM orders o
                  WHERE o.quantity >= 2);

-- 문제3
SELECT created_at AS `이벤트_날짜`,
       '고객 가입'    AS `이벤트_종류`,
       name       AS `상세_내용`
FROM users
UNION ALL
SELECT o.order_date AS `이벤트_날짜`,
       '상품 주문'      AS `이벤트_종류`,
       p.name       AS `상세_내용`
FROM orders o
         JOIN products p ON p.product_id = o.product_id
ORDER BY `이벤트_날짜` DESC;

-- 문제4
SELECT name  AS 이름,
       '고객'  AS 역할,
       email AS 이메일
FROM users
UNION ALL
SELECT name                         AS 이름,
       '직원'                         AS 역할,
       CONCAT(name, '@my-shop.com') AS 이메일
FROM employees
ORDER BY 이름;