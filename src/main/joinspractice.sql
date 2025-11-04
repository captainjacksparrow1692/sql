CREATE TABLE departments (
                             id     SERIAL PRIMARY KEY,
                             name   VARCHAR(50) NOT NULL,
                             location VARCHAR(50)
);

CREATE TABLE employees (
                           id           SERIAL PRIMARY KEY,
                           name         VARCHAR(50) NOT NULL,
                           position     VARCHAR(50),
                           salary       NUMERIC(10,2),
                           department_id INTEGER REFERENCES departments(id) ON DELETE SET NULL,
                           manager_id   INTEGER REFERENCES employees(id) ON DELETE SET NULL
);

CREATE TABLE customers (
                           id   SERIAL PRIMARY KEY,
                           name VARCHAR(100) NOT NULL,
                           city VARCHAR(50)
);

CREATE TABLE orders (
                        id          SERIAL PRIMARY KEY,
                        order_date  DATE NOT NULL,
                        amount      NUMERIC(10,2),
                        employee_id INTEGER REFERENCES employees(id) ON DELETE SET NULL,
                        customer_id INTEGER REFERENCES customers(id) ON DELETE SET NULL
);

CREATE TABLE products (
                          id    SERIAL PRIMARY KEY,
                          name  VARCHAR(100) NOT NULL,
                          price NUMERIC(10,2)
);

CREATE TABLE order_items (
                             id         SERIAL PRIMARY KEY,
                             order_id   INTEGER REFERENCES orders(id) ON DELETE CASCADE,
                             product_id INTEGER REFERENCES products(id) ON DELETE SET NULL,
                             quantity   INTEGER NOT NULL,
                             product_count int not null
);

-- Вывести сотрудников с зарплатой выше средней по компании
SELECT
    employees.id,
    employees.name,
    employees.salary
FROM employees
WHERE employees.salary > (
    SELECT AVG(employees.salary)
    FROM employees
);

-- Вывести продукты дороже среднего
SELECT
    products.id,
    products.name,
    products.price
FROM products
WHERE products.price > (
    SELECT AVG(products.price)
    FROM products
);

-- Вывести отделы, где есть хотя бы один сотрудник с зарплатой > 10 000
SELECT
    departments.id,
    departments.name
FROM departments
WHERE departments.id IN (
    SELECT DISTINCT employees.department_id
    FROM employees
    WHERE employees.salary > 10000
);

-- Вывести продукты, которые чаще всего встречаются в заказах
SELECT
    products.id,
    products.name,
    COUNT(order_items.id) AS total_sales
FROM products
         JOIN order_items ON order_items.product_id = products.id
GROUP BY products.id, products.name
HAVING COUNT(order_items.id) = (
    SELECT MAX (product_count)
    FROM (
             SELECT COUNT(order_items.id) AS product_count
             FROM order_items
             GROUP BY order_items.product_id
         ) AS subquery
);

-- Вывести для каждого клиента количество его заказов
SELECT
    customers.id,
    customers.name,
    (
        SELECT COUNT(*)
        FROM orders
        WHERE orders.customer_id = customers.id
    ) AS order_count
FROM customers;

-- Вывести топ 3 отдела по средней зарплате
SELECT
    departments.id,
    departments.name,
    (
        SELECT AVG(employees.salary)
        FROM employees
        WHERE employees.department_id = departments.id
    ) AS average_salary
FROM departments
ORDER BY average_salary DESC
LIMIT 3;

-- Вывести клиентов без заказов
SELECT
    customers.id,
    customers.name
FROM customers
WHERE customers.id NOT IN (
    SELECT DISTINCT orders.customer_id
    FROM orders
    WHERE orders.customer_id IS NOT NULL
);

-- Вывести сотрудников, зарабатывающих больше, чем любой из менеджеров.
SELECT
    employees.id,
    employees.name,
    employees.salary
FROM employees
WHERE employees.salary > ALL (
    SELECT COALESCE(employees.salary, 0)
    FROM employees
    WHERE employees.position ILIKE '%manager%'
);

-- Вывести отделы, где все сотрудники зарабатывают выше 5000.
SELECT
    departments.id,
    departments.name
FROM departments
WHERE departments.id IN (
    SELECT employees.department_id
    FROM employees
    GROUP BY employees.department_id
    HAVING MIN(COALESCE(employees.salary, 0)) > 5000
);