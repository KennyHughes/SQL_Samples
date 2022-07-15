--Author: Kenneth Hughes
--Date: 2019.7.9
--PURPOSE: To help with determining your query run time for optimization
--RESULT: Return the number of milliseconds that it took for your query to run



--Insert this before your query
		DECLARE @start datetime;
		DECLARE @end datetime;

		SET @start = getdate();


		--Insert Your Query here--



--Insert this after your query
		SET @end = getdate();

		SELECT 'Run 1' AS 'Time to execute query', datediff(MILLISECOND, @start,@end) AS 'Elapsed time (milliseconds)';
