CREATE PROCEDURE [dbo].[cnf_Actualiza_Componente] (
@IdProyecto				varchar(10) out,
@TipoObjeto				varchar(20) out,
@NombreObjeto			varchar(100) out,
@Donde					varchar(50) out,
@Contenido				varchar(max) out,
@Mensaje				varchar(500) out
)

as

SET NOCOUNT ON



