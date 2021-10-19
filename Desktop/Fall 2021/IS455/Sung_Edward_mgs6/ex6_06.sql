USE my_guitar_shop;
SELECT 
    product_name,
    SUM((item_price - discount_amount) * quantity) AS ProductTotal
FROM
    products p
        JOIN
    order_items oi ON p.product_id = oi.product_id
GROUP BY product_name WITH ROLLUP;