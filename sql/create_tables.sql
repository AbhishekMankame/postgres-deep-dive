CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    email VARCHAR(100)

);

CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    price NUMERIC(10,2)
);

CREATE table orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    product_id INT REFERENCES products(id),
    quantity INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);