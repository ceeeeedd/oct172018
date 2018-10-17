--run in ITWORKSDEV01 MASTER ITWORKSDS01 DIS

SELECT *
FROM itworksds01.dis.dbo.df_browse_validated
where --validated = 'yes'
			--and costcentre_group = 'radiology'
			--and CAST(CONVERT(VARCHAR(10), charge_date,101) as SMALLDATETIME) =  CAST(CONVERT(VARCHAR(10),dateadd(day,-1, getdate()),101) as SMALLDATETIME)
			--and 
			year(charge_date) = 2018 and
			month(charge_date) = 8 and
			day(charge_date) = 1
order by charge_date

SELECT *
FROM itworksds01.dis.dbo.df_browse_validated
where validated = 'yes'
			--and costcentre_group = 'radiology'
			and CAST(CONVERT(VARCHAR(10), charge_date,101) as SMALLDATETIME) =  CAST(CONVERT(VARCHAR(10),dateadd(day,-2, '06/03/2018'),101) as SMALLDATETIME)
			--and CAST(CONVERT(VARCHAR(10), charge_date,101) as SMALLDATETIME) =  CAST(CONVERT(VARCHAR(10),'10/03/2018',101) as SMALLDATETIME)
			order by charge_date


--AHMC_DataAnalyticsDB

select * from dis.df_browse_validated__updates_temp
order by charge_date desc

select distinct * from dis.df_browse_validated_temp
where 
CAST(CONVERT(VARCHAR(10), charge_date,101) as SMALLDATETIME) =  CAST(CONVERT(VARCHAR(10),'10/08/2018',101) as SMALLDATETIME)
order by charge_date desc

select * from dis.df_browse_validated
where
CAST(CONVERT(VARCHAR(10), validated_datetime,101) as SMALLDATETIME) =  CAST(CONVERT(VARCHAR(10),'10/16/2018',101) as SMALLDATETIME)
order by validated_datetime desc

select * from dis.df_browse_validated
order by charge_date desc

select * from dis.df_browse_validated_updates
order by charge_date desc


select * from daily_statistics_test




UPDATE dbv
  
SET     dbv.[Change in Status Remarks] = 'Validated ' + CONVERT(VARCHAR(20),dbv.validated_datetime,101) + ' ' + FORMAT
(dbv.validated_datetime,'hh:mm tt') + ' as YES'
		,dbv.validated_datetime = dbvu.validated_datetime
       
 ,dbv.validated = dbvu.validated
FROM DBPROD03.AHMC_DataAnalyticsDB.dis.df_browse_validated dbv
JOIN DBPROD03.AHMC_DataAnalyticsDB.dis.df_browse_validated_updates dbvu
ON dbvu.charge_id = dbv.charge_id
WHERE dbvu.validated <> dbv.validated