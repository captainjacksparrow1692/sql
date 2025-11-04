CREATE TABLE departments(
                            id SERIAL PRIMARY KEY,
                            name VARCHAR(255) NOT NULL
);

CREATE TABLE employees(
                          id SERIAL PRIMARY KEY,
                          employee_name VARCHAR(255) NOT NULL,
                          position VARCHAR(100) NOT NULL,
                          department INT,
                          CONSTRAINT fk_department
                              FOREIGN KEY (department)
                                  REFERENCES departments (id)
                                  ON DELETE SET NULL
);