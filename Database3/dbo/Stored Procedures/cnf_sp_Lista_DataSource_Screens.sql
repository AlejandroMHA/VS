CREATE  PROCEDURE [dbo].[cnf_sp_Lista_DataSource_Screens] (
@IdProyecto			varchar(20) out,
@BuscarEn			int out,
@query				varchar(30) out
)

as


SET @query = '%' + @query + '%'


--  Buscar en DataSource

IF @BuscarEn = 1 BEGIN
	SELECT CD_DATASOURCE as IdFuente, DS_DESCRIPTION as Descripcion
	FROM TAP8_WFM_DATASOURCE 
	WHERE DS_DESCRIPTION like @query AND CD_PROYECTO like @IdProyecto
	ORDER BY Descripcion
END

--  Buscar en Screens

IF @BuscarEn = 2 BEGIN
	SELECT CD_SCREEN as IdFuente, ISNULL(DS_DESCRIPCION, CD_NAME)  as Descripcion 
	FROM TAP8_DSGR_SCREEN 
	WHERE (DS_DESCRIPCION like @query OR CD_NAME like @query) AND CD_PROYECTO like @IdProyecto
	ORDER BY Descripcion
END

-- EXEC cnf_sp_Lista_DataSource_Screens '_LPAConfig', '2', ''



