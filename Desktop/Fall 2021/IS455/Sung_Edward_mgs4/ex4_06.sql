SELECT 
    c.category_name, p.product_id
FROM
    categories c
        LEFT JOIN
    products p ON c.category_id = p.category_id
WHERE
    product_id IS NULL;