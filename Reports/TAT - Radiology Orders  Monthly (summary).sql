SELECT distinct a.hospital_nr, 
		a.patient_name, 
		a.visit_start, 
		a.visit_end, 
		a.visit_type, 
		a.service_category,
		a.[procedure], 
		a.[receiving to confirmation], 
		a.[confirmation to report creation], 
		a.month_rcd, 
        a.year_rcd,
		a.report_creation_by,
		f.charge_type_rcd,
		c.ipd_room_code as [Room Code],
		e.name_l as [Room Class],
		c.bed_code as [Bed],
		d.name_l as [Bed Type],
		case when a.visit_type  in ('Inpatient Visit', 'IPD Executive Check-up') then c.ipd_room_code else '' 
		end as room_code,
		case when a.visit_type  in ('Inpatient Visit', 'IPD Executive Check-up') then e.name_l else ''
		end as room_class,
		case when a.visit_type  in ('Inpatient Visit', 'IPD Executive Check-up') then c.bed_code else ''
		end as bed_code,
		case when a.visit_type  in ('Inpatient Visit', 'IPD Executive Check-up') then d.name_l else ''
		end as bed_type
FROM           HISReport.dbo.rpt_vw_tat_radiology_orders_totals a 
				left join AmalgaPROD.dbo.patient_hospital_usage_nl_view b on a.hospital_nr = b.visible_patient_id
				left join AmalgaPROD.dbo.bed_entry_info_view c on c.patient_id = b.patient_id
				left join AmalgaPROD.dbo.bed_type_ref_nl_view d on d.bed_type_rcd = c.bed_type_rcd
				left join AmalgaPROD.dbo.ipd_room_class_ref e on e.ipd_room_class_rcd = c.ipd_room_class_rcd
				left join AmalgaPROD.dbo.patient_visit f on f.patient_visit_id = c.patient_visit_id
where a.month_rcd = 9 and a.year_rcd = 2018
order by a.visit_start desc

SELECT distinct visit_type FROM HISReport.dbo.rpt_vw_tat_radiology_orders_totals

select * from AmalgaPROD.dbo.ipd_room_class_ref

select * from AmalgaPROD.dbo.bed_type_ref_nl_view

select * from AmalgaPROD.dbo.bed_entry_info_view

select * from AmalgaPROD.dbo.patient_hospital_usage_nl_view

select * from patient_visit

select convert(varchar(10),getdate(),101)

SELECT distinct a.hospital_nr, 
		a.patient_name, 
		a.visit_start, 
		a.visit_end, 
		a.visit_type, 
		a.service_category,
		a.[procedure], 
		a.[receiving to confirmation], 
		a.[confirmation to report creation], 
		a.month_rcd, 
        a.year_rcd,
		a.report_creation_by,
		c.ipd_room_code as [Room Code],
		e.name_l as [Room Class],
		c.bed_code as [Bed],
		d.name_l as [Bed Type]
FROM           HISReport.dbo.rpt_vw_tat_radiology_orders_totals a 
				left join AmalgaPROD.dbo.patient_hospital_usage_nl_view b on a.hospital_nr = b.visible_patient_id
				left join AmalgaPROD.dbo.bed_entry_info_view c on c.patient_id = b.patient_id
				left join AmalgaPROD.dbo.bed_type_ref_nl_view d on d.bed_type_rcd = c.bed_type_rcd
				left join AmalgaPROD.dbo.ipd_room_class_ref e on e.ipd_room_class_rcd = c.ipd_room_class_rcd
where a.month_rcd = @month and a.year_rcd = @year
order by a.visit_start desc