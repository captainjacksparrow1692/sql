CREATE TABLE customers(
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(100) NOT NULL,
                          email VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE orders(
                       id SERIAL PRIMARY KEY,
                       customer_id INT NOT NULL,
                       ordered_at DATE NOT NULL,
                       CONSTRAINT fk_customer
                           FOREIGN KEY (customer_id)
                               REFERENCES customers(id)
                               ON DELETE CASCADE
);

CREATE TABLE products(
                         id SERIAL PRIMARY KEY,
                         name VARCHAR(255) NOT NULL,
                         price NUMERIC(10,2) NOT NULL CHECK (price > 0)
);

CREATE TABLE order_items(
                            order_id INT NOT NULL,
                            product_id INT NOT NULL,
                            amount NUMERIC(10, 2) NOT NULL CHECK (amount > 0),
                            PRIMARY KEY (order_id, product_id),
                            CONSTRAINT fk_product
                                FOREIGN KEY (product_id)
                                    REFERENCES products(id)
                                    ON DELETE CASCADE,
                            CONSTRAINT fk_order
                                FOREIGN KEY (order_id)
                                    REFERENCES orders(id)
                                    ON DELETE CASCADE
);