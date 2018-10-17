declare @dReferenceDate smalldatetime

set @dReferenceDate = CONVERT(varchar(10),GETDATE(),101)


SELECT temp.bed_cleaning_status_rcd,
	   temp.start_date_time,
	   temp.end_date_time,
	   temp.ward_name,
	   temp.bed_code,
	   temp.bed_status_name,
	   temp.lu_user_id,
	   temp.lu_updated,
	   elapse_time = CAST(temp.age_day as VARCHAR) + ':' + CAST(temp.age_hrs as VARCHAR) + ':' + CAST(temp.age_min as VARCHAR) + ':' + CAST(temp.age_sec as VARCHAR),
	 
	   temp.updated_by,
	   updated_by_2 = case when (SELECT top 1 bed_cleaning_status_rcd
								from bed_cleaning_status
								where bed_id = temp.bed_id
									 and CAST(CONVERT(VARCHAR(10), lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME) 
								order by start_date_time) <> 'DIRTY' THEN ISNULL((SELECT temp_2.updated_by
																				from
																				(
																					SELECT ROW_NUMBER() over (order by biv_2.ward_name_l, b_2.bed_code, bcs_2.start_date_time) as row_no,
																						   pfn_2.display_name_l as updated_by,
																						   biv_2.ward_name_l,
																						   b_2.bed_code,
																						   bcs_2.lu_updated
																					from bed_cleaning_status bcs_2 inner join bed b_2 on bcs_2.bed_id = b_2.bed_id
																												   inner join user_account ua_2 on bcs_2.lu_user_id = ua_2.user_id
																												   inner join person_formatted_name_iview_nl_view pfn_2 on ua_2.person_id = pfn_2.person_id
																												   inner join bed_info_view biv_2 on b_2.bed_id = biv_2.bed_id
																					where CAST(CONVERT(VARCHAR(10),bcs_2.lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME)
																				) as temp_2
																				where temp_2.row_no = temp.row_no - 1
																					 and temp_2.bed_code = temp.bed_code),'') else temp.updated_by end,
	    department = case when (SELECT top 1 bed_cleaning_status_rcd
								from bed_cleaning_status
								where bed_id = temp.bed_id
									 and CAST(CONVERT(VARCHAR(10), lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME) 
								order by start_date_time) <> 'DIRTY' THEN ISNULL((SELECT temp_2.department
																				from
																				(
																					SELECT ROW_NUMBER() over (order by biv_2.ward_name_l, b_2.bed_code, bcs_2.start_date_time) as row_no,
																						   pfn_2.display_name_l as updated_by,
																						   biv_2.ward_name_l,
																						   b_2.bed_code,
																						   bcs_2.lu_updated,
																						   eei.department_name_l as department
																					from bed_cleaning_status bcs_2 inner join bed b_2 on bcs_2.bed_id = b_2.bed_id
																												   inner join user_account ua_2 on bcs_2.lu_user_id = ua_2.user_id
																												   inner join person_formatted_name_iview_nl_view pfn_2 on ua_2.person_id = pfn_2.person_id
																												   inner join bed_info_view biv_2 on b_2.bed_id = biv_2.bed_id
																												    inner JOIN employee_employment_info_view eei on ua_2.person_id = eei.person_id
																					where CAST(CONVERT(VARCHAR(10),bcs_2.lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME)
																				) as temp_2
																				where temp_2.row_no = temp.row_no - 1
																					 and temp_2.bed_code = temp.bed_code),'') else temp.updated_by end,
	  CAST(ISNULL((SELECT temp_2.age_day
						from
						(
							SELECT ROW_NUMBER() over (order by biv_2.ward_name_l, b_2.bed_code, bcs_2.start_date_time) as row_no,
								   case when bcs_2.end_date_time is not NULL then DATEDIFF(hh,bcs_2.start_date_time,bcs_2.end_date_time) / 24 else 0 end as age_day,
								   b_2.bed_code
							from bed_cleaning_status bcs_2 inner join bed b_2 on bcs_2.bed_id = b_2.bed_id
													inner join user_account ua_2 on bcs_2.lu_user_id = ua_2.user_id
													inner join person_formatted_name_iview_nl_view pfn_2 on ua_2.person_id = pfn_2.person_id
													inner join bed_info_view biv_2 on b_2.bed_id = biv_2.bed_id
							where CAST(CONVERT(VARCHAR(10),bcs_2.lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME)
						) as temp_2
						where temp_2.row_no = temp.row_no - 1
							 and temp_2.bed_code = temp.bed_code),0) as VARCHAR) + ':' +
	  CAST(ISNULL((SELECT temp_2.age_hrs
						from
						(
							SELECT ROW_NUMBER() over (order by biv_2.ward_name_l, b_2.bed_code, bcs_2.start_date_time) as row_no,
								   --case when bcs_2.end_date_time is not NULL then DATEDIFF(mi,bcs_2.start_date_time,bcs_2.end_date_time) / 60 % 60 else 0 end as age_hrs,
								   case when bcs_2.end_date_time is not NULL then DATEDIFF(MINUTE,bcs_2.start_date_time,bcs_2.end_date_time) / 60 % 24 else 0 end as age_hrs,
									
									   b_2.bed_code
							from bed_cleaning_status bcs_2 inner join bed b_2 on bcs_2.bed_id = b_2.bed_id
													inner join user_account ua_2 on bcs_2.lu_user_id = ua_2.user_id
													inner join person_formatted_name_iview_nl_view pfn_2 on ua_2.person_id = pfn_2.person_id
													inner join bed_info_view biv_2 on b_2.bed_id = biv_2.bed_id
							where CAST(CONVERT(VARCHAR(10),bcs_2.lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME)
						) as temp_2
						where temp_2.row_no = temp.row_no - 1
							 and temp_2.bed_code = temp.bed_code),0) as VARCHAR) + ':' +
	  CAST(ISNULL((SELECT temp_2.age_min
						from
						(
							SELECT ROW_NUMBER() over (order by biv_2.ward_name_l, b_2.bed_code, bcs_2.start_date_time) as row_no,
								   case when bcs_2.end_date_time is not null then DATEDIFF(ss,bcs_2.start_date_time,bcs_2.end_date_time) / 60 % 60 else 0 end as age_min,
								   b_2.bed_code
							from bed_cleaning_status bcs_2 inner join bed b_2 on bcs_2.bed_id = b_2.bed_id
													inner join user_account ua_2 on bcs_2.lu_user_id = ua_2.user_id
													inner join person_formatted_name_iview_nl_view pfn_2 on ua_2.person_id = pfn_2.person_id
													inner join bed_info_view biv_2 on b_2.bed_id = biv_2.bed_id
							where CAST(CONVERT(VARCHAR(10),bcs_2.lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME)
						) as temp_2
						where temp_2.row_no = temp.row_no - 1
							 and temp_2.bed_code = temp.bed_code),0) as VARCHAR) + ':' +
	  CAST(ISNULL((SELECT temp_2.age_sec
						from
						(
							SELECT ROW_NUMBER() over (order by biv_2.ward_name_l, b_2.bed_code, bcs_2.start_date_time) as row_no,
								   case when bcs_2.end_date_time is not null then DATEDIFF(ss,bcs_2.start_date_time,bcs_2.end_date_time) % 60 % 60 else 0 end as age_sec,
								   b_2.bed_code
							from bed_cleaning_status bcs_2 inner join bed b_2 on bcs_2.bed_id = b_2.bed_id
													inner join user_account ua_2 on bcs_2.lu_user_id = ua_2.user_id
													inner join person_formatted_name_iview_nl_view pfn_2 on ua_2.person_id = pfn_2.person_id
													inner join bed_info_view biv_2 on b_2.bed_id = biv_2.bed_id
							where CAST(CONVERT(VARCHAR(10),bcs_2.lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME)
						) as temp_2
						where temp_2.row_no = temp.row_no - 1
							 and temp_2.bed_code = temp.bed_code),0) as VARCHAR) as elapse_time_2,
		ISNULL((SELECT  CAST((CAST(temp_2.age_day as NUMERIC(12,2)) * CAST(24 as NUMERIC(12,2))) * CAST(60 as NUMERIC(12,2)) as NUMERIC(12,2)) + 
							   CAST(CAST(temp_2.age_hrs as NUMERIC(12,2)) * CAST(60 as NUMERIC(12,2)) as NUMERIC(12,2)) +
							   CAST(temp_2.age_min as NUMERIC(12,2)) +
							   CAST(CAST(temp_2.age_sec as NUMERIC(12,2)) / CAST(60 as NUMERIC(12,2)) as NUMERIC(12,2)) 
						from
						(
							SELECT ROW_NUMBER() over (order by biv_2.ward_name_l, b_2.bed_code, bcs_2.start_date_time) as row_no,
								   case when bcs_2.end_date_time is not NULL then DATEDIFF(hh,bcs_2.start_date_time,bcs_2.end_date_time) / 24 else 0 end as age_day,
								   case when bcs_2.end_date_time is not NULL then DATEDIFF(mi,bcs_2.start_date_time,bcs_2.end_date_time) / 60 % 60 else 0 end as age_hrs,
								   case when bcs_2.end_date_time is not null then DATEDIFF(ss,bcs_2.start_date_time,bcs_2.end_date_time) / 60 % 60 else 0 end as age_min,
								   case when bcs_2.end_date_time is not null then DATEDIFF(ss,bcs_2.start_date_time,bcs_2.end_date_time) % 60 % 60 else 0 end as age_sec,
								   b_2.bed_code
							from bed_cleaning_status bcs_2 inner join bed b_2 on bcs_2.bed_id = b_2.bed_id
													inner join user_account ua_2 on bcs_2.lu_user_id = ua_2.user_id
													inner join person_formatted_name_iview_nl_view pfn_2 on ua_2.person_id = pfn_2.person_id
													inner join bed_info_view biv_2 on b_2.bed_id = biv_2.bed_id
							where CAST(CONVERT(VARCHAR(10),bcs_2.lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME)
						) as temp_2
						where temp_2.row_no = temp.row_no - 1
							 and temp_2.bed_code = temp.bed_code),0)as all_mins,
		temp.bed_id,
		@dReferenceDate -1 as reference_date,
		temp.row_no,
		(SELECT temp_2.start_date_time
						from
						(
							SELECT ROW_NUMBER() over (order by biv_2.ward_name_l, b_2.bed_code, bcs_2.start_date_time) as row_no,
								  start_date_time,
								   b_2.bed_code
							from bed_cleaning_status bcs_2 inner join bed b_2 on bcs_2.bed_id = b_2.bed_id
													inner join user_account ua_2 on bcs_2.lu_user_id = ua_2.user_id
													inner join person_formatted_name_iview_nl_view pfn_2 on ua_2.person_id = pfn_2.person_id
													inner join bed_info_view biv_2 on b_2.bed_id = biv_2.bed_id
							where CAST(CONVERT(VARCHAR(10),bcs_2.lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),temp.lu_updated,101) as SMALLDATETIME)
						) as temp_2
						where temp_2.row_no = temp.row_no - 1
							 and temp_2.bed_code = temp.bed_code) as start_date_time_2
from
(
	SELECT row_no = ROW_NUMBER() over (order by biv.ward_name_l, b.bed_code, bcs.start_date_time),
	 bcs.bed_cleaning_status_rcd,
	   bcs.start_date_time,
	   end_date_time = ISNULL(bcs.end_date_time,''),
	   ward_name = biv.ward_name_l,
	   b.bed_code,
	   bed_status_name = bcsr.name_l,
	   bcs.lu_user_id,
	   pfn.display_name_l as updated_by,
	   bcs.lu_updated,
	   case when bcs.end_date_time is not NULL then DATEDIFF(hh,bcs.start_date_time,bcs.end_date_time) / 24 else 0 end as age_day,
	   case when bcs.end_date_time is not NULL then DATEDIFF(hh,bcs.start_date_time,bcs.end_date_time) % 24 else 0 end as age_hrs,
	   case when bcs.end_date_time is not null then DATEDIFF(ss,bcs.start_date_time,bcs.end_date_time) / 60 % 60 else 0 end as age_min,
	   case when bcs.end_date_time is not null then DATEDIFF(ss,bcs.start_date_time,bcs.end_date_time) % 60 % 60 else 0 end as age_sec,
	   b.bed_id
from bed_cleaning_status bcs inner join bed b on bcs.bed_id = b.bed_id
						   inner join user_account ua on bcs.lu_user_id = ua.user_id
						   inner join person_formatted_name_iview_nl_view pfn on ua.person_id = pfn.person_id 
						   inner join bed_cleaning_status_ref bcsr on bcs.bed_cleaning_status_rcd = bcsr.bed_cleaning_status_rcd
						   inner join bed_info_view biv on b.bed_id = biv.bed_id
						  
where CAST(CONVERT(VARCHAR(10),bcs.lu_updated,101) as SMALLDATETIME) = CAST(CONVERT(VARCHAR(10),@dReferenceDate -1,101) as SMALLDATETIME)
) as temp
where
 temp.ward_name LIKE '6%'
     or temp.ward_name LIKE '5%'  or temp.ward_name LIKE '7%'
	 or temp.ward_name LIKE '8A%'  or temp.ward_name LIKE '8B%'
	  or temp.ward_name LIKE '9A%'  or temp.ward_name LIKE '9B%'
	  or temp.ward_name LIKE '10A%'  or temp.ward_name LIKE '10B%'
	  or temp.ward_name LIKE '10C%'  or temp.ward_name LIKE '10D%' or temp.ward_name LIKE '11C%'
     --temp.bed_code = '1002'
order by temp.ward_name, temp.bed_code, temp.start_date_time