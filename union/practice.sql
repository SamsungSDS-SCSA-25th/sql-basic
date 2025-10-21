-- 중복 제거
SELECT name, email
FROM users
UNION
SELECT name, email
FROM retired_users;

-- 중복 허용
SELECT name, email
FROM users
UNION ALL
SELECT name, email
FROM retired_users;

-- 정렬 with alias
SELECT name, email, created_at AS event_date
FROM users
UNION
SELECT name, email, retired_date AS event_date
FROM retired_users
ORDER BY event_date;