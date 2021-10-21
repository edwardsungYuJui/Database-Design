USE my_guitar_shop;
SELECT 
    card_number, LENGTH(card_number), RIGHT(card_number, 4) AS "Last Four Digits",
    
FROM
    orders;