CREATE  PROCEDURE [dbo].[cnf_sp_Insert_Button] (
@IdProyecto				varchar(10) out,
@CD_BUTTON				int out,
@CD_NAME				varchar(50) out,
@DS_LABEL				varchar(50) out,
@DS_ICON_CLS			varchar(50) out,
@DS_TOOLTIP				varchar(200) out,
@DS_CONFIG				varchar(3000) out,
@DS_SCRIPT				varchar(8000) out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int, @UltimoId int


SET @Mensaje = ''

IF @CD_NAME = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Nombre es obligatorio'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_WFM_BUTTON WHERE CD_NAME = @CD_NAME 

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe otro Boton con el mismo Nombre. El Nombre debe ser único'
	RETURN
END

SELECT @UltimoId = UltimoId  + 1 FROM LPA_InspectorWEB_DB.dbo.TD_PROYECTOS WHERE IdProyecto = @IdProyecto


SELECT @Conta = COUNT(*) FROM TAP8_WFM_BUTTON WHERE CD_BUTTON = @CD_BUTTON

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe un Boton con el Identificador asignado por el sistema. Consulte al Administrador del Sistema. Id en conflicto: ' + CAST(@UltimoId as varchar)
	RETURN
END


BEGIN TRANSACTION

UPDATE LPA_InspectorWEB_DB.dbo.TD_PROYECTOS SET UltimoId = @UltimoId  WHERE IdProyecto = @IdProyecto

INSERT INTO TAP8_WFM_BUTTON (
	CD_PROYECTO,
	CD_BUTTON,
	CD_NAME,
	DS_LABEL,
	DS_ICON_CLS,
	DS_TOOLTIP,
	DS_CONFIG,
	DS_SCRIPT)
VALUES(
	@IdProyecto,
	@UltimoId,
	@CD_NAME,
	@DS_LABEL,
	@DS_ICON_CLS,
	@DS_TOOLTIP,
	RTRIM(@DS_CONFIG),
	RTRIM(@DS_SCRIPT))
	
COMMIT



