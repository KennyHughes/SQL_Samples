--Author: Kenneth Hughes
--Date: 2019.11.13
--PURPOSE: To help with determining which clients/accounts should be prioritized for automating
--RESULT: Return the number of actions taken for your clients this month

SELECT c.Name as "Client Name", t.[Number of Accounts], t.[Number of Commands], t.[Number of Commands]/t.[Number of Accounts] AS 'Average Number of Commands Per Account'
		FROM
		(SELECT upc.ID, COUNT(DISTINCT(rd.ID)) AS 'Number of Accounts', sum(rd.Commands) AS 'Number of Commands'
			FROM Table2 rd
			JOIN Table3 a ON rd.ID = a.ID
			JOIN Table4 c ON a.ID = c.ID
			JOIN Table5 upc ON c.ID = upc.ID
				WHERE year(GETDATE()) = year(rd.Date)
					AND month(GETDATE()) = month(rd.Date)
					AND rd.Auto = 0
					AND rd.Id IN (SELECT u.id FROM Table6 u WHERE u.username = 'USER'												--Put your username here
					) GROUP BY upc.ID
					) AS t
					JOIN Table7 c ON t.ID = c.ID
					ORDER BY t.[Number of Commands]/t.[Number of Accounts] DESC
