USE my_guitar_shop;
UPDATE customers 
SET 
    password = 'secret'
WHERE
    email_address = 'rick@raven.com';