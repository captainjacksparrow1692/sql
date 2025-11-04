CREATE TABLE categories(
                           id SERIAL PRIMARY KEY,
                           name VARCHAR(255) NOT NULL
);

CREATE TABLE products(
                         id SERIAL PRIMARY KEY,
                         name VARCHAR(255) NOT NULL,
                         price DECIMAL(10, 2) NOT NULL CHECK ( price > 0),
                         category_id INT,
                         CONSTRAINT fk_category
                             FOREIGN KEY (category_id)
                                 REFERENCES categories(id)
                                 ON DELETE SET NULL

);