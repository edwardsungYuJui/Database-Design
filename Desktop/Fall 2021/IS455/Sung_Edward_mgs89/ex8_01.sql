USE my_guitar_shop;
SELECT 
    list_price,
    FORMAT(list_price, 1) AS 'List Price',
    CONVERT( list_price , SIGNED) AS 'Int Price (CONVERT)',
    CAST(list_price AS SIGNED) AS 'Int Price (CAST)'
FROM
    products;