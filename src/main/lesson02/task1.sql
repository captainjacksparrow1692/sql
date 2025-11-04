CREATE TABLE customers(
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100) NOT NULL,
                          email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE orders(
                       id SERIAL PRIMARY KEY,
                       amount DECIMAL(10, 2) NOT NULL,
                       order_date DATE NOT NULL,
                       customer_id INT NOT NULL,
                       FOREIGN KEY (customer_id) REFERENCES customers(id)
);