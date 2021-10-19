USE my_guitar_shop;
SELECT 
    email_address,
    COUNT(o.order_id) AS TotalOrder,
    SUM((item_price - discount_amount) * quantity) AS OrderAmount
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    order_items oi ON oi.order_id = o.order_id
GROUP BY email_address
HAVING COUNT(o.order_id) > 1
ORDER BY OrderAmount DESC;