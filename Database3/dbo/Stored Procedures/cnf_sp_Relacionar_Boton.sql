CREATE  PROCEDURE [dbo].[cnf_sp_Relacionar_Boton] (
@IdProyecto			varchar(20) out,
@BuscarEn			int out,
@IdFuente			int out,
@CD_NAME			varchar(20) out,
@Mensaje			varchar(500) out
)

as


DECLARE @CD_BUTTON int, @Conta int

SELECT @CD_BUTTON = CD_BUTTON FROM TAP8_WFM_BUTTON WHERE CD_NAME = @CD_NAME


-- Asociarlo como boton de inicio de una Pantalla

IF @BuscarEn = 2 BEGIN
	UPDATE TAP8_DSGR_SCREEN SET CD_INITBUTTON = @CD_BUTTON WHERE CD_SCREEN = @IdFuente
	SET @Mensaje = 'El Boton ha sido correctamente registrado y fue asociado como botón de Inicio de la pantalla seleccionada en el formulario principal'
END


-- Asociarlo a un DataSource

IF @BuscarEn = 1 BEGIN
	SELECT @Conta = COUNT(*) FROM TAP8_WFM_QUERY_BUTTONS WHERE CD_QUERY = @IdFuente AND CD_BUTTON = @CD_BUTTON
	IF @Conta > 0 BEGIN
		SET @Mensaje = 'EL BOTON YA ESTA ASOCIADO, NO ES NECESARIO VOLVER A ASOCIARLO AL DATASOURCE'
		RETURN
	END
	INSERT INTO TAP8_WFM_QUERY_BUTTONS (CD_BUTTON, CD_QUERY, CD_PROYECTO) VALUES (@CD_BUTTON, @IdFuente, @IdProyecto)
	SET @Mensaje = 'El Boton ha sido correctamente registrado y fue asociado al DataSource seleccionado en el formulario principal'

END



