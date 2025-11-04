CREATE TABLE sales (
                       id SERIAL PRIMARY KEY,
                       region VARCHAR(20),
                       amount BIGINT,
                       sale_date timestamp
);

INSERT INTO sales (region, amount, sale_date) VALUES
                                                  ('North', 1000, '2024-01-01'),
                                                  ('South', 700, '2024-01-02'),
                                                  ('North', 500, '2024-01-03'),
                                                  ('West', NULL, '2024-01-04'),
                                                  ('South', 900, '2024-01-05'),
                                                  ('North', 1500, '2024-01-06');

---1. Найди сумму продаж по каждому региону
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region;

---2. Покажи среднюю сумму продаж по регионам, где больше одной продажи
SELECT region, AVG(amount) AS avr_sales
FROM sales
GROUP BY region
HAVING COUNT(*) > 1;

---3. Найди регион с максимальной суммой продаж
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region
ORDER BY total_sales DESC
LIMIT 1;

---4.Выведи общее количество продаж и сколько из них имеют ненулевую сумму
SELECT
    COUNT(*) AS total_sales,
    COUNT(AMOUNT) AS non_null_sales
FROM sales;

---5. Покажи регионы, где продажи превышают среднюю по всем регионам
SELECT region, SUM(amount) AS total_sales
FROM sales
GROUP BY region
HAVING SUM(amount) > (
    SELECT AVG(amount) FROM sales
);