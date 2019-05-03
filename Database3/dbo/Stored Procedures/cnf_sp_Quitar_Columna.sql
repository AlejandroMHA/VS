CREATE  PROCEDURE [dbo].[cnf_sp_Quitar_Columna] (
@CD_DATASOURCE			int out,
@CD_COLUMN				int out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int, @UltimoId int

SET @Mensaje = ''

SELECT @Conta = COUNT(*) FROM TAP8_WFM_QUERY_COLUMNS WHERE CD_COLUMN = @CD_COLUMN AND CD_QUERY = @CD_DATASOURCE

IF @Conta = 0 BEGIN
	SET @Mensaje = @Mensaje + 'La Columna NO está Asociada a la Fuente de Datos'
	RETURN
END

IF @CD_DATASOURCE = 0 OR @CD_COLUMN = 0  BEGIN
	SET @Mensaje = @Mensaje + 'Para poder Quitar una columna tiene que tener seleccionada La Fuentes de Datos y La Columna '
	RETURN
END

DELETE FROM TAP8_WFM_QUERY_COLUMNS
WHERE 	
CD_QUERY = @CD_DATASOURCE AND CD_COLUMN =@CD_COLUMN



