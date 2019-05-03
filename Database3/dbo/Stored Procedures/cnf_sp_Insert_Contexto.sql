CREATE  PROCEDURE [dbo].[cnf_sp_Insert_Contexto] (
@IdProyecto				varchar(10) out,
@CD_CONTEXT				int out,
@CD_CONTEXT_CODE		varchar(50) out,
@DS_DESCRIPTION			varchar(200) out,
@DS_CONFIG				varchar(max) out,
@Mensaje				varchar(500) out
) 

as


DECLARE  @Conta int, @UltimoId int

SET @Mensaje = ''

IF @IdProyecto = '' BEGIN
	SET @Mensaje = @Mensaje + 'Debe seleccionar un proyecto para poder agregar EL Contexto'
	RETURN
END


IF @CD_CONTEXT_CODE = ''  OR @DS_DESCRIPTION = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Codigo de Contexto y el Título son Obligatorios'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_WFM_CONTEXT WHERE CD_CONTEXT_CODE = @CD_CONTEXT_CODE


IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya Existe un Contexto con el mismo Código de Contexto.'
	RETURN
END


SELECT @UltimoId = UltimoId  + 1 FROM LPA_InspectorWEB_DB.dbo.TD_PROYECTOS WHERE IdProyecto = @IdProyecto


SELECT @Conta = COUNT(*) FROM TAP8_WFM_CONTEXT WHERE CD_CONTEXT = @UltimoId

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe un Contexto con el Identificador asignado por el sistema. Consulte al Administrador del Sistema. Id en conflicto: ' + CAST(@UltimoId as varchar)
	RETURN
END


BEGIN TRANSACTION

UPDATE LPA_InspectorWEB_DB.dbo.TD_PROYECTOS SET UltimoId = @UltimoId  WHERE IdProyecto = @IdProyecto

SET @CD_CONTEXT = @UltimoId

COMMIT


INSERT INTO TAP8_WFM_CONTEXT (
	CD_PROYECTO,
	CD_CONTEXT,
	CD_CONTEXT_CODE,
	DS_DESCRIPTION,
	DS_CONFIG
)
VALUES(
	@IdProyecto,
	@CD_CONTEXT,
	@CD_CONTEXT_CODE,
	@DS_DESCRIPTION,
	RTRIM(@DS_CONFIG)
)



