--Dataset 3 - Service Count per Service Detailed
SELECT DISTINCT department 
FROM HISReport.dbo.ref_costcentre_daily_revenue_detailed 
WHERE [group] =  'Clinical Operations' ORDER BY department