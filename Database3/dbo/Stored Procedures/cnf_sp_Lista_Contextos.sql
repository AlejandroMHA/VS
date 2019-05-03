CREATE  PROCEDURE [dbo].[cnf_sp_Lista_Contextos] (
@IdProyecto				varchar(20) out
) 

as


SELECT CD_CONTEXT, CD_CONTEXT_CODE, DS_DESCRIPTION, DS_CONFIG + ' ' as DS_CONFIG FROM TAP8_WFM_CONTEXT WHERE CD_PROYECTO like @IdProyecto



