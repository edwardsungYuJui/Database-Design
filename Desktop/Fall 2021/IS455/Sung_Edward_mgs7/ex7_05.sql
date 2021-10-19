USE my_guitar_shop;
SELECT 
    product_name, discount_percent
FROM
    products
WHERE
    discount_percent IN (SELECT 
            discount_percent
        FROM
            products
        GROUP BY discount_percent
        HAVING COUNT(*) = 1)
ORDER BY product_name;