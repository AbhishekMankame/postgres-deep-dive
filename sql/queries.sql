SELECT o.id, u.name AS user_name, p.name AS product_name, o.quantity
FROM orders o
JOIN users u ON o.user_id = u.id
JOIN products p on o.product_id=p.id;