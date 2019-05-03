CREATE  PROCEDURE [dbo].[cnf_sp_Delete_Grid] (
@CD_GRID					int out
)

as

DECLARE @Conta int


DELETE FROM  TAP8_GRIDS_GRID WHERE CD_GRID = @CD_GRID



