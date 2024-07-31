#SQL Query to transform raw data into the desired format suitable for ML algorithm application.

CREATE TABLE finaltable 
AS
SELECT "TDS #", "# days", "year", "season", "charge range" FROM 
(SELECT *,
    -- Extracting Month
    CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) AS "Month",
    -- Extracting Year
    CAST(SUBSTRING("Revenue Month", 1, CHARINDEX('-', "Revenue Month") - 1) AS INT) AS "Year",
    -- Determining Season based on Month
    CASE
        WHEN CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) IN (3, 4, 5) THEN 1
        WHEN CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) IN (6, 7, 8) THEN 2
        WHEN CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) IN (9, 10, 11) THEN 3
        WHEN CAST(SUBSTRING("Revenue Month", CHARINDEX('-', "Revenue Month") + 1, LEN("Revenue Month") - CHARINDEX('-', "Revenue Month")) AS INT) IN (12, 1, 2) THEN 4
    END AS "Season",
    -- Determining Charge Range
    CASE
        WHEN "Water&Sewer Charges" > 0 AND "Water&Sewer Charges" <= 1000 THEN '0-1000'
        WHEN "Water&Sewer Charges" > 1000 AND "Water&Sewer Charges" <= 2000 THEN '1001-2000'
        WHEN "Water&Sewer Charges" > 2000 AND "Water&Sewer Charges" <= 3000 THEN '2001-3000'
        WHEN "Water&Sewer Charges" > 3000 AND "Water&Sewer Charges" <= 4000 THEN '3001-4000'
        WHEN "Water&Sewer Charges" > 4000 AND "Water&Sewer Charges" <= 5000 THEN '4001-5000'
        WHEN "Water&Sewer Charges" > 5000 AND "Water&Sewer Charges" <= 6000 THEN '5001-6000'
        WHEN "Water&Sewer Charges" > 6000 AND "Water&Sewer Charges" <= 7000 THEN '6001-7000'
        WHEN "Water&Sewer Charges" > 7000 AND "Water&Sewer Charges" <= 8000 THEN '7001-8000'
        WHEN "Water&Sewer Charges" > 8000 AND "Water&Sewer Charges" <= 9000 THEN '8001-9000'
        WHEN "Water&Sewer Charges" > 9000 AND "Water&Sewer Charges" <= 10000 THEN '9001-10000'
        WHEN "Water&Sewer Charges" > 10000 AND "Water&Sewer Charges" <= 11000 THEN '10000-11000'
        WHEN "Water&Sewer Charges" > 11000 AND "Water&Sewer Charges" <= 12000 THEN '11001-12000'
        WHEN "Water&Sewer Charges" > 12000 AND "Water&Sewer Charges" <= 13000 THEN '12001-13000'
        WHEN "Water&Sewer Charges" > 13000 AND "Water&Sewer Charges" <= 14000 THEN '13001-14000'
        WHEN "Water&Sewer Charges" > 14000 AND "Water&Sewer Charges" <= 15000 THEN '14001-15000'
        WHEN "Water&Sewer Charges" > 15000 AND "Water&Sewer Charges" <= 16000 THEN '15001-16000'
        WHEN "Water&Sewer Charges" > 16000 AND "Water&Sewer Charges" <= 17000 THEN '16001-17000'
        WHEN "Water&Sewer Charges" > 17000 AND "Water&Sewer Charges" <= 18000 THEN '17001-18000'
        WHEN "Water&Sewer Charges" > 18000 AND "Water&Sewer Charges" <= 19000 THEN '18001-19000'
        WHEN "Water&Sewer Charges" > 19000 AND "Water&Sewer Charges" <= 20000 THEN '19001-20000'
        WHEN "Water&Sewer Charges" > 20000 AND "Water&Sewer Charges" <= 30000 THEN '20001-30000'
        WHEN "Water&Sewer Charges" > 30000 AND "Water&Sewer Charges" <= 40000 THEN '30001-40000'
        WHEN "Water&Sewer Charges" > 40000 AND "Water&Sewer Charges" < 50000 THEN '40001-50000'
        ELSE 'Out of range'
    END AS "Charge range"
FROM "dev"."public"."redwatertable"
WHERE
CAST("# days" AS INT) BETWEEN 25 and 35 
AND "tds #" is NOT NULL 
AND CAST(REPLACE("Water&Sewer Charges",',','') AS FLOAT) > 0)
