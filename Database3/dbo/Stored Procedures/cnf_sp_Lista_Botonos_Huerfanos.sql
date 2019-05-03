CREATE  PROCEDURE [dbo].[cnf_sp_Lista_Botonos_Huerfanos] (
@IdProyecto			varchar(20) out
)

as

SET NOCOUNT ON

DECLARE @PosIniOpen int, @PosFinOpen int, @ListaDeBotones varchar(500), @OrdenLista int, @NombreBoton varchar(50), @MFinLista varchar(2), 
		@Script varchar(max), @_Script varchar(max) 


DECLARE @Botones TABLE (
	NombreBoton		varchar(50)
)

SET @Script = ''


DECLARE _scripts CURSOR FOR SELECT  CD_NAME, DS_SCRIPT
							FROM TAP8_WFM_BUTTON 
							WHERE CD_BUTTON IN (SELECT CD_BUTTON FROM TAP8_WFM_QUERY_BUTTONS) AND CD_PROYECTO = @IdProyecto
							UNION
							SELECT b.CD_NAME, b.DS_SCRIPT 
							FROM TAP8_DSGR_SCREEN a
							LEFT JOIN TAP8_WFM_BUTTON b ON b.CD_BUTTON = a.CD_INITBUTTON 
							WHERE 
							a.CD_PROYECTO = @IdProyecto 
OPEN _scripts

FETCH NEXT FROM _scripts INTO @NombreBoton, @_Script

WHILE @@FETCH_STATUS = 0 BEGIN

	INSERT INTO @Botones (NombreBoton) SELECT  @NombreBoton 
	SET @Script = @Script + ISNULL(@_Script, '')

	FETCH NEXT FROM _scripts INTO @NombreBoton, @_Script

END

CLOSE _scripts
DEALLOCATE _scripts


SET @PosIniOpen = 1

WHILE @PosIniOpen > 0 BEGIN

	SET @Script = REPLACE(@Script, ' ', '')
	SET @Script = REPLACE(@Script, '[', '')
	SET @Script = REPLACE(@Script, ']', '')
	SET @Script = REPLACE(@Script, '"', '')


	SET @PosIniOpen = CHARINDEX ( 'OPEN(', @Script, @PosIniOpen ) 

	IF @PosIniOpen > 0 BEGIN
	
		SET @PosIniOpen = @PosIniOpen + 5
		
		SET @PosFinOpen = CHARINDEX ( ')', @Script, @PosIniOpen ) 

		SET @ListaDeBotones = SUBSTRING(@Script, @PosIniOpen, @PosFinOpen - @PosIniOpen)

		SET @OrdenLista = 1

		SET @MFinLista = 'NO'

		WHILE @MFinLista <> 'SI' BEGIN

			EXEC LPA_InspectorWEB_DB.dbo.SP_LPA_SEPARA_LISTAS @ListaDeBotones out, @OrdenLista out, @NombreBoton out, ',', @MFinLista out
			
			INSERT INTO @Botones (NombreBoton) SELECT  @NombreBoton
			SET @OrdenLista = @OrdenLista + 1

		END
	END		

END

DELETE FROM @Botones WHERE NombreBoton IS NULL


SELECT CD_BUTTON,CD_NAME,DS_LABEL,DS_ICON_CLS,DS_TOOLTIP,DS_CONFIG + ' ' as DS_CONFIG,DS_SCRIPT + ' ' as DS_SCRIPT 
FROM TAP8_WFM_BUTTON 
WHERE CD_NAME NOT IN (SELECT NombreBoton FROM @Botones) AND CD_PROYECTO = @IdProyecto 
UNION
SELECT CD_BUTTON,CD_NAME,DS_LABEL,DS_ICON_CLS,DS_TOOLTIP,DS_CONFIG + ' ' as DS_CONFIG,DS_SCRIPT + ' ' as DS_SCRIPT 
FROM TAP8_WFM_BUTTON 
WHERE CD_PROYECTO = 'LPABase'


--  exec cnf_sp_Lista_Botonos_Huerfanos '_LPAConfig'



