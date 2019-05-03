CREATE  PROCEDURE [dbo].[cnf_sp_Update_Navy_Querys] (
@IdProyecto				varchar(20) out,
@CDQUERY				int  out,
@CDNAME					varchar(128) out,
@CDNAVYNAME				varchar(128) out,
@DSOBJSTORES			varchar(128) out,
@DSCESQL				varchar(512) out,
@DSPESQL				varchar(512) out,
@DSPATHS				varchar(128) out,
@DSUSERS				varchar(128) out,
@DSCONFIG				varchar(2048) out,
@DSSCRIPT				varchar(3072) out,
@DSCOLMODSCRIPT			varchar(3072) out,
@DSQUEUENAME			varchar(128) out,
@Mensaje				varchar(500) out
)

as


DECLARE  @Conta int


SET @Mensaje = ''

IF @CDQUERY = '' BEGIN
	SET @Mensaje = @Mensaje + 'NO HA SELECCIONADO EL QUERY QUE DESEA ACTUALIZAR'
	RETURN
END


IF @CDNAME = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Nombre es obligatorio'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_NAV_QUERY WHERE CDNAME = @CDNAME AND CDNAVYNAME = @CDNAVYNAME AND CDQUERY <> @CDQUERY

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe otro Query con el mismo nombre para el Navegador Seleccionado. El Nombre debe ser único'
	RETURN
END



UPDATE TAP8_NAV_QUERY SET
CD_PROYECTO		= @IdPRoyecto,
CDNAME			= @CDNAME,	
DSOBJSTORES		= RTRIM(@DSOBJSTORES),		
DSCESQL			= RTRIM(@DSCESQL),		
DSPESQL			= RTRIM(@DSPESQL),				
DSPATHS			= RTRIM(@DSPATHS),			
DSUSERS			= RTRIM(@DSUSERS),				
DSCONFIG		= RTRIM(@DSCONFIG),				
DSSCRIPT		= RTRIM(@DSSCRIPT),				
DSCOLMODSCRIPT	= RTRIM(@DSCOLMODSCRIPT),			
DSQUEUENAME		= RTRIM(@DSQUEUENAME)		
WHERE 
CDQUERY = @CDQUERY



