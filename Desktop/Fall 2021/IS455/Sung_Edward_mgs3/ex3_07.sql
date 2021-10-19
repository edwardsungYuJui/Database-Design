USE my_guitar_shop;
SELECT 
    NOW() AS today_unformatted,
    DATE_FORMAT(NOW(), '%d-%b-%Y') AS today_formatted;