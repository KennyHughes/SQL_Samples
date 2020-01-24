--Author: Kenneth Hughes
--Date: 2019.11.6
--PURPOSE: To help with emailing clients who locked down this month
--RESULT: Return all users who have logged in within the last month who have accounts that have a monthly, quarterly, or yearly lockdown delay equal to today
	--NOTE: Use schema1-server2. 
		--The Date Last Logged In could be a stale date. If a user is regularly logging in this shouldn't be an issue.

USE database1

DECLARE @DateLookup date = '11/5/2019'											--Enter the lockdown date that you want to look up




--Create a table with row numbers that lists all of the business days in last month
DECLARE @Dates Table (Row_Number int, SmallDate date)
	INSERT INTO @Dates (Row_Number, SmallDate)
		SELECT ROW_NUMBER() OVER (ORDER BY D.SmallDate) 'Row_Number', D.SmallDate
			FROM database2.schema1.table1 D
		WHERE D.DayOfWeek NOT IN (7,1)
			AND D.isHoliday = 0
			AND YEAR(D.SmallDate) = year(GETDATE())
			AND Month(D.SmallDate) = month(getdate())


SELECT ull.ClientID, c.Name, c.ParentID AS 'ParentcliendID', ull.UserID,
Convert(DATE,ull.LastLogin) as 'Date Last Logged In', ull.FullName, u.Email

	FROM ##UserLastLogintable ull
	JOIN database2.schema1.table2 u ON ull.UserID = u.ID
	JOIN database2.schema1.table3 c ON u.ClientID = c.ID
	JOIN database2.schema1.table4 cp ON c.ID = cp.clientID
		WHERE month(ull.LastLogin) IN 
		(month(Getdate())-3,month(getdate())-2,month(getdate())-1,month(getdate()))
		AND year(ull.LastLogin) = year(getdate())
		AND ull.UserspecificID IN 
					(SELECT u.userspecificID 
					FROM table5 u 
					WHERE u.emailaddress <> 'email@emaildomain.com'
					AND u.ClientSpecificID IN 
						(SELECT distinct(a.clientid) 
							FROM schema1.table5 a 
							WHERE (a.UserID1 in (SELECT id from users WHERE username = 'user1')						--Enter your username here
									OR a.UserId2 in (SELECT id from users WHERE username = 'user1'))						--Enter your username here
							AND ( 
							a.monthlydate = 
							(SELECT [@Dates].Row_Number FROM @Dates WHERE DAY(@DateLookup) = DAY([@Dates].SmallDate))
							OR a.quarterlydate = 
							(SELECT [@Dates].Row_Number FROM @Dates WHERE DAY(@DateLookup) = DAY([@Dates].SmallDate))
							OR a.yearlydate = 
							(SELECT [@Dates].Row_Number FROM @Dates WHERE DAY(@DateLookup) = DAY([@Dates].SmallDate))
					)))
			