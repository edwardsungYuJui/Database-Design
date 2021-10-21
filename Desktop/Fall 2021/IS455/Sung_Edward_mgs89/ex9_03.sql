USE my_guitar_shop;
SELECT 
    card_number,
    LENGTH(card_number),
    RIGHT(card_number, 4) AS 'Last Four Digits',
    IF(LENGTH(card_number) = 16,
        CONCAT('XXXX-XXXX-XXXX-', RIGHT(card_number, 4)),
        CONCAT('XXXX-XXXXXX-X', RIGHT(card_number, 4))) AS "Digits Displayed"
FROM
    orders;