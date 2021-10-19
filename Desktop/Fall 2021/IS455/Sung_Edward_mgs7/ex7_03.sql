USE my_guitar_shop;
SELECT 
    c.category_name
FROM
    categories c
WHERE
    NOT EXISTS( SELECT 
            *
        FROM
            products p
        WHERE
            p.category_id = c.category_id);