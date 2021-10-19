USE my_guitar_shop;
SELECT 
    email_address,
    SUM(item_price * quantity) AS TotalPrice,
    SUM(discount_amount * quantity) AS DiscountAmount
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    order_items oi ON oi.order_id = o.order_id
GROUP BY email_address
ORDER BY TotalPrice DESC;