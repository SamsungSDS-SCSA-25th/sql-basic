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