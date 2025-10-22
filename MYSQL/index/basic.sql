-- 인덱스 생성
CREATE INDEX idx_items_item_name ON items(item_name);

-- 인덱스 조회
-- 기본기(PK)와 외래키(FK), UNIQUE가 붙은 칼럼 -> 인덱스를 자동생성한다.
SHOW INDEX FROM items;

SHOW INDEX FROM sellers; -- 참고

-- 인덱스 삭제
DROP INDEX idx_items_item_name ON items;

-- 인덱스를 사용하는지 확인 (실제 쿼리를 실행하지는 않는다) -> EXPLAIN
-- 컬럼 값을 통해 성능 확인
-- 인덱스 x -> type: ALL, key: null (풀테이블 스캔)
EXPLAIN
SELECT *
FROM items
WHERE item_name = '게이밍 노트북';

CREATE INDEX idx_items_item_name ON items(item_name);
-- 인덱스 o -> type: ref(=), key: idx_items_item_name(인덱스 사용)
EXPLAIN
SELECT *
FROM items
WHERE item_name = '게이밍 노트북';

DROP INDEX idx_items_item_name ON items;