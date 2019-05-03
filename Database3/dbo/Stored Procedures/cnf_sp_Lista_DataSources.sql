CREATE  PROCEDURE [dbo].[cnf_sp_Lista_DataSources] (
@IdProyecto				varchar(20) out
) 

as


SELECT CD_DATASOURCE, CD_OWNER, a.DS_DESCRIPTION, a.CD_NAME, a.CD_CONTEXT,c.DS_CONFIG + ' ' as DS_CONFIG, c.DS_SQL
FROM TAP8_WFM_DATASOURCE		a
LEFT JOIN TAP8_WFM_CONTEXT		b ON b.CD_CONTEXT = a.CD_CONTEXT
LEFT JOIN TAP8_WFM_QUERY		c ON c.CD_QUERY	= a.CD_DATASOURCE
WHERE a.CD_PROYECTO like @IdProyecto
ORDER BY CD_OWNER 


/*
select * from TAP8_WFM_DATASOURCE
select * from TAP8_WFM_QUERY

exec cnf_sp_Lista_DataSources '_LPAConfig'


delete from TAP8_WFM_DATASOURCE_query where cd_DATASOURCE = 0
delete from TAP8_WFM_DATASOURCE where cd_DATASOURCE = 0
delete from TAP8_WFM_query where cd_QUERY = 0


*/



