﻿CREATE  PROCEDURE [dbo].[cnf_sp_Quitar_Boton] (
@CD_DATASOURCE			int out,
@CD_BUTTON				int out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int, @UltimoId int

SET @Mensaje = ''

SELECT @Conta = COUNT(*) FROM TAP8_WFM_QUERY_BUTTONS WHERE CD_BUTTON = @CD_BUTTON AND CD_QUERY = @CD_DATASOURCE

IF @Conta = 0 BEGIN
	SET @Mensaje = @Mensaje + 'EL BOTON QUE PRETENDE DESASOCIAR NO ESTA ASOCIADO AL DATA SOURCE'
	RETURN
END

IF @CD_DATASOURCE = 0 OR @CD_BUTTON = 0  BEGIN
	SET @Mensaje = @Mensaje + 'NO TIENE SELECCIONADO NINGUN BOTON '
	RETURN
END

DELETE FROM TAP8_WFM_QUERY_BUTTONS
WHERE 	
CD_QUERY = @CD_DATASOURCE AND CD_BUTTON = @CD_BUTTON



