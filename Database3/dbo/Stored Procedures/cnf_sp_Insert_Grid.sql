CREATE  PROCEDURE [dbo].[cnf_sp_Insert_Grid] (
@CD_NAME					varchar(64) out,			
@DS_TITLE					varchar(128) out,
@DS_DATASCRIPT				varchar(1024) out,
@DS_FIELDS					varchar(512) out,
@DS_COLUMNS					varchar(4024) out,
@DS_CONFIG					varchar(4024) out,
@IdProyecto 				varchar(10) out,
@Mensaje					varchar(500) out
)

as

DECLARE @Conta int, @UltimoId int


IF @CD_NAME = '' OR @DS_TITLE = '' OR @IdProyecto = '' BEGIN
	SET @Mensaje = 'El nombre del Grid, El título y el Proyecto son obligatorios.'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_GRIDS_GRID WHERE CD_NAME = @CD_NAME AND CD_PROYECTO = @IdProyecto

IF @Conta > 0 BEGIN
	SET @Mensaje = 'Ya existe otro Grid con el mismo Nonmbre dentro del Proyecto'
	RETURN
END


SELECT @UltimoId = UltimoId  + 1 FROM LPA_InspectorWEB_DB.dbo.TD_PROYECTOS WHERE IdProyecto = @IdProyecto


SELECT @Conta = COUNT(*) FROM TAP8_GRIDS_GRID WHERE CD_GRID = @UltimoId

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe un GRID con el Identificador asignado por el sistema. Consulte al Administrador. Id en conflicto: ' + CAST(@UltimoId as varchar)
	RETURN
END


BEGIN TRANSACTION

UPDATE LPA_InspectorWEB_DB.dbo.TD_PROYECTOS SET UltimoId = @UltimoId  WHERE IdProyecto = @IdProyecto

INSERT INTO TAP8_GRIDS_GRID (
	CD_GRID,
	CD_NAME,		
	DS_TITLE,
	DS_DATASCRIPT,
	DS_FIELDS,
	DS_COLUMNS,
	DS_CONFIG,
	CD_PROYECTO
	)
VALUES (
	@UltimoId,
	@CD_NAME,		
	@DS_TITLE,
	RTRIM(@DS_DATASCRIPT),
	RTRIM(@DS_FIELDS),
	RTRIM(@DS_COLUMNS),
	RTRIM(@DS_CONFIG),
	@IdProyecto
	)


COMMIT


/*
EXEC cnf_sp_Insert_Grid 'ListaBotonesHuerfanos', 'Lista de Botones Huerfanos', 'SP', '','', '', '_LPAConfig', ''


@CD_NAME					varchar(64) out,			
@DS_TITLE					varchar(128) out,
@DS_DATASCRIPT				varchar(1024) out,
@DS_FIELDS					varchar(512) out,
@DS_COLUMNS					varchar(4024) out,
@DS_CONFIG					varchar(4024) out,
@IdProyecto 				varchar(10) out,
@Mensaje					varchar(500) out

*/



