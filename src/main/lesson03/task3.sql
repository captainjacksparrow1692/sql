DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS subjects;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS groups;

CREATE TABLE groups (
                        group_id INT PRIMARY KEY,
                        group_name VARCHAR(50)
);

CREATE TABLE students (
                          student_id INT PRIMARY KEY,
                          full_name VARCHAR(100),
                          age INT,
                          group_id INT REFERENCES groups(group_id)
);

CREATE TABLE subjects (
                          subject_id INT PRIMARY KEY,
                          subject_name VARCHAR(50)
);

CREATE TABLE grades (
                        grade_id INT PRIMARY KEY,
                        student_id INT REFERENCES students(student_id),
                        subject_id INT REFERENCES subjects(subject_id),
                        grade INT
);

-- 1. Напишите INSERT для заполнения таблиц
-- Таблица groups
INSERT INTO groups (group_id, group_name)
VALUES
    (1, 'Group A'),
    (2, 'Group B'),
    (3, 'Group C');

-- Таблица students
INSERT INTO students (student_id, full_name, age, group_id)
VALUES
    (1, 'Ivan Petrov', 20, 1),
    (2, 'Anna Sidorova', 22, 1),
    (3, 'Sergey Kuznetsov', 21, 2),
    (4, 'Maria Ivanova', 23, 2),
    (5, 'Dmitry Smirnov', 20, 3),
    (6, 'Olga Popova', 21, 3),
    (7, 'Nikita Fedorov', 22, 3);

-- Таблица subjects
INSERT INTO subjects (subject_id, subject_name)
VALUES
    (1, 'Mathematics'),
    (2, 'Physics'),
    (3, 'Programming');

-- Таблица grades
INSERT INTO grades (grade_id, student_id, subject_id, grade)
VALUES
    (1, 1, 1, 9),
    (2, 1, 2, 8),
    (3, 1, 3, 10),
    (4, 2, 1, 7),
    (5, 2, 2, 8),
    (6, 3, 1, 6),
    (7, 3, 2, 9),
    (8, 3, 3, 7),
    (9, 4, 1, 10),
    (10, 4, 2, 9),
    (11, 5, 1, 8),
    (12, 5, 2, 9),
    (13, 6, 3, 7),
    (14, 7, 3, 10);


-- 2. Подсчитайте количество студентов в университете
SELECT COUNT(*) AS total_students
FROM students;

-- 3. Найдите средний возраст студентов
SELECT AVG(age) AS avg_age
FROM students;

-- 4. Определите минимальный и максимальный возраст студентов
SELECT MIN(age) AS min_age, MAX(age) AS max_age
FROM students;

-- 5. Подсчитайте, сколько всего оценок выставлено
SELECT COUNT(*) AS total_grades
FROM grades;

-- 6. Подсчитайте, сколько студентов учится в каждой группе
SELECT g.group_name, COUNT(s.student_id) AS student_count
FROM groups g
         JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_name;

-- 7. Найдите средний возраст студентов по каждой группе
SELECT g.group_name, AVG(s.age) AS avg_age
FROM groups g
         JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_name;

-- 8. Определите средний балл по каждому предмету
SELECT sub.subject_name, ROUND(AVG(gr.grade), 2) AS avg_grade
FROM grades gr
         JOIN subjects sub ON gr.subject_id = sub.subject_id
GROUP BY sub.subject_name;

-- 9. Найдите количество студентов, у которых есть оценки по каждому предмету
SELECT COUNT(*) AS students_with_all_grades
FROM (
         SELECT student_id
         FROM grades
         GROUP BY student_id
         HAVING COUNT(DISTINCT subject_id) = (SELECT COUNT(*) FROM subjects)
     ) AS t;

-- 10. Выведите только те группы, где учится больше 1 студента
SELECT g.group_name, COUNT(s.student_id) AS student_count
FROM groups g
         JOIN students s ON g.group_id = s.group_id
GROUP BY g.group_name
HAVING COUNT(s.student_id) > 1;

-- 11. Покажите предметы, где средний балл выше 8
SELECT sub.subject_name, ROUND(AVG(gr.grade), 2) AS avg_grade
FROM grades gr
         JOIN subjects sub ON gr.subject_id = sub.subject_id
GROUP BY sub.subject_name
HAVING AVG(gr.grade) > 8;

-- 12. Найдите студентов, у которых средний балл по всем предметам выше 8.5
SELECT s.full_name, ROUND(AVG(gr.grade), 2) AS avg_grade
FROM students s
         JOIN grades gr ON s.student_id = gr.student_id
GROUP BY s.full_name
HAVING AVG(gr.grade) > 8.5;