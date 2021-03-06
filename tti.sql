--SELECT * FROM MFG (TABLE A)
--SELECT * FROM SALES (TABLE B)
--SELECT * FROM PRODUCT (TABLE C)

--1. Display Full_MFG_Name in Table B without the MFG Code ( Example: �Amphenol�)

SELECT 
	SUBSTRING(M.FULL_MFG_NAME, 6, LEN(M.FULL_MFG_NAME)) AS FULL_MFG_NAME,
	S.PRODUCT, S.QUANTITY, S.UNIT_PRICE, S.VAUNITPRICE1, S.UNIT_COST, S.DATE
FROM SALES S
INNER JOIN MFG M ON S.MFG_CODE = M.MFG_CODE

--2. Calculate Total Revenue from Table B

SELECT SUM(QUANTITY * UNIT_PRICE) AS REVENUE FROM SALES

--3. Display the top 10 Products from Table B which made highest profit 
SELECT TOP 10 PRODUCT, SUM((UNIT_PRICE - UNIT_COST)* QUANTITY) AS PROFIT FROM SALES
GROUP BY PRODUCT
ORDER BY SUM((UNIT_PRICE - UNIT_COST)* QUANTITY) DESC

--4. Display total cost, total Price and Margins grouped by Parent_MFG in table A
SELECT 
	M.PARENT_MFG,
	SUM(S.UNIT_COST) AS TOTAL_COST, SUM(S.UNIT_PRICE) AS TOTAL_PRICE, SUM((S.UNIT_PRICE - UNIT_COST) / UNIT_PRICE) AS MARGINS_PERCENT
FROM SALES S
INNER JOIN MFG M ON S.MFG_CODE = M.MFG_CODE
GROUP BY M.PARENT_MFG

--5. Display the highest selling product and the second highest selling product
SELECT TOP 2 PRODUCT, SUM(QUANTITY * UNIT_PRICE) AS REVENUE FROM SALES
GROUP BY PRODUCT
ORDER BY SUM(QUANTITY * UNIT_PRICE) DESC


--6. Display the Total Cost and Total Revenue based on Type from Table C and order it in a descending order
SELECT 
	P.TYPE, SUM(S.UNIT_COST) AS TOTAL_COST,  SUM(S.QUANTITY * S.UNIT_PRICE) AS TOTAL_REVENUE
FROM SALES S 
INNER JOIN PRODUCT P ON P.PRODUCT = S.PRODUCT
GROUP BY P.TYPE
ORDER BY SUM(S.UNIT_COST) DESC

--7. Find which Quarter sold highest number of products

SELECT 
  TOP 1 CAST(YEAR(DATE) as char(4)) + ' - Q' + CAST(DATEPART(QUARTER,DATE) as char(1)) Quarter,
  SUM(QUANTITY) AS PRODUCTS_SOLD
FROM SALES 
GROUP BY CAST(YEAR(DATE) as char(4)) + ' - Q' + CAST(DATEPART(QUARTER,DATE) as char(1))
ORDER BY SUM(QUANTITY) DESC

--8. Find which quarter made the highest sale in �AUTOMOTIVE� category In the last year
SELECT 
	TOP 1 P.CATEGORY, SUM(S.QUANTITY * S.UNIT_PRICE) AS TOTAL_SALES,
	CAST(YEAR(S.DATE) as char(4)) + ' - Q' + CAST(DATEPART(QUARTER, S.DATE) as char(1)) Quarter
FROM SALES S 
INNER JOIN PRODUCT P ON P.PRODUCT = S.PRODUCT
GROUP BY P.CATEGORY, S.DATE
HAVING YEAR(S.DATE) = YEAR(GETDATE()) - 1 AND
P.CATEGORY = 'AUTOMOTIVE'
ORDER BY SUM(S.QUANTITY * S.UNIT_PRICE) DESC

--9. Find the Products in table C that haven�t sold anything ever
SELECT 
	PRODUCT
FROM 
PRODUCT 
	WHERE PRODUCT NOT IN (SELECT PRODUCT FROM SALES)

      