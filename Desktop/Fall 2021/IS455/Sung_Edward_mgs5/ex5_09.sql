USE my_guitar_shop;
UPDATE customers 
SET 
    password = 'reset'
LIMIT 100;
