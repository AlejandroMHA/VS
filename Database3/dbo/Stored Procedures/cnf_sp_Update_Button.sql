CREATE  PROCEDURE [dbo].[cnf_sp_Update_Button] (
@CD_BUTTON				int out,
@CD_NAME				varchar(50) out,
@DS_LABEL				varchar(50) out,
@DS_ICON_CLS			varchar(50) out,
@DS_TOOLTIP				varchar(200) out,
@DS_CONFIG				varchar(3000) out,
@DS_SCRIPT				varchar(max) out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int

SET @Mensaje = ''

IF @CD_BUTTON = 0 OR @CD_NAME = '' OR @DS_SCRIPT = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Id del Boton, el Nombre y el Scripot son obligatorios'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_WFM_BUTTON WHERE CD_BUTTON = @CD_BUTTON

IF @Conta = 0 BEGIN
	SET @Mensaje = @Mensaje + 'No existe un Botón con el Id indicado'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_WFM_BUTTON WHERE CD_NAME = @CD_NAME AND CD_BUTTON <> @CD_BUTTON

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe otro Boton con el mismo Nombre. El Nombre debe ser único'
	RETURN
END

UPDATE TAP8_WFM_BUTTON SET
	CD_BUTTON		= @CD_BUTTON,
	CD_NAME			= @CD_NAME,
	DS_LABEL		= @DS_LABEL,
	DS_ICON_CLS		= @DS_ICON_CLS,
	DS_TOOLTIP		= @DS_TOOLTIP,
	DS_CONFIG		= RTRIM(@DS_CONFIG),
	DS_SCRIPT		= RTRIM(@DS_SCRIPT)
WHERE
	CD_BUTTON = @CD_BUTTON



