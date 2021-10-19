USE my_guitar_shop;
SELECT 
    c.email_address, o.order_id, o.order_date
FROM
    customers c
        JOIN
    orders o
WHERE
    o.order_date = (SELECT 
            MIN(o.order_date)
        FROM
            orders o
        WHERE
            c.customer_id = o.customer_id)
ORDER BY o.order_date , o.order_id;