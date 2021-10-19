USE my_guitar_shop;
SELECT 
    product_name,
    list_price,
    discount_percent,
    ROUND(list_price * (discount_percent / 100), 2) AS discount_amount,
    ROUND(list_price - (discount_percent / 100 * list_price), 2) AS discount_price
FROM
    products
ORDER BY (list_price - ((discount_percent / 100) * list_price)) DESC
LIMIT 5;

