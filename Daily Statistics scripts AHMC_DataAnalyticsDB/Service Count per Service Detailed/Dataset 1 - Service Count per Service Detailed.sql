--Dataset 1 - Service Count per Service Detailed

SELECT  transaction_date_year_rcd, 
		transaction_date_month_rcd, 
		transaction_date_month_name, 
		admission_type, 
		order_owner, 
		order_owner_specialty, 
		department, 
		service_provider, 
		service_category, 
		visit_type_category, 
		item_type, item_code, 
		item_desc, 
		count
FROM            
(SELECT transaction_date_year_rcd, 
		transaction_date_month_rcd, 
		transaction_date_month_name, 
		admission_type, order_owner, 
		order_owner_specialty, 
		department, 
		service_provider, 
		service_category, 
		visit_type_category, 
		item_type, item_code, 
		item_desc, 
		SUM(quantity) AS count
                     FROM            
					 (SELECT YEAR(DRD.transaction_date_time) AS transaction_date_year_rcd, 
							 MONTH(DRD.transaction_date_time) AS transaction_date_month_rcd, 
							 DATENAME(month, DRD.transaction_date_time) AS transaction_date_month_name,
							 DRD.admission_type, CASE WHEN order_owner IS NULL  THEN 'No Order Owner' ELSE order_owner END AS order_owner, 
							 CASE WHEN order_owner_specialty IS NULL THEN 'No Specialty' ELSE order_owner_specialty END AS order_owner_specialty,
							 CDRD.department, 
							 DRD.service_provider, 
                             DRD.service_category, 
							 DRD.visit_type_category, 
							 DRD.item_type, 
							 DRD.item_code,
                             (SELECT name_l FROM hisreport.dbo.ref_item
                              WHERE (item_code collate database_default = DRD.item_code collate database_default)) AS item_desc, DRD.quantity
                              FROM AHMC_DataAnalyticsDB.dbo.rpt_daily_statistics AS DRD 
							  INNER JOIN HISReport.dbo.ref_costcentre_daily_revenue_detailed AS CDRD ON DRD.service_provider collate database_default = CDRD.name_l collate database_default) AS rpt_vw_drd_service_count_per_doctor_all_detailed1
                          WHERE (transaction_date_year_rcd = CONVERT(INT, 2018) OR
                                                    transaction_date_year_rcd = CONVERT(INT, 2018) - 1) AND (transaction_date_month_rcd = 9) AND (department = 'radiology') AND 
                                                    (item_type IN ('inventory','service'))
                          GROUP BY transaction_date_year_rcd, 
						  transaction_date_month_rcd, 
						  transaction_date_month_name, 
						  item_type, department, 
						  service_provider, 
						  admission_type, 
                          order_owner, 
						  order_owner_specialty, 
						  visit_type_category, 
						  service_category, 
						  item_code, 
						  item_desc
						  ) AS rpt_vw_drd_service_count_per_doctor_all_detailed