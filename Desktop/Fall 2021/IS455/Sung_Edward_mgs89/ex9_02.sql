USE my_guitar_shop;
SELECT 
    order_date,
    DATE_FORMAT(order_date, '%Y') AS 'Year',
    DATE_FORMAT(order_date, '%b-%e-%Y') AS 'Full Date',
    DATE_FORMAT(order_date, '%l-%i-%p') AS 'Date Time 12',
    DATE_FORMAT(order_date, '%m/%e/%y %H:%i') AS 'Date Time 24'
FROM
    orders;