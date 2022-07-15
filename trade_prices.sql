--Author: Kenneth Hughes
--Date: 2020.1.27
--PURPOSE: To help with determining what prices clients are using on trades for this security and date
--RESULT: Return all accounts with transactions for these cusips on given date

SELECT DISTINCT(t.Clientsaccount), 
       AVG(t.Securityprice) as Average_Price
  FROM trades t
    WHERE t.ID IN (SELECT s.id FROM Securities s WHERE s.Cusip in('CUSIP'))
    AND t.Date = '9/19/2019'
  GROUP BY t.Clientaccount, t.Securityprice
  ORDER BY Average_Price;
