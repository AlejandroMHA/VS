
CREATE PROCEDURE [dbo].[cnf_sp_Insert_Navy] (
@IdProyecto				varchar(20) out,
@CDNAVIGATOR			int out, 
@CDNAME					varchar(128) out, 
@DSCONFIG				varchar(max) out, 
@DSNODECONFIG			varchar(max) out, 
@DSCOLMODSCRIPT			varchar(max) out,
@Mensaje				varchar(max) out 
)

as

DECLARE @Conta int, @UltimoId int


IF @CDNAME = '' OR @IdProyecto = '' BEGIN
	SET @Mensaje = 'El nombre del Navegador y el Proyecto son obligatorios.'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_NAV_NAVIGATOR WHERE CDNAME = @CDNAME AND CD_PROYECTO = @IdProyecto

IF @Conta > 0 BEGIN
	SET @Mensaje = 'Ya existe otro Navegador con el mismo Nonmbre dentro del Proyecto'
	RETURN
END


SELECT @UltimoId = UltimoId  + 1 FROM LPA_InspectorWEB_DB.dbo.TD_PROYECTOS WHERE IdProyecto = @IdProyecto


SELECT @Conta = COUNT(*) FROM TAP8_NAV_NAVIGATOR WHERE CDNAVIGATOR = @UltimoId

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe un NAVEGADOR con el Identificador asignado por el sistema. Consulte al Administrador. Id en conflicto: ' + CAST(@UltimoId as varchar)
	RETURN
END


BEGIN TRANSACTION

UPDATE LPA_InspectorWEB_DB.dbo.TD_PROYECTOS SET UltimoId = @UltimoId  WHERE IdProyecto = @IdProyecto

INSERT INTO TAP8_NAV_NAVIGATOR (
	CDNAVIGATOR,
	CD_PROYECTO,
	CDNAME,
	DSCONFIG,
	DSNODECONFIG,
	DSCOLMODSCRIPT
	)
VALUES (
	@UltimoId,
	@IdProyecto,
	@CDNAME, 
	RTRIM(@DSCONFIG), 
	RTRIM(@DSNODECONFIG), 
	RTRIM(@DSCOLMODSCRIPT)
	)


COMMIT






