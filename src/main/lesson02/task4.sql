CREATE TABLE customers(
                          id SERIAL PRIMARY KEY,
                          name VARCHAR(255) NOT NULL,
                          email VARCHAR(255) UNIQUE NOT NULL
);

CREATE TABLE products(
                         id SERIAL PRIMARY KEY,
                         name VARCHAR(255) NOT NULL,
                         price DECIMAL(10, 2) NOT NULL CHECK ( price > 0)
);

CREATE TABLE orders(
                       id SERIAL PRIMARY KEY,
                       amount DECIMAL(10, 2) NOT NULL CHECK(amount > 0),
                       order_date DATE NOT NULL,
                       customer_id INT,
                       CONSTRAINT fk_customer
                           FOREIGN KEY (customer_id)
                               REFERENCES customers(id)
                               ON DELETE CASCADE
);

CREATE TABLE order_items(
                            id SERIAL PRIMARY KEY,
                            order_id INT NOT NULL,
                            product_id INT NOT NULL,
                            amount INT NOT NULL CHECK ( amount > 0 ),
                            CONSTRAINT fk_order
                                FOREIGN KEY (order_id)
                                    REFERENCES orders (id)
                                    ON DELETE CASCADE,
                            CONSTRAINT fk_product
                                FOREIGN KEY (product_id)
                                    REFERENCES products (id)
                                    ON DELETE CASCADE

);