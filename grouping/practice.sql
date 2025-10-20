SELECT * FROM order_stat;

SELECT
    COUNT(*),
    COUNT(category)
FROM
    order_stat;
SELECT
    SUM(price * quantity) AS `총 매출액`,
    AVG(price * quantity) AS `평균 주문금액`
FROM
    order_stat;
SELECT
    SUM(quantity) AS `총 판매수량`,
    AVG(quantity) AS `주문당 평균수량`
FROM
    order_stat;
SELECT
    MAX(price) AS `최고가`,
    MIN(price) AS `최저가`
FROM
    order_stat;

-- 주문한 고객의수 중복방지 카운트!
SELECT
    COUNT(customer_name) AS `총 주문 건수`,
    COUNT(DISTINCT customer_name) AS `순수 고객 수`
FROM
    order_stat;






