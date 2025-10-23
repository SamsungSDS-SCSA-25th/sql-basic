-- 내부 조인
SELECT *
FROM EMPLOYEES e
         JOIN DEPARTMENTS d
              ON e.DEPARTMENT_ID = d.DEPARTMENT_ID;

-- LEFT 조인
-- 종원원 기준으로 오른쪽에 null 등장
SELECT *
FROM EMPLOYEES e
         LEFT JOIN DEPARTMENTS d
                   ON e.DEPARTMENT_ID = d.DEPARTMENT_ID;

-- RIGHT 조인 (실무에서는 기준을 왼쪽에 보통 잡는다)
-- 부서를 기준으로 오른쪽에 null 등장
SELECT *
FROM EMPLOYEES e
         RIGHT JOIN DEPARTMENTS d
                    ON e.DEPARTMENT_ID = d.DEPARTMENT_ID;

-- SELF 조인
-- 관리자 id 기준으로 조인하여, 오른쪽에 관리자 정보 넣는다
SELECT e1.EMPLOYEE_ID,
       e1.FIRST_NAME,
       e1.LAST_NAME,
       e2.MANAGER_ID,
       e2.FIRST_NAME,
       e2.LAST_NAME
FROM EMPLOYEES e1
         JOIN EMPLOYEES e2
              ON e1.MANAGER_ID = e2.EMPLOYEE_ID; -- SELF 조인의 핵심

-- SELECT 스칼라 쿼리
SELECT EMPLOYEE_ID,
       DEPARTMENT_ID,
       (SELECT DEPARTMENT_NAME
        FROM DEPARTMENTS d
        WHERE e.DEPARTMENT_ID = d.DEPARTMENT_ID) AS "DEPARTMENT_NAME"
FROM EMPLOYEES e;

-- 부서별 부서번호, 최대급여, 최대급여 받는 그 사원의 사번 출력
-- FROM sub-query (인라인 뷰)
-- 1
SELECT e1.DEPARTMENT_ID,
       e1.SALARY,
       e1.EMPLOYEE_ID
FROM EMPLOYEES e1
         JOIN (SELECT DEPARTMENT_ID, MAX(SALARY) AS MAX_SALARY
               FROM EMPLOYEES
               GROUP BY DEPARTMENT_ID) cmp
              ON e1.DEPARTMENT_ID = cmp.DEPARTMENT_ID
                  AND e1.SALARY = cmp.MAX_SALARY;

-- 2
-- ROWNUM은 무조건 1부터 시작한다. (난이도 높고, 크게 의미없는 문제로 보임)
SELECT
    ROWNUM AS REAL_ROW_NUM,
    EMPLOYEE_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY
FROM (SELECT ROWNUM AS REAL_ROW_NUM, tmp.*
      FROM (SELECT ROWNUM AS TARGET_ROW_NUM,
                   EMPLOYEE_ID,
                   FIRST_NAME,
                   LAST_NAME,
                   SALARY
            FROM EMPLOYEES
            ORDER BY SALARY DESC) tmp
      )
WHERE REAL_ROW_NUM BETWEEN 1 AND 111;

-- WHERE sub-query
-- 최대급여
SELECT
    EMPLOYEE_ID,
    SALARY
FROM EMPLOYEES
WHERE SALARY = (SELECT MAX(SALARY)
                 FROM EMPLOYEES);

-- 부서명이 it인 사번, 이름, 부서번호 출력
SELECT EMPLOYEE_ID,
       FIRST_NAME,
       DEPARTMENT_ID
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID
                       FROM DEPARTMENTS
                       WHERE DEPARTMENT_NAME = 'IT');

-- Sales 부서명을 가진 사람 모두 출력 (JOIN 대체 가능)
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID IN (SELECT DEPARTMENT_ID
                        FROM DEPARTMENTS
                        WHERE DEPARTMENT_NAME = 'Sales');

-- 부서별 최대급여 받는 사원의 사번, 부서번호, 급여를 출력
SELECT
    EMPLOYEE_ID,
    DEPARTMENT_ID,
    SALARY
FROM EMPLOYEES
WHERE (DEPARTMENT_ID, SALARY) IN (SELECT DEPARTMENT_ID, MAX(SALARY)
                                  FROM EMPLOYEES
                                   GROUP BY DEPARTMENT_ID); -- 여러개 IN