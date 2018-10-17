--DataSet 4 - Service Count per Service (All)
SELECT DISTINCT department 
FROM HISReport.dbo.ref_costcentre_daily_revenue_detailed 
WHERE [group] =  'Clinical Operations' ORDER BY department