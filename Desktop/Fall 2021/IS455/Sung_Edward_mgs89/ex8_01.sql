USE my_guitar_shop;
SELECT 
    list_price,
    FORMAT(list_price, 1),
    CONVERT( list_price , CHAR (4)),
    CAST(list_price AS CHAR (4))
FROM
    products;