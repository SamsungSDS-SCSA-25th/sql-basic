-- 각 상품의 카테고리별로, 가장 비싼 상품의 이름과 가격을 조회
-- max_price가 카테고리에만 매칭되어, name을 찾아갈 수 없음
-- Inline-View 이용하자!
SELECT p.name,
       p.category,
       p.price
FROM products p
         JOIN (SELECT category, max(price) AS max_price
               FROM products
               GROUP BY category) AS cmp -- Inline-View
              ON p.category = cmp.category
                  AND p.price = cmp.max_price;
