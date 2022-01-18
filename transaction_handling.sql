--Author: Kenneth Hughes
--Date: 2019.11.6
--PURPOSE: To help with determining how other clients have handeled transactions for this security on a specific date
--RESULT: Return all transactions for this cusip


SELECT *
FROM Table1 T1
WHERE T1.ID = (SELECT T2.ID from Table2 T2 where T2.CUSIP = 'CUSIP')		 --Enter your CUSIP here
AND T1.Date = '11/20/19'                                                   --Enter the date here
AND T1.Status IS NOT NULL
AND T1.Type = 'COUPON'
