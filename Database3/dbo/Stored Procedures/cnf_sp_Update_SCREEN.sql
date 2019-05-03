CREATE  PROCEDURE [dbo].[cnf_sp_Update_SCREEN] (
@IdProyecto				varchar(20) out,
@CD_SCREEN				int out,
@CD_NAME				varchar(64) out,
@CD_INITBUTTON			int out,
@DS_CONFIG				varchar(1024) out,
@DS_DESCRIPCION			varchar(1024) out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int

SET @Mensaje = ''

IF @CD_SCREEN = 0 OR @CD_NAME = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Id y el Nombre son obligatorios'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_DSGR_SCREEN WHERE CD_SCREEN = @CD_SCREEN

IF @Conta = 0 BEGIN
	SET @Mensaje = @Mensaje + 'No existe un Screen con el Id indicado'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_DSGR_SCREEN WHERE CD_NAME = @CD_NAME AND CD_SCREEN <> @CD_SCREEN

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe otro Screen con el mismo Nombre. El Nombre debe ser único'
	RETURN
END

UPDATE TAP8_DSGR_SCREEN SET
CD_PROYECTO				= @IdProyecto,				
CD_NAME 				= @CD_NAME,				
CD_INITBUTTON			= CASE WHEN @CD_INITBUTTON = 0 THEN null ELSE @CD_INITBUTTON END,			
DS_CONFIG				= @DS_CONFIG,				
DS_DESCRIPCION			= @DS_DESCRIPCION			
WHERE CD_SCREEN = @CD_SCREEN



