----(HISReport)

--note dump the rpt_dump daily revenue from his views

SELECT 
	* 
	,transaction_date_text = rtrim(transaction_date_month_name) + '-' + rtrim(transaction_date_year_rcd)
FROM(

SELECT 
	charge_detail_id
	,patient_visit_id
	,hospital_nr
	,patient_name
	,admission_type
	,admission_type_after_move
	,admitting_doctor
	,bed
	,order_owner
	,order_owner_specialty
	,order_owner_sub_specialty
	,item_group_code
	,item_group_name
	,item_code
	,item_desc
	,item_type_code
	,item_type
	,visit_type_rcd
	,visit_type_rcd_after_move
	,visit_type_category
	,visit_type_after_move_category
	,quantity
	,total_amt
	,service_requestor
	,service_provider
	,service_category = CASE WHEN service_category IS NULL THEN item_group_name ELSE service_category END
	,gl_acct_code
	,gl_acct_name
	,transaction_date_time
	,transaction_date_day_rcd = (SELECT day_rcd from HISReport.dbo.rpt_KHM_day_ref with (nolock) WHERE day_rcd = DAY(transaction_date_time))
	,transaction_date_month_rcd = (SELECT month_rcd from HISReport.dbo.rpt_KHM_month_ref with (nolock) WHERE month_rcd = MONTH(transaction_date_time))
	,transaction_date_month_name = (SELECT name from HISReport.dbo.rpt_KHM_month_ref with (nolock) WHERE month_rcd = MONTH(transaction_date_time))
	,transaction_date_year_rcd = YEAR(transaction_date_time)
	,transaction_type
	,transaction_by
	,current_diagnosis = (SELECT TOP 1 diagnosis FROM HISReport.dbo.ref_patient_diagnosis with (nolock) WHERE patient_visit_id = DRD.patient_visit_id AND current_visit_diagnosis_flag = 1 ORDER BY recorded_at_date_time DESC)
	--,current_diagnosis_type_rcd = (SELECT TOP 1 diagnosis_type_rcd FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND current_visit_diagnosis_flag = 1 ORDER BY recorded_at_date_time DESC)
	--,current_diagnosis_type = (SELECT TOP 1 diagnosis_type FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND current_visit_diagnosis_flag = 1 ORDER BY recorded_at_date_time DESC)
	--,current_coding_type_rcd = (SELECT TOP 1 coding_type_rcd FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND current_visit_diagnosis_flag = 1 ORDER BY recorded_at_date_time DESC)
	--,current_coding_type = (SELECT TOP 1 coding_type FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND current_visit_diagnosis_flag = 1 ORDER BY recorded_at_date_time DESC)	
	--,current_code = (SELECT TOP 1 code FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND current_visit_diagnosis_flag = 1 ORDER BY recorded_at_date_time DESC)		
	,admitting_diagnosis = (SELECT TOP 1 diagnosis FROM HISReport.dbo.ref_patient_diagnosis with (nolock) WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'ADM' ORDER BY recorded_at_date_time DESC)
	--,admitting_diagnosis_type_rcd = (SELECT TOP 1 diagnosis_type_rcd FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'ADM' ORDER BY recorded_at_date_time DESC)	
	--,admitting_diagnosis_type = (SELECT TOP 1 diagnosis_type FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'ADM' ORDER BY recorded_at_date_time DESC)	
	--,admitting_coding_type_rcd = (SELECT TOP 1 coding_type_rcd FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'ADM' ORDER BY recorded_at_date_time DESC)	
	--,admitting_coding_type = (SELECT TOP 1 coding_type FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'ADM' ORDER BY recorded_at_date_time DESC)		
	--,admitting_code = (SELECT TOP 1 code FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'ADM' ORDER BY recorded_at_date_time DESC)			
	,discharge_diagnosis = (SELECT TOP 1 diagnosis FROM HISReport.dbo.ref_patient_diagnosis with (nolock) WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'DIS' ORDER BY recorded_at_date_time DESC)
	--,discharge_diagnosis_type_rcd = (SELECT TOP 1 diagnosis_type_rcd FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'DIS' ORDER BY recorded_at_date_time DESC)
	--,discharge_diagnosis_type = (SELECT TOP 1 diagnosis_type FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'DIS' ORDER BY recorded_at_date_time DESC)
	--,discharge_coding_type_rcd = (SELECT TOP 1 coding_type_rcd FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'DIS' ORDER BY recorded_at_date_time DESC)
	--,discharge_coding_type = (SELECT TOP 1 coding_type FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'DIS' ORDER BY recorded_at_date_time DESC)
	--,discharge_code = (SELECT TOP 1 code FROM HISReport.dbo.ref_patient_diagnosis WHERE patient_visit_id = DRD.patient_visit_id AND diagnosis_type_rcd = 'DIS' ORDER BY recorded_at_date_time DESC)
	
FROM
	HISReport.dbo.rpt_daily_revenue_detailed_temp DRD with (nolock)	
)[rpt_daily_revenue_detailed_all]	

WHERE
MONTH(transaction_date_time) = 12
AND YEAR(transaction_date_time) = 2017
AND transaction_date_year_rcd = 2017
--AND
--	service_provider = @service_provider
AND
	item_type_code ='SRV'--IN (@item_type_code)

	--AND rpt_daily_revenue_detailed_all.gl_acct_code not IN ('2152250','2152100') --remove the doctor's fee (Physician's Fees Payables/Physician's Fees Payables-ER)
	AND rpt_daily_revenue_detailed_all.gl_acct_code NOT IN ('2152250','2152100','2154940','2154950', '4264000') --removed Accounts Payable - Medical Physicist, Accounts Payable - Pediatric Department, Physician's Fees Payable ,Physician's Fees Payable, Physician's Fees Payable - ER, Reader's Fee Revenue
    AND rpt_daily_revenue_detailed_all.item_code NOT IN ('650-9050', '600-30-0001', '600-300-0002')
	--AND rpt_daily_revenue_detailed_all.visit_type_category = 'ER' --For ER Volume Details


ORDER BY
	transaction_date_text, item_type DESC, item_group_name, item_desc, transaction_type, transaction_date_time
	
--select * from rpt_daily_revenue_detailed_temp where transaction_date_time between '5/01/2014 00:00:00.000'  and '5/31/2014 23:59:59.998'

