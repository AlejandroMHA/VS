CREATE  PROCEDURE [dbo].[cnf_sp_Insert_Field] (
@IdProyecto				varchar(20) out,
@DS_NAME				varchar(64) out,
@DS_LABEL				varchar(64) out,
@DS_TYPE				varchar(16) out,
@DS_DEPENDFIELDNAMES	varchar(128) out,
@DS_SCRIPT				varchar(1024) out,
@DS_CONFIG				varchar(1024) out,
@Mensaje				varchar(500) out
)

as

DECLARE  @Conta int, @UltimoId int


SET @Mensaje = ''

IF @DS_NAME = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Nombre es obligatorio'
	RETURN
END


SELECT @UltimoId = UltimoId  + 1 FROM LPA_InspectorWEB_DB.dbo.TD_PROYECTOS WHERE IdProyecto = @IdProyecto


SELECT @Conta = COUNT(*) FROM TAP8_DSGR_FIELD WHERE CD_FIELD = @UltimoId

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe un Field con el Identificador asignado por el sistema. Consulte al Administrador. Id en conflicto: ' + CAST(@UltimoId as varchar)
	RETURN
END


BEGIN TRANSACTION

UPDATE LPA_InspectorWEB_DB.dbo.TD_PROYECTOS SET UltimoId = @UltimoId  WHERE IdProyecto = @IdProyecto

INSERT INTO TAP8_DSGR_FIELD 
	(CD_FIELD,
	DS_NAME,				
	DS_LABEL,				
	DS_TYPE,				
	DS_DEPENDFIELDNAMES,	
	DS_SCRIPT,				
	DS_CONFIG,		
	CD_PROYECTO)	
VALUES
	(@UltimoId,
	@DS_NAME,				
	@DS_LABEL,				
	@DS_TYPE,				
	@DS_DEPENDFIELDNAMES,	
	RTRIM(@DS_SCRIPT),				
	RTRIM(@DS_CONFIG),		
	@IdProyecto)	
	
COMMIT



