CREATE PROCEDURE [dbo].[cnf_sp_Insert_Navy_Querys] (
@IdProyecto				varchar(20) out,
@CDQUERY				int  out,
@CDNAME					varchar(128) out,
@CDNAVYNAME				varchar(128) out,
@DSOBJSTORES			varchar(128) out,
@DSCESQL				varchar(512) out,
@DSPESQL				varchar(512) out,
@DSPATHS				varchar(128) out,
@DSUSERS				varchar(128) out,
@DSCONFIG				varchar(2048) out,
@DSSCRIPT				varchar(3072) out,
@DSCOLMODSCRIPT			varchar(3072) out,
@DSQUEUENAME			varchar(128) out,
@Mensaje				varchar(500) out
)

as


DECLARE  @Conta int, @UltimoId int


SET @Mensaje = ''

IF @CDNAVYNAME = '' BEGIN
	SET @Mensaje = @Mensaje + 'Para poder agregar un Query tiene que tener seleccionado un Navegador'
	RETURN
END


IF @CDNAME = '' BEGIN
	SET @Mensaje = @Mensaje + 'El Nombre es obligatorio'
	RETURN
END

SELECT @Conta = COUNT(*) FROM TAP8_NAV_QUERY WHERE CDNAME = @CDNAME AND CDNAVYNAME = @CDNAVYNAME

IF @Conta > 0 BEGIN
	SET @Mensaje = @Mensaje + 'Ya existe otro Query con el mismo nombre para el Navegador Seleccionado. El Nombre debe ser único'
	RETURN
END

SELECT @UltimoId = UltimoId  + 1 FROM LPA_InspectorWEB_DB.dbo.TD_PROYECTOS WHERE IdProyecto = @IdProyecto



BEGIN TRANSACTION

UPDATE LPA_InspectorWEB_DB.dbo.TD_PROYECTOS SET UltimoId = @UltimoId  WHERE IdProyecto = @IdProyecto


INSERT INTO TAP8_NAV_QUERY (
CDQUERY,
CD_PROYECTO,
CDNAME,	
CDNAVYNAME,		
DSOBJSTORES,		
DSCESQL,		
DSPESQL,				
DSPATHS,			
DSUSERS,				
DSCONFIG,				
DSSCRIPT,				
DSCOLMODSCRIPT,			
DSQUEUENAME			
)
VALUES (
@UltimoId,
@IdPRoyecto,
@CDNAME,	
@CDNAVYNAME,		
RTRIM(@DSOBJSTORES),		
RTRIM(@DSCESQL),			
RTRIM(@DSPESQL),				
RTRIM(@DSPATHS),			
RTRIM(@DSUSERS),				
RTRIM(@DSCONFIG),				
RTRIM(@DSSCRIPT),				
RTRIM(@DSCOLMODSCRIPT),			
RTRIM(@DSQUEUENAME)	
)


COMMIT



