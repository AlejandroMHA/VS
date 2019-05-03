CREATE  PROCEDURE [dbo].[cnf_sp_Delete_Contexto] (
@CD_CONTEXT				int out,
@Mensaje				varchar(500) out
) 

as


DECLARE  @Conta int, @UltimoId int

SET @Mensaje = ''


SELECT @Conta = COUNT(*) FROM TAP8_WFM_CONTEXT WHERE CD_CONTEXT = @CD_CONTEXT

IF @Conta = 0 BEGIN
	SET @Mensaje = @Mensaje + 'NO Existe el Contexto a Eliminar'
	RETURN
END

DELETE FROM  TAP8_WFM_CONTEXT 
WHERE
	CD_CONTEXT = @CD_CONTEXT



