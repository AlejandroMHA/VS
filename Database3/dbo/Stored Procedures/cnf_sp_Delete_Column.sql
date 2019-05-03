CREATE  PROCEDURE [dbo].[cnf_sp_Delete_Column] (
@CD_COLUMN				int out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int, @UltimoId int

SET @Mensaje = ''

SELECT @Conta = COUNT(*) FROM TAP8_WFM_COLUMN WHERE CD_COLUMN = @CD_COLUMN

IF @Conta = 0 BEGIN
	SET @Mensaje = @Mensaje + 'No hay ninguna columna seleccionada para Eliminar'
	RETURN
END



DELETE FROM TAP8_WFM_QUERY_COLUMNS
WHERE
CD_COLUMN = @CD_COLUMN

DELETE FROM TAP8_WFM_COLUMN 
WHERE
CD_COLUMN = @CD_COLUMN



