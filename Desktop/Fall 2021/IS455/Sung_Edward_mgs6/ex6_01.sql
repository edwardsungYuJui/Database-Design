USE my_guitar_shop;
SELECT 
    COUNT(order_id) AS 'Order Count',
    SUM(tax_amount) AS 'Tax Amount Total'
FROM
    orders; 