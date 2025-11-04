CREATE TABLE students (
                          student_id SERIAL PRIMARY KEY,
                          first_name VARCHAR(50) NOT NULL,
                          last_name VARCHAR(50) NOT NULL,
                          birth_date DATE NOT NULL,
                          email VARCHAR(100) UNIQUE,
                          group_id INT NOT NULL
);

---1. INSERT для заполнения таблицы
INSERT INTO students (first_name, last_name, birth_date, email, group_id)
VALUES
    ('Ivan',    'Petrov',   '2002-03-15', 'ivan.petrov1@example.com', 101),
    ('Ivan',    'Petrov',   '2002-03-15', 'ivan.petrov2@example.com', 101),
    ('Anna',    'Sidorova', '2001-07-22', 'anna.sidorova@example.com', 101),
    ('Sergey',  'Kuznetsov','2003-01-10', 'sergey.kuz@example.com',    102),
    ('Maria',   'Ivanova',  '2002-11-05', 'maria.ivanova@example.com', 102),
    ('Maria',   'Ivanova',  '2002-11-05', 'maria.ivanova2@example.com',102),
    ('Dmitry',  'Smirnov',  '2001-09-30', 'dmitry.smirnov@example.com',103),
    ('Olga',    'Popova',   '2003-02-14', 'olga.popova@example.com',   103),
    ('Olga',    'Popova',   '2003-02-14', 'olga.popova2@example.com',  103),
    ('Nikita',  'Fedorov',  '2002-05-09', 'nikita.fedorov@example.com',104);

---2. Найти дубликаты по имени и фамилии студента
SELECT first_name, last_name, COUNT(*) AS duplicate_count
FROM students
GROUP BY first_name, last_name
HAVING COUNT(*) > 1;

---3. Удалить дубликаты, оставить только первую запись
DELETE FROM students
WHERE student_id NOT IN (
    SELECT MIN(student_id)
    FROM students
    GROUP BY first_name, last_name
);