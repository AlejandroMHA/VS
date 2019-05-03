CREATE  PROCEDURE [dbo].[cnf_sp_Insert_DataSource] (
@IdProyecto				varchar(10) out,
@CD_DATASOURCE			int out,
@CD_OWNER				varchar(50) out,
@DS_DESCRIPTION			varchar(200) out,
@CD_NAME				varchar(100) out,
@CD_CONTEXT				int out,
@DS_CONFIG				varchar(max) out,
@DS_SQL					varchar(max) out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int, @UltimoId int


SET @Mensaje = ''

IF @IdProyecto = '' BEGIN
	SET @Mensaje = @Mensaje + 'Debe seleccionar un proyecto para poder agregar el Data Source'
	RETURN
END

IF @CD_NAME = '' OR @CD_OWNER = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Nombre, y el Tipo de Fuente es obligatorio'
	RETURN
END


SELECT @UltimoId = UltimoId  + 1 FROM LPA_InspectorWEB_DB.dbo.TD_PROYECTOS WHERE IdProyecto = @IdProyecto


SELECT @Conta = COUNT(*) FROM TAP8_WFM_DATASOURCE WHERE CD_DATASOURCE = @UltimoId

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe un Data Source con el Identificador asignado por el sistema. Consulte al Administrador del Sistema. Id en conflicto: ' + CAST(@UltimoId as varchar)
	RETURN
END


BEGIN TRANSACTION

UPDATE LPA_InspectorWEB_DB.dbo.TD_PROYECTOS SET UltimoId = @UltimoId  WHERE IdProyecto = @IdProyecto

SET @CD_DATASOURCE = @UltimoId

COMMIT


INSERT INTO TAP8_WFM_DATASOURCE (
	CD_PROYECTO,
	CD_DATASOURCE,
	CD_OWNER,
	DS_DESCRIPTION,
	CD_NAME,
	CD_CONTEXT
)
VALUES(
	@IdProyecto,
	@CD_DATASOURCE,
	@CD_OWNER,
	@DS_DESCRIPTION,
	@CD_NAME,
	@CD_CONTEXT
)
	

INSERT INTO TAP8_WFM_QUERY (
	CD_PROYECTO,
	CD_QUERY,
	DS_DESCRIPTION,
	CD_NAME,
	DS_CONFIG,
	DS_SQL
)
VALUES(
	@IdProyecto,
	@CD_DATASOURCE,
	@DS_DESCRIPTION,
	@CD_NAME,
	RTRIM(@DS_CONFIG),
	RTRIM(@DS_SQL)
)

INSERT INTO TAP8_WFM_DATASOURCE_QUERY (
	CD_DATASOURCE, 
	CD_QUERY, 
	CD_PROYECTO
) 
VALUES (
	@CD_DATASOURCE,
	@CD_DATASOURCE,
	@IdProyecto
)



