USE my_shop;

SET FOREIGN_KEY_CHECKS = 0; -- 비활성화
truncate table products;
truncate table customers;
truncate table orders;
SET FOREIGN_KEY_CHECKS = 1; -- 활성화