USE my_guitar_shop;
SELECT 
    email_address,
    COUNT(DISTINCT oi.product_id) AS ProductNumber
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    order_items oi ON o.Order_id = oi.order_id
GROUP BY email_address
HAVING COUNT(DISTINCT oi.product_id) > 1
ORDER BY email_address