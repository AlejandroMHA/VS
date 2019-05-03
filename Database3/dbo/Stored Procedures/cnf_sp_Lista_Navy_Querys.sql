CREATE  PROCEDURE [dbo].[cnf_sp_Lista_Navy_Querys] (
@CDNAVYNAME				varchar(64) out
)

as

SELECT CDQUERY       
	  ,[CDNAME]
      ,[CDNAVYNAME]
      , ISNULL([DSOBJSTORES], '') + ' ' as [DSOBJSTORES]
      , ISNULL([DSCESQL], '') + ' ' as [DSCESQL]
      , ISNULL([DSPESQL], '') + ' ' as [DSPESQL]
      , ISNULL([DSPATHS], '') + ' ' as [DSPATHS]
      , ISNULL([DSUSERS], '') + ' ' as [DSUSERS]
      , ISNULL([DSCONFIG], '') + ' ' as [DSCONFIG]
      , ISNULL([DSSCRIPT], '') + ' ' as [DSSCRIPT]
      , ISNULL([DSCOLMODSCRIPT], '') + ' ' as [DSCOLMODSCRIPT]
      , ISNULL([DSQUEUENAME], '') + ' ' as [DSQUEUENAME]
  FROM [InspectorDB].[dbo].[TAP8_NAV_QUERY]
  WHERE CDNAVYNAME = @CDNAVYNAME



