CREATE  PROCEDURE [dbo].[cnf_sp_Delete_Field] (
@CD_FIELD			int out
)

as

DELETE FROM TAP8_DSGR_FIELD WHERE CD_FIELD = @CD_FIELD



