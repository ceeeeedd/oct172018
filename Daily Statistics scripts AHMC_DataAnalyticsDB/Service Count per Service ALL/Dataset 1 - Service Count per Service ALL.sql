--Dataset 1 - Service Count per Service ALL
SELECT *
FROM(
SELECT
	transaction_date_year_rcd = YEAR(transaction_date_time)
	,transaction_date_month_rcd =month(transaction_date_time)
	,transaction_date_month_name = DATENAME(MONTH,transaction_date_time)
	 ,admission_type
	 ,department
	 ,service_provider
	 ,service_category
	 ,visit_type_category
	 ,visit_type_after_move_category
	 ,item_type
	 ,item_code	 
	 ,item_desc = (SELECT name_l FROM HISReport.dbo.ref_item WHERE item_code collate database_default = DRD.item_code collate database_default) 
	 ,[count] = SUM(quantity)
FROM
	 AHMC_DataAnalyticsDB.dbo.rpt_daily_statistics DRD
INNER JOIN
	HISReport.dbo.ref_costcentre_daily_revenue_detailed CDRD  ON DRD.service_provider collate database_default = CDRD.name_l collate database_default
GROUP BY
	YEAR(transaction_date_time)
	,month(transaction_date_time)
	,DATENAME(MONTH,transaction_date_time)
	,item_type
	,department
	,service_provider	
	,admission_type
	,service_category
	,visit_type_category
	,visit_type_after_move_category
    ,item_code

)rpt_vw_drd_service_count_per_service_all

WHERE
(transaction_date_year_rcd = CONVERT(INT, @year) OR
 transaction_date_year_rcd = CONVERT(INT, @year) - 1) AND (transaction_date_month_rcd = @month) AND department = @department and item_type in (@item_type)