CREATE  PROCEDURE [dbo].[cnf_sp_Update_Navy] (
@IdProyecto				varchar(20) out,
@CDNAVIGATOR			int out, 
@CDNAME					varchar(128) out, 
@DSCONFIG				varchar(max) out, 
@DSNODECONFIG			varchar(max) out, 
@DSCOLMODSCRIPT			varchar(max) out,
@Mensaje				varchar(max) out 
)

as

DECLARE @Conta int

IF @CDNAVIGATOR = 0  BEGIN
	SET @Mensaje = 'NO TIENE SELECCIONADO UN NAVEGADOR PARA ACTUALIZAR'
	RETURN
END


IF @CDNAME = '' OR @IdProyecto = '' BEGIN
	SET @Mensaje = 'El nombre del Navegador y el Proyecto son obligatorios.'
	RETURN
END
 
SELECT @Conta = COUNT(*) FROM TAP8_NAV_NAVIGATOR WHERE CDNAME = @CDNAME AND CD_PROYECTO = @IdProyecto AND CDNAVIGATOR <> @CDNAVIGATOR

IF @Conta > 0 BEGIN
	SET @Mensaje = 'Ya existe otro Navegador con el mismo Nonmbre dentro del Proyecto'
	RETURN
END



UPDATE TAP8_NAV_NAVIGATOR SET 
	CD_PROYECTO		= @IdProyecto,
	CDNAME			= @CDNAME,
	DSCONFIG		= RTRIM(@DSCONFIG),
	DSNODECONFIG	= RTRIM(@DSNODECONFIG),
	DSCOLMODSCRIPT	= RTRIM(@DSCOLMODSCRIPT)
WHERE CDNAVIGATOR = @CDNAVIGATOR



