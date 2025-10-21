-- 본 실습을 위한 탈퇴 고객 테이블 생성
DROP TABLE IF EXISTS retired_users;
CREATE TABLE retired_users
(
    id           BIGINT PRIMARY KEY,
    name         VARCHAR(255) NOT NULL,
    email        VARCHAR(255) NOT NULL,
    retired_date DATE         NOT NULL
);

-- 탈퇴 고객 데이터 입력
INSERT INTO retired_users (id, name, email, retired_date)
VALUES (1,
        '션'
           , 'sean@example.com', '2024-12-31'),
       (7,
        '아이작 뉴턴'
           , 'newton@example.com', '2025-01-10');