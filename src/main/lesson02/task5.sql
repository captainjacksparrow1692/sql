CREATE TABLE faculties(
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(255) NOT NULL
);

CREATE TABLE groups(
                       id SERIAL PRIMARY KEY,
                       name VARCHAR(255) NOT NULL,
                       faculty_id INT NOT NULL,
                       CONSTRAINT fk_faculty
                           FOREIGN KEY (faculty_id)
                               REFERENCES faculties (id)
                               ON DELETE SET NULL
);

CREATE TABLE students(
                         id SERIAL PRIMARY KEY,
                         name VARCHAR(255) NOT NULL,
                         group_id NUMERIC(10, 2),
                         CONSTRAINT fk_group
                             FOREIGN KEY (group_id)
                                 REFERENCES groups (id)
                                 ON DELETE SET NULL
);

CREATE TABLE teachers(
                         id SERIAL PRIMARY KEY,
                         name VARCHAR(255) NOT NULL
);

CREATE TABLE courses(
                        id SERIAL PRIMARY KEY,
                        name VARCHAR(255) NOT NULL,
                        teacher_id INT NOT NULL,
                        CONSTRAINT fk_teachers
                            FOREIGN KEY (teacher_id)
                                REFERENCES teachers (id)
                                ON DELETE CASCADE
);

CREATE TABLE student_courses(
                                student_id SERIAL PRIMARY KEY,
                                course_id SERIAL PRIMARY KEY,
                                grade INT CHECK (grade BETWEEN 1 AND 5),
                                PRIMARY KEY (student_id, course_id),
                                CONSTRAINT fk_students
                                    FOREIGN KEY (student_id)
                                        REFERENCES students(id)
                                        ON DELETE CASCADE,
                                CONSTRAINT fk_courses
                                    FOREIGN KEY (course_id)
                                        REFERENCES groups (id)
                                        ON DELETE CASCADE
);