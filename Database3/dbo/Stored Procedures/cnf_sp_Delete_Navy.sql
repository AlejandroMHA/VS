CREATE  PROCEDURE [dbo].[cnf_sp_Delete_Navy] (
@CDNAVIGATOR			int out, 
@Mensaje				varchar(max) out 
)

as

DECLARE @Conta int

 
SELECT @Conta = COUNT(*) FROM TAP8_NAV_NAVIGATOR WHERE CDNAVIGATOR = @CDNAVIGATOR

IF @Conta = 0 BEGIN
	SET @Mensaje = 'No se encuentra el Navegador que desea eliminar'
	RETURN
END



DELETE FROM  TAP8_NAV_NAVIGATOR 
WHERE CDNAVIGATOR = @CDNAVIGATOR



