ALTER USER STARBUCKS QUOTA UNLIMITED ON USERS;

CREATE TABLE product
(
    prod_no    CHAR(5) PRIMARY KEY,
    prod_name  VARCHAR2(30),
    prod_price NUMBER(6)
);


INSERT INTO product
VALUES ('C0001', 'americano', 1000);
INSERT INTO product -- PK 제약이 있어서 그렇다,.
VALUES ('C0001', 'americano', 1000);
