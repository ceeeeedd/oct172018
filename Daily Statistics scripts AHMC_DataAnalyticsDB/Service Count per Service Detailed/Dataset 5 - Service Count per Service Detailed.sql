--Dataset 5 - Service Count per Service Detailed
SELECT *
FROM HISReport.dbo.ref_item_type
WHERE item_type_rcd IN ('SRV','INV')