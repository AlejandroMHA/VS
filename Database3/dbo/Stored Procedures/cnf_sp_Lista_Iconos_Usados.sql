CREATE  PROCEDURE [dbo].[cnf_sp_Lista_Iconos_Usados] (
@query				varchar(10) out
)

as

SET @query = '%' + @query + '%'

SELECT DISTINCT(DS_ICON_CLS) as Icono FROM TAP8_WFM_BUTTON WHERE DS_ICON_CLS LIKE @query



