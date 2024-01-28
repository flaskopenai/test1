SELECT
  Title,
  Category,
  TO_CHAR(Retail, '$9999.99') AS "Current Price",
  TO_CHAR(Retail * 
    CASE
      WHEN Category = 'Computer' THEN 1.10
      WHEN Category = 'Fitness' THEN 1.15
      WHEN Category = 'Self Help' THEN 1.25
      ELSE 1.03
    END, '$9999.99') AS "Revised Price"
FROM
  Books
ORDER BY
  Category,
  Title;
