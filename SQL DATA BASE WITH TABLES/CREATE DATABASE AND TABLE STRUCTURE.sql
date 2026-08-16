CREATE DATABASE ecommerce_analytics;
USE ecommerce_analytics;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(150),
    city VARCHAR(50),
    signup_date DATE
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(150),
    category_id INT,
    price DECIMAL(12,2),
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(12,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    amount DECIMAL(12,2),
    payment_method VARCHAR(40),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY,
    order_item_id INT,
    return_date DATE,
    return_quantity INT,
    reason VARCHAR(100),
    FOREIGN KEY (order_item_id) REFERENCES order_items(order_item_id)
);