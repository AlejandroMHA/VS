CREATE  PROCEDURE [dbo].[cnf_sp_Lista_Fields] (
@IdProyecto				varchar(10) out
)


as

SELECT CD_FIELD,DS_NAME,DS_LABEL,DS_SCRIPT,DS_DEPENDFIELDNAMES,DS_CONFIG + ' ' as DS_CONFIG,DS_TYPE
FROM TAP8_DSGR_FIELD 
WHERE CD_PROYECTO LIKE @IdProyecto 



-- exec cnf_sp_Lista_Fields ''



