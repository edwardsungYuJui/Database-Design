USE my_guitar_shop;
SELECT 
    c.last_name,
    c.first_name,
    order_date,
    p.product_name,
    item_price,
    discount_amount,
    quantity
FROM
    customers AS c
        JOIN
    orders AS o ON c.customer_id = o.customer_id
        JOIN
    order_items AS oi ON o.order_id = oi.order_id
        JOIN
    products AS p ON oi.product_id = p.product_id
ORDER BY last_name , order_date , product_name;
