--CREATE TABLE
CREATE TABLE customers
(
    id         SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    address    VARCHAR(200),
    phone      VARCHAR(20)  NOT NULL

);

CREATE TABLE suppliers
(
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(255) NOT NULL,
    contacts VARCHAR(255)
);

CREATE TABLE categories
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(200) NOT NULL
);

CREATE TABLE employees
(
    id       SERIAL PRIMARY KEY,
    name     VARCHAR(100) NOT NULL,
    position VARCHAR(255)
);

CREATE TABLE products
(
    id           SERIAL PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    price        REAL         NOT NULL,
    category_id  INT,
    supplier_id  INT,
    FOREIGN KEY (category_id) REFERENCES categories (id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers (id)
);

CREATE TABLE orders
(
    id          SERIAL PRIMARY KEY,
    customer_id INT  NOT NULL,
    employee_id INT,
    order_date  DATE NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers (id),
    FOREIGN KEY (employee_id) REFERENCES Employees (id)
);

CREATE TABLE order_details
(
    order_id   INT,
    product_id INT,
    quantity   INT NOT NULL,
    discount   DECIMAL(4, 2),
    FOREIGN KEY (order_id) REFERENCES Orders (id),
    FOREIGN KEY (product_id) REFERENCES Products (id)
);

-- inserts

INSERT INTO customers (first_name, last_name, address, phone)
VALUES ('John', 'Doe', '123 Main St', '123-456-7890'),
       ('Jane', 'Doe', '456 Elm St', '098-765-4321'),
       ('Bob', 'Smith', '789 Oak St', '111-222-3333'),
       ('Alice', 'Johnson', '321 Pine St', '444-555-6666'),
       ('Charlie', 'Brown', '654 Maple St', '777-888-9999');

INSERT INTO suppliers (name, contacts)
VALUES ('Supplier A', 'contact@suppliera.com'),
       ('Supplier B', 'contact@supplierb.com'),
       ('Supplier C', 'contact@supplierc.com'),
       ('Supplier D', 'contact@supplierd.com'),
       ('Supplier E', 'contact@suppliere.com');

INSERT INTO categories (name)
VALUES ('Guitars'),
       ('Drums'),
       ('Amplifiers'),
       ('Accessories'),
       ('Keyboards');

INSERT INTO employees (name, position)
VALUES ('Employee A', 'Sales'),
       ('Employee B', 'Manager'),
       ('Employee C', 'Technician'),
       ('Employee D', 'Cashier'),
       ('Employee E', 'Stocker');

INSERT INTO products (product_name, price, category_id, supplier_id)
VALUES ('Product A', 100.00, 1, 1),
       ('Product B', 200.00, 2, 2),
       ('Product C', 300.00, 3, 3),
       ('Product D', 400.00, 4, 4),
       ('Product E', 500.00, 5, 5);

INSERT INTO orders (customer_id, employee_id, order_date)
VALUES (1, 1, '2024-01-01'),
       (2, 2, '2024-01-02'),
       (3, 3, '2024-01-03'),
       (4, 4, '2024-01-04'),
       (5, 5, '2024-01-05');

INSERT INTO order_details (order_id, product_id, quantity, discount)
VALUES (1, 1, 2, 0.00),
       (2, 2, 1, 0.10),
       (3, 3, 3, 0.05),
       (4, 4, 1, 0.20),
       (5, 5, 2, 0.15);



-- SELECT

-- DEFAULT SELECTS
SELECT products.product_name
FROM products
WHERE products.product_name LIKE '%duct%';

--

SELECT customers.first_name,
       customers.last_name,
       CASE
           WHEN COUNT(orders.id) > 5 THEN 'Постоянный клиент'
           ELSE 'Новый клиент'
           END AS customer_type
FROM customers
         LEFT JOIN orders ON customers.id = orders.customer_id
GROUP BY customers.first_name, customers.last_name;

--

SELECT customers.last_name, product_name, orders.order_date
FROM orders
         JOIN customers ON orders.customer_id = customers.id
         JOIN order_details od on orders.id = od.order_id
         JOIN products p on od.product_id = p.id
WHERE Customers.last_name = 'Doe'
ORDER BY orders.order_date DESC;

-- COUNT

SELECT COUNT(*)
FROM orders;

-- SUM

SELECT SUM(products.price * order_details.quantity)
FROM orders
         JOIN order_details ON orders.id = order_details.order_id
         JOIN products ON order_details.product_id = products.id;

-- MAX

SELECT MAX(products.price * order_details.quantity)
FROM orders
         JOIN order_details ON orders.id = order_details.order_id
         JOIN products ON order_details.product_id = products.id;

-- MIN

SELECT MIN(products.price * order_details.quantity)
FROM orders
         JOIN order_details ON orders.id = order_details.order_id
         JOIN products ON order_details.product_id = products.id;

-- AVG

SELECT AVG(products.price * order_details.quantity)
FROM orders
         JOIN order_details ON orders.id = order_details.order_id
         JOIN products ON order_details.product_id = products.id;

--

SELECT orders.id                                            AS order_id,
       products.price * order_details.quantity              AS total,
       AVG(products.price * order_details.quantity) OVER () AS avg
FROM orders
         JOIN order_details ON orders.id = order_details.order_id
         JOIN products ON order_details.product_id = products.id;
