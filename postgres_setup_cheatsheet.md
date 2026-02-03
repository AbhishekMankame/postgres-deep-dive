## POSTGRES Sandbox Cheatsheet (Codespaces)

### 1.Connect to the database
<pre>psql -h localhost -p 5433 -U codespace -d postgres_sandbox</pre>

- -h localhost -> host
- -p 5433 -> mapped container port
- -U codespace -> username
- -d postgres_sandbox -> database name
- Password: codespace

### 2.Exit psql
<pre>\q</pre>

- Quit Postgres prompt

### 3. Turn off pager
<pre>\pset pager off</pre>

- Prevent (END) screens for long outputs

### 4.List databases
<pre>\l</pre>

- Shows all databases in the container

### 5.List tables
<pre>\dt</pre>

- Shows all tables in the current database

### 6.Create tables
<pre>

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

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    product_id INT REFERENCES products(id),
    quantity INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

</pre>

### 7.Insert sample data
<pre>

INSERT INTO users (name, email) VALUES
('Alice', 'alice@example.com'),
('Bob', 'bob@example.com');

INSERT INTO products (name, price) VALUES
('Laptop', 1000),
('Phone', 500);

INSERT INTO orders (user_id, product_id, quantity) VALUES
(1, 1, 1),
(2, 2, 2);

</pre>

### 8.Query data
<pre>

SELECT * FROM users;
SELECT * FROM products;
SELECT * FROM orders;

-- Join example
SELECT o.id, u.name AS user_name, p.name AS product_name, o.quantity
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p ON o.product_id = p.id;

</pre>

### 9.Run SQL files
<pre>

psql -h localhost -p 5433 -U codespace -d postgres_sandbox -f sql/create_tables.sql
psql -h localhost -p 5433 -U codespace -d postgres_sandbox -f sql/insert_data.sql

</pre>

- -f -> executes all commands in a file

### 10.Docker commands for sandbox
<pre>

docker-compose up -d       # Start Postgres container
docker-compose down        # Stop & remove container
docker ps                  # List running containers
docker ps -a               # List all containers
docker logs pg-sandbox     # Check container logs

</pre>

## Closing Setup

### 1.Exit psql
- \q -> This quits psql and brings you back to your normal terminal

### 2.Stop the Docker container
Since we used `docker-compose`, run:
<pre>docker-compose down</pre>

- Stops the container
- Removes ir from running state (data is persisted in the Docker volume you create)
<pre>docker-compose stop</pre>

- To start it again later:
<pre>docker-compose start</pre>

### 3.Verify everything is stopped
<pre>docker ps</pre>

- No `pg-sandbox` container should appear
- If you want to see all container (even stopped ones):
<pre>docker ps -a</pre>