# 🛒 E-Commerce Sales & Customer Analytics — SQL Project

## 📌 Project Overview

This is an end-to-end SQL analytics project built using an E-Commerce transactional database.

The objective of this project is to analyze sales performance, customer behavior, product performance, category performance, and product returns using SQL.

The project contains a relational database, datasets, and 30 business-focused SQL questions with their solutions.

---

## 🎯 Business Objective

The main objective is to use SQL to answer real-world business questions such as:

- How much revenue is the business generating?
- Which products generate the most revenue?
- Who are the highest-value customers?
- Which customers are new or repeat customers?
- How is revenue changing month over month?
- Which products perform better than their category average?
- Which products have high return rates?
- How can customers be segmented based on spending?

---

# 🗄️ Database Structure

The project uses the following tables:

| Table | Description |
|---|---|
| `customers` | Customer details |
| `orders` | Customer order information |
| `order_items` | Products and quantities within orders |
| `products` | Product information |
| `categories` | Product category information |
| `payments` | Payment transaction details |
| `returns` | Returned order-item information |

### Database Relationship

```text
customers
    │
    │ customer_id
    ↓
orders
    │
    │ order_id
    ↓
order_items
    │
    │ product_id
    ↓
products
    │
    │ category_id
    ↓
categories

orders ───────── payments

order_items ──── returns# ecommerce-sales-customer-analytics
End-to-end E-Commerce Sales &amp; Customer Analytics project using MySQL
