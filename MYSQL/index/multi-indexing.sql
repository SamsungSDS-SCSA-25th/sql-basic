-- 복합 인덱스
-- 1. **인덱스는 순서대로 사용하라!** (왼쪽 접두어 규칙)
-- 2. **등호(=) 조건은 앞으로, 범위 조건(<, >)은 뒤로!**
-- 3. **정렬(ORDER BY)도 인덱스 순서를 따르라!**

-- 생성전 확인
SHOW INDEX FROM items;

-- 기준 category-price
-- why? category(=), price(>)
CREATE INDEX idx_items_category_price ON items (category, price);

-- 예제1: category
-- type: ref
-- key: idx_items_category_price
-- rows: 100
-- filtered: 100.00
-- Extra: null
EXPLAIN SELECT * FROM items WHERE category = '전자기기';

-- 예제2: category, price
-- type: ref
-- key: idx_items_category_price
-- rows: 1
-- filtered: 100.00
-- Extra: null
EXPLAIN SELECT * FROM items WHERE category = '전자기기' AND price = 120000;

-- 예제3: filesort 없이 정렬
-- type: range
-- key: idx_items_category_price
-- rows: 8
-- filtered: 100.00
-- Extra: Using index condition (filesort <- '병목'가 아님)
EXPLAIN SELECT * FROM items WHERE category = '전자기기' AND price > 100000 ORDER BY price;


-- 기준 price-category
-- why? price(=), category(<)
CREATE INDEX idx_items_price_category_temp ON items (price, category);

-- 임시방편
EXPLAIN SELECT * FROM items WHERE category >= '패션' AND price = 20000;

-- 근본적인 쿼리문 고치기 IN 사용
EXPLAIN SELECT * FROM items WHERE category IN ('패션', '헬스/뷰티') AND price = 20000;