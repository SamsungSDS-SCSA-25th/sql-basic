ALTER USER STARBUCKS QUOTA UNLIMITED ON USERS;

-- DDL (CREATE, ALTER, DROP)
-- DML (INSERT, UPDATE, DELETE)
-- DCL (GRANT, REVOKE)

-- CREATE TABLE
CREATE TABLE product
(
    prod_no    CHAR(5) PRIMARY KEY,
    prod_name  VARCHAR2(30) UNIQUE NOT NULL,
    prod_price NUMBER(6)
);

-- ALTER TABLE
ALTER TABLE product
ADD prod_quantity NUMBER(14);

-- column 수준 constraint (NOT NULL은 무조건 column 수준)
ALTER TABLE product
MODIFY prod_quantity NUMBER(14) CONSTRAINT nn_quantity NOT NULL;

-- table 수준 constraint
ALTER TABLE product
ADD CONSTRAINT nn_price CHECK (prod_price > 0);

ALTER TABLE product
DROP COLUMN prod_quantity;

ALTER TABLE product
DROP CONSTRAINT nn_price;

-- DROP TABLE
DROP TABLE product;

-- TABLE 내 데이터 모두 날리기 vs DELETE
TRUNCATE TABLE product;


INSERT INTO product
VALUES ('C0001', 'americano', 1000, 10);
INSERT INTO product -- PK 제약이 있어서 그렇다,.
VALUES ('C0001', 'americano', 1000, 2);

SELECT * FROM product;