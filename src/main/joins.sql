DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS departments CASCADE;

-- CREATE TABLES
CREATE TABLE departments (
                             id SERIAL PRIMARY KEY,
                             name VARCHAR(50) NOT NULL,
                             location VARCHAR(50)
);

CREATE TABLE employees (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(50) NOT NULL,
                           position VARCHAR(50),
                           salary NUMERIC(10,2),
                           department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
                           manager_id INTEGER REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE customers (
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(100) NOT NULL,
                           city VARCHAR(50)
);

CREATE TABLE orders (
                        id SERIAL PRIMARY KEY,
                        order_date DATE NOT NULL,
                        amount NUMERIC(10,2),
                        employee_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
                        customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL
);

CREATE TABLE products (
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100) NOT NULL,
                          price NUMERIC(10,2)
);

CREATE TABLE order_items (
                             id SERIAL PRIMARY KEY,
                             order_id INTEGER REFERENCES orders(id) ON DELETE CASCADE,
                             product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
                             quantity INTEGER NOT NULL
);

-- INSERTS (тестовые данные)
INSERT INTO departments (id, name, location) VALUES
                                                 (1, 'Sales', 'New York'),
                                                 (2, 'IT', 'San Francisco'),
                                                 (3, 'HR', 'Chicago'),
                                                 (4, 'Finance', 'Boston'),
                                                 (5, 'Logistics', 'Seattle');

INSERT INTO employees (id, name, position, salary, department_id, manager_id) VALUES
                                                                                  (1, 'Alice Johnson', 'Sales Manager', 75000.00, 1, NULL),
                                                                                  (2, 'Bob Smith', 'Sales Representative', 55000.00, 1, 1),
                                                                                  (3, 'Charlie Brown', 'Software Engineer', 80000.00, 2, NULL),
                                                                                  (4, 'Diana Adams', 'System Administrator', 65000.00, 2, 3),
                                                                                  (5, 'Evelyn White', 'HR Specialist', 60000.00, 3, NULL),
                                                                                  (6, 'Frank Miller', 'Accountant', 70000.00, 4, NULL),
                                                                                  (7, 'Gina Lopez', 'Sales Representative', 52000.00, 1, 1),
                                                                                  (8, 'Henry Cooper', 'Intern', NULL, NULL, 1);

INSERT INTO customers (id, name, city) VALUES
                                           (1, 'John Doe', 'New York'),
                                           (2, 'Mary Johnson', 'Los Angeles'),
                                           (3, 'Michael Davis', 'Chicago'),
                                           (4, 'Sarah Wilson', 'Houston'),
                                           (5, 'James Taylor', 'Boston'),
                                           (6, 'NoOrders Customer', 'Miami');

INSERT INTO products (id, name, price) VALUES
                                           (1, 'Laptop', 1200.00),
                                           (2, 'Smartphone', 800.00),
                                           (3, 'Monitor', 300.00),
                                           (4, 'Keyboard', 50.00),
                                           (5, 'Mouse', 25.00),
                                           (6, 'Tablet', 400.00);

INSERT INTO orders (id, order_date, amount, employee_id, customer_id) VALUES
                                                                          (1, '2025-01-15', 2450.00, 2, 1),
                                                                          (2, '2025-02-10', 800.00, 2, 2),
                                                                          (3, '2025-03-05', 350.00, 4, 3),
                                                                          (4, '2025-04-22', 75.00, 1, 4),
                                                                          (5, '2025-05-30', 1250.00, 3, 5),
                                                                          (6, '2025-06-10', 0.00, NULL, 1),
                                                                          (7, '2025-07-01', 600.00, 2, NULL),
                                                                          (8, '2025-08-15', 0.00, 2, 2);

INSERT INTO order_items (id, order_id, product_id, quantity) VALUES
                                                                 (1, 1, 1, 1),
                                                                 (2, 1, 3, 2),
                                                                 (3, 2, 2, 1),
                                                                 (4, 3, 3, 1),
                                                                 (5, 3, 4, 1),
                                                                 (6, 4, 5, 3),
                                                                 (7, 5, 1, 1),
                                                                 (8, 5, 4, 1),
                                                                 (9, 6, 5, 2),
                                                                 (10, 7, 2, 1);

-- 1. Сотрудники с отделами (No Department для NULL)
SELECT
    employees.id,
    employees.name,
    COALESCE(departments.name, 'No Department') AS department_name
FROM employees
         LEFT JOIN departments ON employees.department_id = departments.id;

-- 2. Сотрудники, у которых есть менеджер (имя сотрудника и имя менеджера)
SELECT
    employees.name AS employee_name,
    manager.name AS manager_name
FROM employees
         JOIN employees AS manager ON employees.manager_id = manager.id;

-- 3. Отделы без сотрудников
SELECT
    departments.id,
    departments.name
FROM departments
         LEFT JOIN employees ON employees.department_id = departments.id
WHERE employees.id IS NULL;

-- 4. Все заказы с именем сотрудника и именем клиента (No Employee / No Customer)
SELECT
    orders.id AS order_id,
    COALESCE(employees.name, 'No Employee') AS employee_name,
    COALESCE(customers.name, 'No Customer') AS customer_name,
    orders.amount,
    orders.order_date
FROM orders
         LEFT JOIN employees ON orders.employee_id = employees.id
         LEFT JOIN customers ON orders.customer_id = customers.id;

-- 5. Список заказов с товарами (включая заказы без позиций)
SELECT
    orders.id AS order_id,
    products.name AS product_name,
    order_items.quantity
FROM orders
         LEFT JOIN order_items ON orders.id = order_items.order_id
         LEFT JOIN products ON order_items.product_id = products.id;

-- 6. Для каждого отдела — все заказы (через сотрудников этого отдела); включать отделы с нулём заказов
SELECT
    departments.name AS department_name,
    orders.id AS order_id,
    orders.amount
FROM departments
         LEFT JOIN employees ON employees.department_id = departments.id
         LEFT JOIN orders ON orders.employee_id = employees.id
ORDER BY departments.name, orders.id;

-- 7. Пары клиент × продукт, которые клиент никогда не покупал
SELECT
    customers.id AS customer_id,
    customers.name AS customer_name,
    products.id AS product_id,
    products.name AS product_name
FROM customers
         CROSS JOIN products
WHERE NOT EXISTS (
    SELECT 1
    FROM orders
             JOIN order_items ON order_items.order_id = orders.id
    WHERE orders.customer_id = customers.id
      AND order_items.product_id = products.id
);

-- 8. Продукты, которые никогда не продавались
SELECT
    products.id,
    products.name
FROM products
         LEFT JOIN order_items ON order_items.product_id = products.id
WHERE order_items.id IS NULL;

-- 9. Для каждого менеджера — суммарная сумма заказов его подчинённых
SELECT
    manager.id AS manager_id,
    manager.name AS manager_name,
    SUM(orders.amount) AS total_subordinates_sales
FROM employees AS manager
         JOIN employees ON employees.manager_id = manager.id
         JOIN orders ON orders.employee_id = employees.id
GROUP BY manager.id, manager.name;

-- 10. Общее количество заказов и суммарная выручка
SELECT
    COUNT(*) AS total_orders,
    SUM(orders.amount) AS total_revenue
FROM orders;

-- 11. Средняя и максимальная зарплата по отделам
SELECT
    departments.name AS department_name,
    AVG(employees.salary) AS average_salary,
    MAX(employees.salary) AS maximum_salary
FROM departments
         LEFT JOIN employees ON employees.department_id = departments.id
GROUP BY departments.name;

-- 12. Для каждого заказа — общее количество товаров и уникальных позиций
SELECT
    orders.id AS order_id,
    SUM(order_items.quantity) AS total_quantity,
    COUNT(DISTINCT order_items.product_id) AS unique_products
FROM orders
         LEFT JOIN order_items ON order_items.order_id = orders.id
GROUP BY orders.id;

-- 13. Топ-3 продукта по суммарной выручке (price * quantity)
SELECT
    products.id,
    products.name,
    SUM(products.price * order_items.quantity) AS total_revenue
FROM products
         JOIN order_items ON order_items.product_id = products.id
GROUP BY products.id, products.name
ORDER BY total_revenue DESC
LIMIT 3;

-- 14. Количество клиентов, у которых есть хотя бы один заказ
SELECT
    COUNT(DISTINCT orders.customer_id) AS active_customers
FROM orders
WHERE orders.customer_id IS NOT NULL;

-- 15. Для каждого отдела — количество сотрудников, средняя зарплата, суммарная сумма заказов
SELECT
    departments.name AS department_name,
    COUNT(DISTINCT employees.id) AS employee_count,
    AVG(employees.salary) AS average_salary,
    SUM(orders.amount) AS total_sales
FROM departments
         LEFT JOIN employees ON employees.department_id = departments.id
         LEFT JOIN orders ON orders.employee_id = employees.id
GROUP BY departments.name;

-- 16. Клиенты, чья средняя сумма заказа выше средней по всем заказам
SELECT
    customers.id,
    customers.name,
    AVG(orders.amount) AS average_customer_order
FROM customers
         JOIN orders ON orders.customer_id = customers.id
GROUP BY customers.id, customers.name
HAVING AVG(orders.amount) > (SELECT AVG(amount) FROM orders);

-- 17. Сформировать полное имя сотрудника (имя + должность)
SELECT
    employees.name || ' (' || employees.position || ')' AS full_name
FROM employees;

-- 18. Дата заказа в формате DD.MM.YYYY HH24:MI
SELECT
    orders.id,
    TO_CHAR(orders.order_date, 'DD.MM.YYYY HH24:MI') AS formatted_date
FROM orders;

-- 19. Найти заказы старше N дней (пример: 30 дней)
SELECT
    *
FROM orders
WHERE orders.order_date < CURRENT_DATE - INTERVAL '30 days';

-- 20. Для employees: заменить NULL в salary на 0 и показать salary + бонус (10% для позиций с 'manager')
SELECT
    employees.id,
    employees.name,
    employees.position,
    COALESCE(employees.salary, 0) AS base_salary,
    COALESCE(employees.salary, 0) +
    CASE
        WHEN employees.position ILIKE '%manager%' THEN COALESCE(employees.salary, 0) * 0.10
        ELSE 0
        END AS salary_with_bonus
FROM employees;