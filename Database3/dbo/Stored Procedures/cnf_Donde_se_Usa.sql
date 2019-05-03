CREATE  PROCEDURE [dbo].[cnf_Donde_se_Usa] (
@IdProyecto				varchar(10) out,
@aBuscar				varchar(50) out,
@Mensaje				varchar(500) out
)

as

SET NOCOUNT ON

DECLARE @TMP_DONDE TABLE (
	TipoObjeto		varchar(20),
	Descripcion		varchar(200),
	NombreObjeto	varchar(100),
	Donde			varchar(50),
	Contenido		varchar(max)
)

DECLARE @Conta int

IF @aBuscar = ''
	RETURN


SET @aBuscar = '%' + @aBuscar + '%'
SET @Mensaje = ''


--****************************************************************************************************************************
-- Busqueda en Fields
--****************************************************************************************************************************

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'FIELD',
	DS_LABEL,
	DS_NAME,
	'SCRIPT',
	DS_SCRIPT
FROM TAP8_DSGR_FIELD
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_SCRIPT LIKE @aBuscar

--****************************************************************************************************************************
-- BUSQUEDA EN GRIDS
--****************************************************************************************************************************

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'GRID',
	DS_TITLE,
	CD_NAME,
	'SCRIPT',
	DS_DATASCRIPT
FROM TAP8_GRIDS_GRID
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_DATASCRIPT LIKE @aBuscar

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'GRID',
	DS_TITLE,
	CD_NAME,
	'CAMPOS RECIBIDOS',
	DS_FIELDS + ' '
FROM TAP8_GRIDS_GRID
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_FIELDS LIKE @aBuscar

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'GRID',
	DS_TITLE,
	CD_NAME,
	'CAMPOS a MOSTRAR',
	DS_COLUMNS + ' '
FROM TAP8_GRIDS_GRID
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_COLUMNS LIKE @aBuscar


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'GRID',
	DS_TITLE,
	CD_NAME,
	'CONFIGURACION',
	DS_CONFIG + ' '
FROM TAP8_GRIDS_GRID
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_CONFIG LIKE @aBuscar

--****************************************************************************************************************************
-- Navegadores
--****************************************************************************************************************************

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'NAVIGATOR',
	'',
	CDNAME,
	'CONFIGURACION GENERAL',
	DSCONFIG + ' '
FROM TAP8_NAV_NAVIGATOR
WHERE CD_PROYECTO LIKE @IdProyecto AND DSCONFIG LIKE @aBuscar


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'NAVIGATOR',
	'',
	CDNAME,
	'CONFIGURACION DE NODO',
	DSNODECONFIG + ' '
FROM TAP8_NAV_NAVIGATOR
WHERE CD_PROYECTO LIKE @IdProyecto AND DSNODECONFIG LIKE @aBuscar

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'NAVIGATOR',
	'',
	CDNAME,
	'CONFIGURACION DE METADATOS',
	DSCOLMODSCRIPT + ' '
FROM TAP8_NAV_NAVIGATOR
WHERE CD_PROYECTO LIKE @IdProyecto AND DSCOLMODSCRIPT LIKE @aBuscar

--****************************************************************************************************************************
--- Query de Navegadores
--****************************************************************************************************************************

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'QUERY de NAVIGATOR',
	CDNAVYNAME,
	CDNAME,
	'OBJECT SOTRE',
	DSOBJSTORES + ' '
FROM TAP8_NAV_QUERY
WHERE CD_PROYECTO LIKE @IdProyecto AND DSOBJSTORES LIKE @aBuscar

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'QUERY de NAVIGATOR',
	CDNAVYNAME,
	CDNAME,
	'SQL a DOCUMENTOS',
	DSCESQL + ' '
FROM TAP8_NAV_QUERY
WHERE CD_PROYECTO LIKE @IdProyecto AND DSCESQL LIKE @aBuscar


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'QUERY de NAVIGATOR',
	CDNAVYNAME,
	CDNAME,
	'PATHS',
	DSPATHS + ' '
FROM TAP8_NAV_QUERY
WHERE CD_PROYECTO LIKE @IdProyecto AND DSPATHS LIKE @aBuscar


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'QUERY de NAVIGATOR',
	CDNAVYNAME,
	CDNAME,
	'ORGANIZACION DE DOCUMENTOS',
	DSCONFIG + ' '
FROM TAP8_NAV_QUERY
WHERE CD_PROYECTO LIKE @IdProyecto AND DSCONFIG LIKE @aBuscar


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'QUERY de NAVIGATOR',
	CDNAVYNAME,
	CDNAME,
	'SCRIP',
	DSSCRIPT + ' '
FROM TAP8_NAV_QUERY
WHERE CD_PROYECTO LIKE @IdProyecto AND DSSCRIPT LIKE @aBuscar


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'QUERY de NAVIGATOR',
	CDNAVYNAME,
	CDNAME,
	'CONFIGURACION DE METADATOS',
	DSCOLMODSCRIPT + ' '
FROM TAP8_NAV_QUERY
WHERE CD_PROYECTO LIKE @IdProyecto AND DSCOLMODSCRIPT LIKE @aBuscar


--****************************************************************************************************************************
-- BOTONES
--************************************************************************************************************************

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'BOTON',
	DS_LABEL,
	CD_NAME,
	'SCRIPT',
	DS_SCRIPT + ' '
FROM TAP8_WFM_BUTTON
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_SCRIPT LIKE @aBuscar


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'BOTON',
	DS_LABEL,
	CD_NAME,
	'CONFIGURACION',
	DS_CONFIG + ' '
FROM TAP8_WFM_BUTTON
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_CONFIG LIKE @aBuscar


--****************************************************************************************************************************
-- COLUMNAS
--****************************************************************************************************************************

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'COLUMNA',
	DS_DESCRIPTION,
	CD_NAME,
	'CONFIGURACION',
	DS_CONFIG + ' '
FROM TAP8_WFM_COLUMN
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_CONFIG LIKE @aBuscar



--****************************************************************************************************************************
-- CONTEXTOS
--****************************************************************************************************************************

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'CONTEXTO',
	DS_DESCRIPTION,
	CD_CONTEXT_CODE,
	'CONFIGURACION',
	DS_CONFIG + ' '
FROM TAP8_WFM_CONTEXT
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_CONFIG LIKE @aBuscar




--****************************************************************************************************************************
-- DATA SOURCES
--****************************************************************************************************************************

INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'DATA SOURCE',
	DS_DESCRIPTION,
	CD_NAME,
	'CONFIGURACION',
	DS_CONFIG + ' '
FROM TAP8_WFM_DATASOURCE
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_CONFIG LIKE @aBuscar


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'DATA SOURCE',
	DS_DESCRIPTION,
	CD_NAME,
	'NOMBRE DE LA FUENTE',
	CD_NAME + ' '
FROM TAP8_WFM_DATASOURCE
WHERE CD_PROYECTO LIKE @IdProyecto AND CD_NAME LIKE @aBuscar


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'DATA SOURCE',
	DS_DESCRIPTION,
	CD_NAME,
	'CONFIGURACION - QUERY',
	DS_CONFIG + ' '
FROM TAP8_WFM_QUERY
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_CONFIG LIKE @aBuscar


--****************************************************************************************************************************
-- SCREENS
--****************************************************************************************************************************


INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'SCREEN',
	DS_DESCRIPCION,
	CD_NAME,
	'JSON',
	'** PARA MODIFICAR O VER DONDE SE USA EL COMPONENTE, DEBE UTILIZAR EL DESIGNER ** '
FROM TAP8_DSGR_SCREEN
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_JSON LIKE @aBuscar



INSERT INTO @TMP_DONDE (
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
)
SELECT
	'SCREEN',
	DS_DESCRIPCION,
	CD_NAME,
	'CONFIGURACION',
	DS_CONFIG + ' '
FROM TAP8_DSGR_SCREEN
WHERE CD_PROYECTO LIKE @IdProyecto AND DS_CONFIG LIKE @aBuscar





--****************************************************************************************************************************
-- FIN DE BUSQUEDAS EN COMPONENTES
--****************************************************************************************************************************


SELECT @Conta = COUNT(*) FROM @TMP_DONDE

IF @Conta = 0 BEGIN
	SET @Mensaje = 'NO SE ENCONTRARON RESULTADOS PARA LA BUSQUEDA'
	RETURN
END


SELECT 	
	TipoObjeto,
	Descripcion,
	NombreObjeto,
	Donde,
	Contenido
FROM @TMP_DONDE


/*
DECLARE @Mensaje varchar(500)

EXEC cnf_Donde_se_Usa '_LPAConfig', 'idProyecto', @Mensaje out

select @Mensaje


*/



