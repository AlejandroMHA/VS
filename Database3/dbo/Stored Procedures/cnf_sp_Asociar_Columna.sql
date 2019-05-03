CREATE  PROCEDURE [dbo].[cnf_sp_Asociar_Columna] (
@IdProyecto				varchar(20) out,
@CD_DATASOURCE			int out,
@CD_COLUMN				int out,
@Mensaje				varchar(500) out
) 

as

DECLARE  @Conta int, @UltimoId int

SET @Mensaje = ''

SELECT @Conta = COUNT(*) FROM TAP8_WFM_QUERY_COLUMNS WHERE CD_COLUMN = @CD_COLUMN AND CD_QUERY = @CD_DATASOURCE

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'La Columna ya está Asociada a la Fuente de Datos'
	RETURN
END

IF @CD_DATASOURCE = 0 OR @CD_COLUMN = 0 OR @IdProyecto = '' BEGIN
	SET @Mensaje = @Mensaje + 'Para poder asociar una columna tiene que tener seleccionado un Proyecto, una Fuentes de Datos y una Columna '
	RETURN
END

INSERT INTO TAP8_WFM_QUERY_COLUMNS (
	CD_QUERY,
	CD_COLUMN,
	CD_PROYECTO
	)
VALUES (
	@CD_DATASOURCE,
	@CD_COLUMN,
	@IdProyecto
	)



