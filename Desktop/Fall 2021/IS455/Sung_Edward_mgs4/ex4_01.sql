USE my_guitar_shop;
SELECT 
    category_name, product_name, list_price
FROM
    products AS p
        JOIN
    categories AS c ON c.category_id = p.category_id
ORDER BY category_name , product_name ASC;