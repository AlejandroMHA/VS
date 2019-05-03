CREATE  PROCEDURE [dbo].[cnf_sp_Update_Contexto] (
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
	SET @Mensaje = @Mensaje + 'Debe seleccionar un proyecto para poder Modificar el Contexto'
	RETURN
END

IF @CD_CONTEXT = 0 BEGIN
	SET @Mensaje = @Mensaje + 'DEBE SELECCIONAR EL CONTEXTO A MODIFICAR'
	RETURN
END

IF @CD_CONTEXT_CODE = ''  OR @DS_DESCRIPTION = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Codigo de Contexto y el Título son Obligatorios'
	RETURN
END


SELECT @Conta = COUNT(*) FROM TAP8_WFM_CONTEXT WHERE CD_CONTEXT = @CD_CONTEXT

IF @Conta = 0 BEGIN
	SET @Mensaje = @Mensaje + 'NO Existe el Contexto a Actualizar'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_WFM_CONTEXT WHERE CD_CONTEXT_CODE = @CD_CONTEXT_CODE AND CD_CONTEXT <> @CD_CONTEXT


IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya Existe un Contexto con el mismo Código de Contexto.'
	RETURN
END


UPDATE TAP8_WFM_CONTEXT SET
	CD_PROYECTO			= @IdProyecto,
	CD_CONTEXT_CODE		= @CD_CONTEXT_CODE,
	DS_DESCRIPTION		= @DS_DESCRIPTION,
	DS_CONFIG			= RTRIM(@DS_CONFIG)
WHERE
	CD_CONTEXT = @CD_CONTEXT



