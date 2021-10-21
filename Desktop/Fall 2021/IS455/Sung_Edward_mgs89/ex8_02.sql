USE my_guitar_shop;
SELECT 
    date_added,
    CAST(date_added AS CHAR (10)),
    CAST(date_added AS CHAR(7)),
    CAST(date_added AS TIME)
FROM
    products
