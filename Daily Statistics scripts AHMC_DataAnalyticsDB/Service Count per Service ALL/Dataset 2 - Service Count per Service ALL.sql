--Dataset 2 - Service Count per Service ALL
with yearlist as
(
select 2005 as year
union all
select yl.year + 1 as year
from yearlist yl
where yl.year + 1 <= YEAR(GetDate())
)

select year
from yearlist
order by year desc;