DROP VIEW IF EXISTS v_category_order_status; -- 만약 뷰가 존재하면 제거

-- 복잡한 쿼리 view 만들기
CREATE VIEW v_category_order_status AS
    SELECT p.category,
           COUNT(*)                                                AS total_orders,
           SUM(CASE WHEN o.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count,
           SUM(CASE WHEN o.status = 'SHIPPED' THEN 1 ELSE 0 END)   AS shipped_count,
           SUM(CASE WHEN o.status = 'PENDING' THEN 1 ELSE 0 END)   AS pending_count
    FROM orders o
             JOIN products p ON o.product_id = p.product_id
    GROUP BY p.category;

-- view 조회
SELECT * FROM v_category_order_status;

-- view 수정
ALTER VIEW v_category_order_status AS
    SELECT p.category,
           COUNT(*)                                                AS total_orders,
           SUM(p.price * o.quantity)                               AS total_sales,
           SUM(CASE WHEN o.status = 'COMPLETED' THEN 1 ELSE 0 END) AS completed_count,
           SUM(CASE WHEN o.status = 'SHIPPED' THEN 1 ELSE 0 END)   AS shipped_count,
           SUM(CASE WHEN o.status = 'PENDING' THEN 1 ELSE 0 END)   AS pending_count
    FROM orders o
             JOIN products p ON o.product_id = p.product_id
    GROUP BY p.category;

-- view 조회
SELECT * FROM v_category_order_status;

-- view 삭제
DROP VIEW v_category_order_status;