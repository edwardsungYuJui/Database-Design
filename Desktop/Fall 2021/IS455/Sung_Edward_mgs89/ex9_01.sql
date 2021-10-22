USE my_guitar_shop;
SELECT 
    list_price,
    discount_percent,
    ROUND(list_price * discount_percent / 100, 2) AS discount_amount
FROM
    products;