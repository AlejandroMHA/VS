CREATE  PROCEDURE [dbo].[cnf_sp_Lista_Pantallas]  (
@IdProyecto			varchar(20) out,
@query				varchar(30) out
)

as

SELECT CD_NAME
FROM TAP8_DSGR_SCREEN
WHERE CD_PROYECTO = @IdProyecto
UNION
SELECT @query

-- exec cnf_sp_Lista_Pantallas 'LPA_CONFIG', 'PANTALLITA'



