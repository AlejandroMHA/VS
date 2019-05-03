CREATE PROCEDURE [dbo].[SP_VALIDAR_ACTUALIZACION] 
@iinIdQuery INT,
@ivaTipoActualizacion VARCHAR(2),
@ivaValoresColumna VARCHAR(MAX),
@ivaValoresColumnaOriginal VARCHAR(MAX),
@ivaUser VARCHAR(256),
@ovaMensaje VARCHAR(128) OUTPUT

AS



DECLARE @NomTabla varchar(256), @Transaccion varchar(30), @Id varchar(30)



SELECT @NomTabla = CD_NAME FROM InspectorDB.dbo.TAP8_WFM_QUERY WHERE CD_QUERY=@iinIdQuery


SET @Transaccion =  CASE @ivaTipoActualizacion
  WHEN 'U' THEN 'MODIFICAR'
  WHEN 'D' THEN 'BORRAR'
  WHEN 'I' THEN 'AGREGAR'
END



select @Id = SUBSTRING(@ivaValoresColumna, CHARINDEX ( 'Id$$' ,@ivaValoresColumna) +4 , CHARINDEX ( '##',@ivaValoresColumna , 5 ) -5) 



INSERT INTO AP8DB.dbo.TAP8_LPA_LOG
(NombreTabla,TipoTransaccion,ValoresColumna,ValoresColumnaOriginal,Mensaje,Usuario,Transaccion,FechaHora,IdAfectado)
VALUES
(@NomTabla,@ivaTipoActualizacion,@ivaValoresColumna,@ivaValoresColumnaOriginal,@ovaMensaje,@ivaUser,@Transaccion,getdate(),@Id)


SET @ovaMensaje = 'OK'


