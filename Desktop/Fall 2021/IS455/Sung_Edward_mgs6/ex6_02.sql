USE my_guitar_shop;
SELECT 
    category_name,
    COUNT(*) AS CountTotal,
    MAX(list_price) AS MostExpensiveItem
FROM
    categories c
        JOIN
    products p ON c.category_id = p.category_id
GROUP BY category_name
ORDER BY CountTotal DESC;