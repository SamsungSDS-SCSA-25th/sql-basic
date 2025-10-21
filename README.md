# SQL 기본 정리

## 💾 데이터베이스 기초 문법

### 데이터베이스 생성 및 선택

```sql
CREATE DATABASE shop_db;
USE shop_db;
```

* `CREATE DATABASE` : 새로운 데이터베이스 생성
* `USE` : 사용할 데이터베이스 선택

### 테이블 목록 및 구조 확인

```sql
SHOW TABLES;           -- 현재 DB의 테이블 목록 보기
DESC 테이블명;          -- 테이블 구조(컬럼, 타입, 키 등) 보기
```

### 데이터베이스 삭제

```sql
DROP DATABASE shop_db;
```

* **주의:** 데이터베이스 전체가 삭제되므로 백업 필수!

---

## 🧱 DDL (Data Definition Language) - 테이블 생성

### 테이블 설계

* 쇼핑몰 핵심 데이터 테이블: `customers`, `products`, `orders`
* 기본 키: `AUTO_INCREMENT`로 자동 번호 부여
* 날짜·시간 컬럼: `DEFAULT CURRENT_TIMESTAMP` (+ `ON UPDATE`)로 자동 관리
* 외래 키(FK) 관계 설정:

    * `orders.customer_id → customers.customer_id`
    * `orders.product_id → products.product_id`

### ERD 구조 (1:N 관계)

```
customers (1) ───< orders >───(N) products
```

### 테이블 변경 및 제거

* `ALTER TABLE` : `ADD / MODIFY / DROP COLUMN`으로 구조 변경
* 대용량 테이블 변경 시 잠금·속도 고려 → **새벽 시간 작업 권장**
* `DROP TABLE` : 테이블 자체 삭제
* `TRUNCATE TABLE` : 데이터만 삭제 (DDL)
* FK 무시 작업 시:

  ```sql
  SET FOREIGN_KEY_CHECKS=0;
  -- 작업 수행
  SET FOREIGN_KEY_CHECKS=1;
  ```

---

## ✏️ DML (Data Manipulation Language)

### 데이터 등록 (`INSERT`)

* 3가지 패턴:

    1. 모든 컬럼 입력
    2. 필요한 컬럼만 입력
    3. 다중 VALUES 입력
* 열 목록 명시로 스키마 변경 시 오류 방지
* `AUTO_INCREMENT`, `DEFAULT`, `NULL` 허용 컬럼은 생략 가능

### 데이터 수정 (`UPDATE`)

* 기본 문법:

  ```sql
  UPDATE 테이블명
  SET 컬럼 = 값
  WHERE 조건;
  ```
* **`WHERE` 절 필수!** (없으면 전체 수정)
* MySQL Workbench는 `SQL_SAFE_UPDATES=1` 기본 설정
* 수정 전 `SELECT`로 동일 WHERE 확인 후 실행
* 대량 수정 시:

  ```sql
  SET SQL_SAFE_UPDATES=0;
  -- UPDATE 실행
  SET SQL_SAFE_UPDATES=1;
  ```

### 데이터 삭제 (`DELETE`)

* 기본 문법:

  ```sql
  DELETE FROM 테이블명 WHERE 조건;
  ```
* **`WHERE` 절 필수!** (없으면 전부 삭제)
* `DELETE` vs `TRUNCATE` 비교:

  | 구분             | DELETE (DML) | TRUNCATE (DDL) |
    | -------------- | ------------ | -------------- |
  | 속도             | 느림           | 빠름             |
  | 조건 삭제          | 가능           | 불가능            |
  | 롤백             | 가능           | 불가능            |
  | AUTO_INCREMENT | 유지           | 초기화            |

---

## 🔒 제약 조건 (Constraints)

| 제약 조건         | 설명                      |
| ------------- | ----------------------- |
| `NOT NULL`    | 필수값 누락 시 오류 발생          |
| `UNIQUE`      | 중복 데이터 입력 시 오류 발생       |
| `FOREIGN KEY` | 부모 테이블에 없는 값 입력 시 오류 발생 |

* 제약조건은 `INSERT`, `UPDATE`, `DELETE` 실행 전 검증되어 **데이터 무결성 보장**

---

## 🔍 SELECT - 조회

### 기본 조회

* `SELECT * FROM 테이블명` : 모든 열 조회
* `SELECT 열1, 열2 FROM 테이블명` : 지정 열만 조회 → 성능 향상
* `AS`로 별칭 지정 가능:

  ```sql
  SELECT name AS 고객명 FROM customers;
  ```

### WHERE - 조건 검색

* 비교 연산자: `=`, `!=`, `>`, `<`, `>=`, `<=`
* 논리 연산자: `AND`, `OR`, `NOT`
* `AND`: 모든 조건 참일 때, `OR`: 하나라도 참일 때

### WHERE - 편리한 검색

| 기능      | 예시                       | 설명                     |
| ------- | ------------------------ | ---------------------- |
| 범위      | `BETWEEN 10 AND 20`      | 10~20 포함               |
| 목록      | `IN ('A', 'B', 'C')`     | 지정된 목록 중 일치            |
| 문자열 검색  | `LIKE 'A%'`, `LIKE '_B'` | `%`: 0개 이상, `_`: 1개 문자 |
| NULL 검사 | `IS NULL`, `IS NOT NULL` | `=` 연산자 불가             |

---

## 📊 ORDER BY / LIMIT / DISTINCT

### 정렬 (`ORDER BY`)

* `ASC`: 오름차순 (기본값)
* `DESC`: 내림차순
* 다중 정렬 예시:

  ```sql
  ORDER BY 재고 DESC, 가격 ASC;
  ```

### 개수 제한 (`LIMIT`)

* `LIMIT 2` → 상위 2개 데이터 조회
* `LIMIT 시작, 개수` → 페이징 처리용

    * 공식: `시작점 = (페이지번호 - 1) * 페이지당_개수`

### 중복 제거 (`DISTINCT`)

* `SELECT DISTINCT customer_id FROM orders;`
* 여러 컬럼 동시 적용 가능

---

## 🧮 NULL 처리

* `NULL` = 알 수 없음 / 값 없음 (`0`이나 공백과 다름)
* 비교 시 `IS NULL` / `IS NOT NULL` 사용
* 정렬 시:

    * `ASC`: NULL이 맨 앞
    * `DESC`: NULL이 맨 뒤
* 제어 예시:

  ```sql
  ORDER BY (컬럼 IS NULL) DESC, 컬럼 DESC;
  ```

---

## 📈 집계 함수

| 함수                   | 설명                |
| -------------------- | ----------------- |
| `COUNT(*)`           | NULL 포함 전체 행 개수   |
| `COUNT(컬럼)`          | NULL 제외한 개수       |
| `SUM()` / `AVG()`    | 합계 / 평균 (NULL 제외) |
| `MAX()` / `MIN()`    | 최댓값 / 최솟값         |
| `COUNT(DISTINCT 컬럼)` | 중복 제외 고유 개수       |

---

## 🧩 GROUP BY / HAVING

### GROUP BY - 그룹화

* 동일 컬럼 값끼리 그룹화
* 그룹별 통계 계산 가능 (예: 고객별 주문 수)
* `NULL` 도 하나의 그룹으로 처리

### GROUP BY 주의사항

* `SELECT` 절에는 **그룹화 컬럼** 또는 **집계 함수**만 사용 가능

### HAVING - 그룹 조건 필터링

| 구분      | WHERE | HAVING |
| ------- | ----- | ------ |
| 시점      | 그룹화 전 | 그룹화 후  |
| 대상      | 개별 행  | 그룹     |
| 집계함수 사용 | 불가    | 가능     |

* `WHERE` + `HAVING` 함께 사용 가능 (행 → 그룹 순서)

### WHERE, HAVING 개념 비유


1. 전체 학생(테이블 데이터)들이 운동장에 모여있다.
2. 선생님이 "안경 쓴 학생들만 앞으로 나와!"라고 외친다. (`WHERE`: 개별 행 필터링)
3. 앞으로 나온 학생들을 대상으로 "같은 반 학생들끼리 모여!"라고 한다. (`GROUP BY`: 그룹화)
4. 반별로 모인 그룹들을 보며 선생님이 마지막으로 "이 중에서, 반 평균 점수가 80점 이상인 그룹만 남아!"라고 외친다. (`HAVING`: 그룹 필터링)

> `WHERE` 는 그룹화 이전에 개개인을 걸러내는 조건이고, `HAVING` 은 그룹화 이후에 그룹 자체를 걸러내는 조건인 것이다.


---

## ⚙️ SQL 실행 순서

1. `FROM`
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. `SELECT`
6. `ORDER BY`
7. `LIMIT`

> ⚠️ `WHERE` 절에서는 `SELECT` 별칭 사용 불가 (아직 실행 전이기 때문)
> `ORDER BY` 절에서는 별칭 사용 가능'

> ⚠️ `HAVING` 절은 `SELECT` 절보다 먼저 실행되기 때문에, 별칭을 사용하면 오류가 발생할 수 있다.
> (MySQL, PostgreSQL은 편의상 허용)

---

## 조인이 필요한 이유

* 데이터는 **정규화** 과정을 거쳐 여러 테이블에 나뉘어 저장된다.
* **데이터 중복 방지**, **이상 현상 방지(갱신, 삽입, 삭제 시)** 를 위해 분리 저장한다.
* 의미 있는 정보를 얻기 위해 **기본 키와 외래 키를 기준으로 데이터를 연결**해야 한다.
* 조인은 여러 테이블의 데이터를 **하나로 합쳐 보여주는 핵심 기술**이다.

---

## 내부 조인 (INNER JOIN)

* 두 테이블에 **공통으로 존재하는 데이터만 결과**로 반환한다.
* `ON` 절 조건이 참인 행만 결과에 포함된다.
* 처리 순서: `FROM / JOIN` → `WHERE` → `SELECT`
* `INNER` 키워드는 생략 가능 (`JOIN` 만 사용해도 동일).

### 교집합 개념

* 내부 조인은 **두 테이블의 교집합**을 구하는 것과 같다.
* 양쪽에 모두 연결된 데이터만 포함되며, 예를 들어 **주문 없는 고객**은 제외된다.
* 테이블 순서를 바꿔도 **결과는 동일**하다.

### 별칭 (Alias)

* **테이블 별칭**을 사용하면 가독성이 높아진다.
* 실무에서는 **테이블의 `AS` 생략**, **컬럼의 `AS`는 명시적 사용**이 일반적이다.
* 내부 조인은 순서가 중요하지 않지만, **외부 조인에서는 순서가 중요**하다.

---

## 외부 조인 (OUTER JOIN)

* `외부 조인(Outer Join)`은 한쪽 테이블에는 데이터가 있지만, 다른 쪽 테이블에는 없는 경우에도 데이터를 포함시킨다.
* 즉, **기준 테이블의 모든 데이터**를 유지하면서 **조인된 테이블의 일치 데이터만 결합**한다.

---

### LEFT JOIN

* 기준 테이블을 **`FROM` 절에 먼저**, 결합할 테이블을 **`JOIN` 절에** 둔다.
* **왼쪽 테이블의 모든 데이터**를 포함하고, 오른쪽 테이블에 일치하는 데이터가 없으면 **NULL**로 표시된다.
* 예: 고객 테이블을 기준으로 주문 테이블을 LEFT JOIN 하면, 주문이 없는 고객도 표시된다.

```sql
SELECT c.name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.id = o.customer_id;
```

---

### RIGHT JOIN

* LEFT JOIN의 반대 개념으로, **오른쪽 테이블의 모든 데이터**를 포함한다.
* 왼쪽 테이블에 일치 데이터가 없으면 **NULL**로 표시된다.
* `FROM`과 `JOIN` 절의 위치를 바꾸면 `LEFT JOIN`과 동일한 결과를 얻을 수 있다.

```sql
SELECT c.name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.id = o.customer_id;
```

---

### 실무 팁

* 대부분의 실무에서는 **가독성**과 **일관성** 때문에 `LEFT JOIN`만 사용한다.
* `RIGHT JOIN`은 동일 결과를 얻을 수 있어도 **가독성이 떨어지므로 잘 사용하지 않는다.**
* `LEFT JOIN` 기준으로 작성하면 쿼리의 흐름(왼쪽 → 오른쪽)이 자연스럽고 유지보수에 유리하다.

---

## 조인 시 행(row) 개수 변화 정리

조인 결과의 행 수는 **두 테이블의 관계(1:N, N:1)** 와 **조인 기준 방향**에 따라 달라진다.

---

### ✅ 행 개수 유지: 자식 → 부모 (`to-One` 관계)

* **조인 방향:** `FROM 자식 JOIN 부모`

    * 예: `FROM orders JOIN users`
* **조인 방식:** `FK → PK`
* **원리:** 자식 테이블의 각 행은 부모 테이블의 **하나의 행과만 매칭**된다. (예: 주문은 반드시 한 명의 고객에게 속함)
* **결과:** 기준 테이블(자식)의 행 개수가 그대로 유지된다.

    * 예: `orders` 테이블이 7행이면 결과도 7행.

---

### ⚠️ 행 개수 증가 가능: 부모 → 자식 (`to-Many` 관계)

* **조인 방향:** `FROM 부모 JOIN 자식`

    * 예: `FROM users JOIN orders`
* **조인 방식:** `PK → FK`
* **원리:** 부모의 한 행이 자식의 여러 행과 매칭될 수 있다. (예: 한 고객이 여러 번 주문 가능)
* **결과:** 부모 행이 자식 행 수만큼 **복제**되어 결과의 전체 행 수가 늘어날 수 있다.

    * 예: 주문을 2번 한 고객은 결과 테이블에서 2개의 행으로 나타남.

---

### ⚡ 실무에서 중요한 이유

* 조인으로 인해 **데이터의 행 수가 변하면 집계 결과가 왜곡**될 수 있다.
* 예를 들어 `FROM users JOIN orders` 후 `COUNT(u.user_id)` 를 실행하면 **고객 수(6)** 가 아니라 **주문 수(7)** 가 나온다.
* 따라서 조인을 하기 전, 반드시 다음을 고려해야 한다:

    1. **기준 테이블이 무엇인지**
    2. **조인 방향이 행 수를 늘리는 방향인지**

---

### 💡 조인의 유연성

* 조인은 **PK-FK 관계**로만 제한되지 않는다.
* 핵심은 “**두 컬럼의 값이 같은가**”이며, **데이터 타입이 동일하다면** 어떤 컬럼이라도 조인할 수 있다.

#### 🔹 예시 1: 동명이인 찾기

```sql
SELECT A.이름, A.연락처, B.부서
FROM 고객 AS A
JOIN 직원 AS B ON A.이름 = B.이름;
```

#### 🔹 예시 2: 특정 날짜의 이벤트 연결

```sql
SELECT A.주문번호, A.주문금액, B.이벤트명
FROM 주문 AS A
JOIN 마케팅_이벤트 AS B ON A.주문일자 = B.이벤트_시작일;
```

#### 🔹 예시 3: 지역별 데이터 분석

```sql
SELECT A.매장명, B.평균소득
FROM 매장 AS A
JOIN 지역별_인구통계 AS B ON SUBSTRING(A.우편번호, 1, 2) = B.지역코드;
```

#### 🔹 예시 4: 로그 데이터 분석

```sql
SELECT A.요청URL, B.에러설명
FROM 웹서버_로그 AS A
JOIN 에러_코드_정의 AS B ON A.상태코드 = B.코드;
```

---

### 🔒 PK-FK 조인이 중요한 이유

* 이름, 날짜, 코드 등은 **중복되거나 변경 가능**하므로 신뢰성이 낮다.
* 반면 **PK-FK 조인**은 데이터의 **정확성과 일관성**을 보장한다.
* 따라서 **안정적인 조인 관계(PK-FK)** 를 이해하는 것이 **SQL 조인의 기본기**이다.

---

## 셀프 조인 (SELF JOIN)

* **한 테이블을 자기 자신과 조인하는 기법**이다.
* `employees`처럼 **자기 참조 관계**(예: 직원과 그 직원의 상사)를 표현할 때 사용한다.
* 핵심은 **별칭(Alias)** 을 두 개 사용해 테이블을 마치 두 개처럼 다루는 것이다.

---

### ✅ 기본 원리

* 한쪽은 **직원(e)**, 다른 한쪽은 **상사(m)** 로 설정.
* `e.manager_id` = `m.employee_id` 조건으로 연결.

---

### 🔹 INNER SELF JOIN (상사가 있는 직원만)

```sql
SELECT e.name AS employee_name, m.name AS manager_name
FROM employees e
JOIN employees m ON e.manager_id = m.employee_id;
```

**결과:** 상사가 있는 직원만 출력됨.

| employee_name | manager_name |
| ------------- | ------------ |
| 박사장           | 김회장          |
| 이부장           | 박사장          |
| 최과장           | 이부장          |
| 정대리           | 최과장          |
| 홍사원           | 최과장          |

---

### 🔹 LEFT SELF JOIN (전체 직원 포함)

```sql
SELECT e.name AS employee_name, m.name AS manager_name
FROM employees e
LEFT JOIN employees m ON e.manager_id = m.employee_id;
```

**결과:** 상사가 없는 직원(`NULL`)도 포함됨.

| employee_name | manager_name |
| ------------- | ------------ |
| 김회장           | NULL         |
| 박사장           | 김회장          |
| 이부장           | 박사장          |
| 최과장           | 이부장          |
| 정대리           | 최과장          |
| 홍사원           | 최과장          |

---

### 💡 활용 예시

* 조직도 (직원–상사 관계)
* 게시판 (원글–댓글)
* 카테고리 (상위–하위 분류)

➡️ **SELF JOIN = 같은 테이블 내 계층 구조를 표현하는 핵심 SQL 기법**

---

# 서브쿼리 (Subquery)

## 1) 서브쿼리란?

* **쿼리 안의 쿼리**. 괄호 `()`의 SELECT가 먼저 실행되어 **결과값**을 바깥 쿼리가 사용.
* JOIN이 “가로 확장(수평 결합)”이라면, 서브쿼리는 **논리 단계를 안쪽으로 구성(수직)**.

---

## 2) 유형 by 반환 형태 & 사용 위치

| 유형                  | 반환             | 주 사용 위치                     | 핵심 연산자/구문                             | 주요 용도              |
| ------------------- | -------------- | --------------------------- | ------------------------------------- | ------------------ |
| **스칼라**             | 1행 1열          | `SELECT`, `WHERE`, `HAVING` | `=`, `>`, `<`, `>=`, `<=`, `<>`       | 단일 값 비교/표시         |
| **다중 행**            | N행 1열          | `WHERE`, `HAVING`           | `IN`, `NOT IN`, `ANY`, `ALL`          | 목록과 비교             |
| **다중 컬럼(행 서브쿼리)**   | 1행 N열 또는 N행 N열 | `WHERE`, `HAVING`           | `(c1,c2) = (...)`, `(c1,c2) IN (...)` | 복수 컬럼 **쌍(튜플)** 비교 |
| **테이블 서브쿼리(인라인 뷰)** | 테이블 형태         | `FROM (...) AS alias`       | `JOIN` 대상                             | 집계·가공 결과를 다시 활용    |

> `FROM` 서브쿼리는 **반드시 별칭** 필요.

---

## 3) 대표 패턴 (필수 예시)

### 3-1) 스칼라 (단일 값)

```sql
-- 평균보다 비싼 상품
SELECT name, price
FROM products
WHERE price > (SELECT AVG(price) FROM products);
```

### 3-2) 다중 행 + IN

```sql
-- 전자기기 상품들만 주문 내역 조회
SELECT *
FROM orders
WHERE product_id IN (
  SELECT product_id FROM products WHERE category = '전자기기'
);
```

### 3-3) ANY / ALL (필요 시 MIN/MAX로 대체)

```sql
-- 전자기기 중 '어느 하나'보다라도 비쌈 = MIN 가격보다 큼
SELECT name, price
FROM products
WHERE price > ANY (SELECT price FROM products WHERE category='전자기기');
-- 동일 의미(가독성↑)
WHERE price > (SELECT MIN(price) FROM products WHERE category='전자기기');

-- 전자기기 '모두'보다 비쌈 = MAX 가격보다 큼
WHERE price > ALL (SELECT price FROM products WHERE category='전자기기');
-- 동일 의미
WHERE price > (SELECT MAX(price) FROM products WHERE category='전자기기');
```

### 3-4) 다중 컬럼(튜플) 비교

```sql
-- (user_id, status)가 동일한 주문 찾기
SELECT order_id, user_id, status
FROM orders
WHERE (user_id, status) = (
  SELECT user_id, status FROM orders WHERE order_id = 3
);

-- 여러 쌍과 비교(다중 행)
WHERE (user_id, order_date) IN (
  SELECT user_id, MIN(order_date) FROM orders GROUP BY user_id
);
```

### 3-5) EXISTS / NOT EXISTS (상관 서브쿼리)

```sql
-- 한 번이라도 주문된 상품
SELECT p.product_id, p.name, p.price
FROM products p
WHERE EXISTS (
  SELECT 1 FROM orders o WHERE o.product_id = p.product_id
);

-- 한 번도 주문되지 않은 상품
WHERE NOT EXISTS (
  SELECT 1 FROM orders o WHERE o.product_id = p.product_id
);
```

### 3-6) SELECT 절 스칼라 서브쿼리

```sql
-- 각 상품 + 전체 평균가 컬럼 추가(비상관)
SELECT name, price,
       (SELECT AVG(price) FROM products) AS avg_price
FROM products;

-- 각 상품별 주문 횟수(상관)
SELECT p.product_id, p.name, p.price,
       (SELECT COUNT(*) FROM orders o WHERE o.product_id = p.product_id) AS order_count
FROM products p;
```

### 3-7) FROM 절 인라인 뷰

```sql
-- 카테고리별 최고가 상품 찾기
SELECT p.product_id, p.name, p.price
FROM products p
JOIN (
  SELECT category, MAX(price) AS max_price
  FROM products
  GROUP BY category
) AS cmp
ON p.category = cmp.category AND p.price = cmp.max_price;
```

---

## 4) 상관 vs 비상관 요약

* **비상관**: 서브쿼리 **한 번** 실행 → 결과를 모든 행에 재사용.
* **상관**: 바깥 행 **마다** 서브쿼리 실행(반복). 가독성↑ 가능하지만 **성능 주의**.

---

## 5) IN vs EXISTS (실무 감각)

| 비교     | IN                | EXISTS                          |
| ------ | ----------------- | ------------------------------- |
| 방식     | 결과 **목록**을 만들어 비교 | 행 **존재 여부**만 확인(찾자마자 멈춤)        |
| 유리한 경우 | 서브쿼리 결과가 **작을 때** | 서브쿼리 테이블이 **클 때**, 인덱스 적중 시 효율적 |

> 대안: 경우에 따라 JOIN, `LEFT JOIN + GROUP BY`가 더 빠름.

---

## 6) 흔한 오류 & 팁

* 스칼라 서브쿼리에 **여러 행**이 나오면 에러(`Subquery returns more than 1 row`).
* 다중 컬럼 `=` 비교는 **서브쿼리가 반드시 1행**이어야 함. 여러 행이면 `IN`(튜플) 사용.
* `FROM (...)`엔 **별칭 필수**.
* 복잡/고비용 상관 서브쿼리는 **JOIN 재작성** 고려.
* 성능은 **추측 금지 → `EXPLAIN`/실측**.

---

## 7) JOIN vs 서브쿼리 선택 가이드

1. **JOIN 우선** 검토(일반적으로 성능·최적화 유리).
2. 가독성이 훨씬 좋아지거나 단계적 사고 표현이 명확하면 **서브쿼리**.
3. 대용량 존재 여부 확인은 **EXISTS/NOT EXISTS**.
4. 항상 **실행 계획**과 **시간**으로 검증.

---
