CREATE  PROCEDURE [dbo].[cnf_sp_Lista_Screens] (
@IdProyecto			varchar(20) out
)

as



SELECT 
a.CD_SCREEN,
a.CD_NAME, 
CASE WHEN a.CD_INITBUTTON = 0 OR a.CD_INITBUTTON IS NULL THEN '' ELSE a.CD_INITBUTTON END as CD_INITBUTTON, 
ISNULL(a.DS_CONFIG, '') + ' ' as DS_CONFIG, 
ISNULL(a.DS_DESCRIPCION, '') as DS_DESCRIPCION
FROM TAP8_DSGR_SCREEN a
WHERE CD_PROYECTO like @IdProyecto OR CD_PROYECTO is null

-- exec cnf_sp_Lista_Screens '_LPAConfig'



