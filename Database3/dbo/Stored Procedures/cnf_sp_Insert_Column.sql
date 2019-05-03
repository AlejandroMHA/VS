CREATE  PROCEDURE [dbo].[cnf_sp_Insert_Column] (
@IdProyecto				varchar(10) out,
@CD_DATASOURCE			int out,
@CD_COLUMN				int out,
@CD_NAME				varchar(100) out,
@CD_DATA_TYPE			varchar(20) out,
@DS_DESCRIPTION			varchar(200) out,
@DS_CONFIG				varchar(max) out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int, @UltimoId int

SET @Mensaje = ''

IF @IdProyecto = '' BEGIN
	SET @Mensaje = @Mensaje + 'Debe seleccionar un proyecto para poder agregar la columna'
	RETURN
END

IF @CD_DATASOURCE = 0 OR @CD_DATASOURCE = '' BEGIN
	SET @Mensaje = @Mensaje + 'Debe Tener seleccionada una Fuente de Datos'
	RETURN
END

IF @CD_NAME = '' OR @DS_DESCRIPTION = '' OR @CD_DATA_TYPE = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Nombre, La Descripción y El Tipo de Dato son obligatorio'
	RETURN
END


SELECT @UltimoId = UltimoId  + 1 FROM LPA_InspectorWEB_DB.dbo.TD_PROYECTOS WHERE IdProyecto = @IdProyecto


SELECT @Conta = COUNT(*) FROM TAP8_WFM_COLUMN WHERE CD_COLUMN = @UltimoId

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe una Columna con el Identificador asignado por el sistema. Consulte al Administrador del Sistema. Id en conflicto: ' + CAST(@UltimoId as varchar)
	RETURN
END


BEGIN TRANSACTION

UPDATE LPA_InspectorWEB_DB.dbo.TD_PROYECTOS SET UltimoId = @UltimoId  WHERE IdProyecto = @IdProyecto

SET @CD_COLUMN = @UltimoId

COMMIT


INSERT INTO TAP8_WFM_COLUMN (
	CD_PROYECTO,
	CD_COLUMN,
	CD_NAME,
	CD_DATA_TYPE,
	DS_DESCRIPTION,
	DS_CONFIG
)
VALUES(
	@IdProyecto,
	@CD_COLUMN,
	@CD_NAME,
	@CD_DATA_TYPE,
	@DS_DESCRIPTION,
	RTRIM(@DS_CONFIG)
)
	
INSERT INTO TAP8_WFM_QUERY_COLUMNS (
	CD_QUERY,
	CD_COLUMN,
	CD_PROYECTO
	)
VALUES (
	@CD_DATASOURCE,
	@CD_COLUMN,
	@IdProyecto
	)



