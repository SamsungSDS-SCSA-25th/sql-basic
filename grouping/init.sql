CREATE TABLE order_stat (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(50),
    category VARCHAR(50),
    product_name VARCHAR(100),
    price INT,
    quantity INT,
    order_date DATE
);