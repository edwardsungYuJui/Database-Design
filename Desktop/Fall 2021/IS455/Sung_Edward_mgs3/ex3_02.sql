USE my_guitar_shop;
SELECT 
    CONCAT(last_name, ', ', first_name) AS full_name
FROM
    customers
WHERE
    last_name REGEXP '^[M-Z]'
ORDER BY last_name ASC;

