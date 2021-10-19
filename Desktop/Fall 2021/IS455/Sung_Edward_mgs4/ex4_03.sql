USE my_guitar_shop;
SELECT 
    first_name, last_name, line1, city, state, zip_code
FROM
    customers c
        JOIN
    addresses a ON c.customer_id = a.customer_id
        AND c.shipping_address_id = a.address_id;

