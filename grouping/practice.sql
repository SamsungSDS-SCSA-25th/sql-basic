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

-- Group By
SELECT
    category,
    COUNT(*) AS `카테고리별 주문 건수`
FROM
    order_stat
GROUP BY
    category;

SELECT
    customer_name,
    COUNT(*) AS `고객의 주문 횟수`
FROM
    order_stat
GROUP BY
    customer_name;

-- ex. VIP고객 찾기 => 총 구매금액 기준
SELECT
    customer_name,
    COUNT(*) AS `총 주문 횟수`,
    SUM(quantity) AS `총 구매 수량`,
    SUM(price * quantity) AS `총 주문 금액`
FROM
    order_stat
GROUP BY
    customer_name
ORDER BY
    `총 주문 금액` DESC;

-- 고객의 카테고리별 구매금액이 궁금
SELECT
    customer_name,
    category,
    COUNT(*) AS `총 주문 횟수`,
    SUM(quantity) AS `총 구매 수량`,
    SUM(price * quantity) AS `총 주문 금액`
FROM
    order_stat
GROUP BY
    customer_name, category
ORDER BY
    `총 주문 금액` DESC;

-- Having => 2회 이상 주문한 충성고객들?
SELECT
    category,
    COUNT(*) AS `카테고리별 주문 건수`
FROM
    order_stat
GROUP BY
    category
HAVING
    COUNT(*) > 1;

-- 종합문제
SELECT
    customer_name,
    SUM(price * quantity) AS total_purchase -- 5단계
FROM
    order_stat -- 1단계
WHERE
    order_date < '2025-05-14' -- 2단계
GROUP BY
    customer_name -- 3단계
HAVING
    COUNT(*) >= 2 -- 4단계
ORDER BY
    total_purchase DESC -- 6단계
LIMIT
    1; -- 7단계