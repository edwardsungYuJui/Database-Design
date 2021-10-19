USE my_guitar_shop;
SELECT 
    c.email_address,
    o.order_id,
    SUM((item_price - discount_amount) * quantity) AS OrderTotal
FROM
    order_items oi
        JOIN
    orders o ON oi.order_id = o.order_id
        JOIN
    customers c ON o.customer_id = c.customer_id
GROUP BY c.email_address , o.order_id;
SELECT 
    email_address, MAX(order_total) AS largest_order
FROM
    (SELECT 
        customers.email_address,
            orders.order_id,
            SUM((item_price - discount_amount) * quantity) AS order_total
    FROM
        customers
    JOIN orders ON customers.customer_id = orders.customer_id
    JOIN order_items ON orders.order_id = order_items.order_id
    GROUP BY customers.email_address , order_items.order_id) AS result
GROUP BY email_address
ORDER BY MAX(order_total) DESC;