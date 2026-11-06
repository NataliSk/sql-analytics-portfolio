-- БАЗОВАЯ АНАЛИТИКА БАНКОВСКИХ ДАННЫХ (СУБД: MySQL)
-- Таблицы:
-- clients (client_id, full_name, city, registered_at)
-- accounts (account_id, client_id, currency, opened_at, closed_at)
-- transactions (tx_id, account_id, tx_date, amount, tx_type)

-- Задача 1. Простая выборка и фильтрация (SELECT, WHERE, ORDER BY, LIKE)
-- Найти клиентов из Новосибирска, зарегистрированных в 2025 году, отсортировать по дате.
SELECT client_id, full_name, city, registered_at
FROM clients 
WHERE city = 'Новосибирск' 
  AND YEAR(registered_at) = 2025
ORDER BY registered_at ASC;

-- Задача 2. Агрегация и работа с пустыми значениями (COUNT, IS NULL, GROUP BY)
-- Посчитать количество действующих (не закрытых) счетов в каждой валюте.
SELECT currency, COUNT(account_id) AS open_accounts_count
FROM accounts 
WHERE closed_at IS NULL 
GROUP BY currency
ORDER BY open_accounts_count DESC;

-- Задача 3. Фильтрация сгруппированных данных (GROUP BY, HAVING)
-- Найти ID клиентов, у которых открыто больше двух счетов.
SELECT client_id, COUNT(account_id) AS accounts_count
FROM accounts
GROUP BY client_id
HAVING COUNT(account_id) > 2;

-- Задача 4. Поиск дублей в данных (GROUP BY по нескольким полям + HAVING)
-- Найти задвоенные транзакции (где совпадают и номер счета, и дата, и сумма).
SELECT account_id, tx_date, amount, COUNT(*) AS duplicates_count
FROM transactions
GROUP BY account_id, tx_date, amount
HAVING COUNT(*) > 1;

-- Задача 5. Объединение таблиц (INNER JOIN) и сумма (SUM)
-- Вывести имя клиента и общую сумму его входящих пополнений (tx_type = 'in').
SELECT c.full_name, SUM(t.amount) AS total_incoming
FROM clients c
INNER JOIN accounts a ON c.client_id = a.client_id
INNER JOIN transactions t ON a.account_id = t.account_id
WHERE t.tx_type = 'in'
GROUP BY c.client_id, c.full_name;

-- Задача 6. Поиск клиентов без счетов (LEFT JOIN)
-- Найти клиентов, которые зарегистрировались, но еще не открыли ни одного счета.
SELECT c.client_id, c.full_name, c.registered_at
FROM clients c
LEFT JOIN accounts a ON c.client_id = a.client_id
WHERE a.account_id IS NULL;
