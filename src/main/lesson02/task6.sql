CREATE TABLE users(
                      id SERIAL PRIMARY KEY,
                      name VARCHAR(255) NOT NULL,
                      email VARCHAR(255) UNIQUE NOT NULL,
                      created_at DATE NOT NULL
);

CREATE TABLE posts(
                      id SERIAL PRIMARY KEY,
                      user_id INT NOT NULL,
                      text TEXT NOT NULL,
                      created_at DATE NOT NULL,
                      CONSTRAINT fk_users
                          FOREIGN KEY (user_id)
                              REFERENCES users (id)
                              ON DELETE CASCADE
);

CREATE TABLE comments(
                         id SERIAL PRIMARY KEY,
                         post_id INT NOT NULL,
                         user_id INT NOT NULL,
                         text TEXT NOT NULL,
                         created_at DATE NOT NULL,
                         CONSTRAINT fk_post_comment
                             FOREIGN KEY (post_id)
                                 REFERENCES posts(id)
                                 ON DELETE CASCADE,
                         CONSTRAINT fk_user_comment
                             FOREIGN KEY (user_id)
                                 REFERENCES users(id)
                                 ON DELETE CASCADE
);

CREATE TABLE likes(
                      user_id INT NOT NULL,
                      post_id INT NOT NULL,
                      PRIMARY KEY (user_id, post_id),
                      CONSTRAINT fk_post_like
                          FOREIGN KEY (post_id)
                              REFERENCES posts(id)
                              ON DELETE CASCADE,
                      CONSTRAINT fk_user_like
                          FOREIGN KEY (user_id)
                              REFERENCES users(id)
                              ON DELETE CASCADE
);