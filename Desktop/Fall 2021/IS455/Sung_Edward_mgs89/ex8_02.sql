USE my_guitar_shop;
SELECT 
    date_added,
    CAST(date_added AS CHAR (10)) AS 'Date',
    CAST(date_added AS CHAR (7)) AS 'Year/Month',
    CAST(date_added AS TIME) AS 'Time'
FROM
    products;
