-- 초기화
SHOW INDEX FROM items;

DROP INDEX idx_items_item_name ON items;
DROP INDEX idx_items_price_name ON items;
DROP INDEX idx_items_price ON items;
DROP INDEX idx_items_price_category_temp ON items;
DROP INDEX idx_items_category_price ON items;

-- 풀이
SELECT * FROM items
WHERE category = '전자기기' AND is_active = TRUE;

EXPLAIN SELECT * FROM items
        WHERE category = '전자기기' AND is_active = TRUE;

CREATE INDEX idx_items_category_is_active_stock_quantity ON items(category, is_active, stock_quantity DESC);
-- DROP INDEX idx_items_category_is_active_stock_quantity ON items;

EXPLAIN SELECT * FROM items
WHERE category = '전자기기' AND is_active = TRUE;

EXPLAIN SELECT * FROM items
        WHERE category = '전자기기' AND is_active = TRUE
        ORDER BY stock_quantity DESC;

-- 참고
EXPLAIN SELECT * FROM items
        WHERE category = '전자기기' AND is_active = TRUE
        ORDER BY stock_quantity;