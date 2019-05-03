

--/***********************************************************************/
--Name        :  StoredProcedure [dbo].[[SP_OBTENER_FILTRO]]
--Fecha       :  25/04/2016
--Descripción :  Mostrar tareas a los usuarios con mas de un reemplazado
--Autor       :  Victor Rodriguez
--/***********************************************************************/
--Name        :  StoredProcedure [dbo].[[SP_OBTENER_FILTRO]]
--Fecha       :  01/09/2016
--Descripción :  Se agregado un nuevo filtro para que el usuario de tipo jefe solo pueda ver las asignaciones realizadas a su jefatura actual.                    
--Autor       :  Victor Rodriguez
--Nro Req     :  Req.036

--/***********************************************************************/
--Name        :  StoredProcedure [dbo].[[SP_OBTENER_FILTRO]]
--Fecha       :  08/12/2016
--Descripción :  Se agregado una nueva condicion para obtener el filtro cuando el usuario sea jefe en adicion de una dependencia.                    
--Autor       :  Victor Rodriguez
--Nro Req     :  Req.046
--/***********************************************************************/
--- Requerimiento: Req. 053
--- Fecha de última modificación: 10/01/2017
--- Autor: Victor Rodriguez
--- Descripción:  Se realiza la modificación para que cuando el usuario para cumplir con lo establecido en el requerimiento.
----------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[SP_OBTENER_FILTRO] 
@ivaUser varchar(64),
@iinIdDataSource int,
@ovaFilter varchar(6000) output

as
 
DECLARE @EsAdmin varchar(2), @Vsql varchar(2000), @ClausulaOR varchar(6000), @UserReemp varchar(50), @RespDep varchar(20), @RespDepReemp varchar(200),@aux varchar(20),
		@UserAutoriza varchar(20), @Conta int, @MJefe varchar(2), @MGestor varchar(2), @MCodigoDependencias varchar(7), @temp varchar(1), @bRespuesta int, @codAdicion varchar(200)
		, @pos int, @User varchar(200),@valores VARCHAR(1000),  @JefeAdicOR varchar(6000), @userReepJefeAdicion varchar(2000)

--------------------
/*
declare @usersal varchar(64)
declare @reemplazoActivo int = null

SELECT @usersal = UPPER(CDUsuarioSal) -- 1. CDUsuarioSal
FROM AP8DB.dbo.TAP8_LPA_REEMPLAZOS
WHERE CDUsuarioSal = @ivaUser AND FEInicio <= convert(date, convert(char, GETDATE(), 103), 103)
 AND FEFin >= convert(date, convert(char, GETDATE(), 103), 103)

 if @usersal = @ivaUser begin
	SET @ivaUser = NEWID ( )  
	SET @reemplazoActivo = 1

 end
 */
--------------------------
SET  @ovaFilter = ''
SET  @MCodigoDependencias = 0

IF @ivaUser IN ('peadmin','ceadmin') 
RETURN

IF @iinIdDataSource IN (8001, 8002, 8006) BEGIN
	IF @iinIdDataSource IN (8001) BEGIN
		SET @ovaFilter = @ovaFilter + ' DRSA_sUsuarioJefe = ' + '''' + @ivaUser + ''''
	END

	IF @iinIdDataSource IN (8002) BEGIN
		SET @ovaFilter = @ovaFilter + ' DRSA_sUsuarioReq = ' + '''' + @ivaUser + ''' or DRSA_sUsuarioJefe = ''' + @ivaUser + ''''
	END

	IF @iinIdDataSource IN (8006) BEGIN
		SET @ovaFilter = @ovaFilter + ' DRSA_sUsuarioReq = ' + '''' + @ivaUser + ''''
	END

	--insert into test (texto) values ('Usuario Conectado: ' +  @ivaUser + ' Datarsource: ' + STR(@iinIdDataSource) + '  Filtro: '  + @ovaFilter)
		
	RETURN
END



EXEC DBPETROPERU.dbo.sic_sp_obtiene_si_es_Admin @ivaUser, @EsAdmin out
 

IF @EsAdmin = 'SI' AND @iinIdDataSource IN (1001,1003,1004,1006) 
      RETURN
 

--SET @UserReemp = '--' 
--SET @UserReemp = '' 
--SELECT @UserReemp = CDUsuarioSal
SELECT @UserReemp =    UPPER( COALESCE(@UserReemp +''',''','') + CDUsuarioSal ) -- 1. CDUsuarioSal
FROM AP8DB.dbo.TAP8_LPA_REEMPLAZOS
WHERE CDUsuarioEnt = @ivaUser AND FEInicio <= convert(date, convert(char, GETDATE(), 103), 103)
 AND FEFin >= convert(date, convert(char, GETDATE(), 103), 103)


--IF @UserReemp = '--'  OR @UserReemp IS NULL BEGIN
IF @UserReemp = ''  OR @UserReemp IS NULL BEGIN
	SET @UserReemp = @ivaUser
	
END

--== DataSource TD_PndAceptar (Correspondencia por Aceptar), TD_Aceptadas (Correspondencia por Tramitar) y sus subquerys
 
IF @iinIdDataSource IN (1001,1002,9029,9030,9031,38111) BEGIN
   
   
      SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TR_GESTOR_DEP WHERE Registro = ' + '''' + @ivaUser + ''''	
 
      IF @UserReemp IS NOT NULL AND @UserReemp <> ''
            --SET @Vsql = @Vsql + ' OR UPPER(Registro) = UPPER(' + '''' + @UserReemp + '''' + ')' 
            SET @Vsql = @Vsql + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
          
      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out

      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + @ClausulaOR 

	-- ** jefe de otras dependencias
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro = ' + '''' + @ivaUser + ''''

	 
     
	 IF @UserReemp IS NOT NULL AND @UserReemp <> '' AND CHARINDEX('_',@UserReemp,0)>0 BEGIN	
				SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro IN (' + '''' + @UserReemp + '''' +')'
				
	 END
	 SET @aux=' '
	 
     EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out

     IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
	     
	      IF LEN(@ovaFilter) > 0  SET @aux =' OR '

     SET @ovaFilter = @ovaFilter +@aux+ @ClausulaOR 

     SELECT @RespDep =  COALESCE(@RespDep +''',''','') + CONVERT(VARCHAR(20),CodigoDependencia)  --15--CodigoDependencia 
     FROM DBPETROPERU.DBO.TV_DEPENDENCIAS
     WHERE Registro = @ivaUser
    
     
     
     --SELECT @RespDepReemp = CodigoDependencia 
     SELECT @RespDepReemp = COALESCE(@RespDepReemp +''',''','') + CONVERT(VARCHAR(20),CodigoDependencia) -- CodigoDependencia 
     FROM DBPETROPERU.DBO.TV_DEPENDENCIAS
     --WHERE Registro in (@UserReemp)
     WHERE Registro COLLATE Latin1_General_100_CI_AS IN 
			( SELECT CDUsuarioSal FROM AP8DB.dbo.TAP8_LPA_REEMPLAZOS
				 WHERE CDUsuarioEnt = @ivaUser AND FEInicio <= convert(date, convert(char, GETDATE(), 103), 103) 
					AND FEFin >= convert(date, convert(char, GETDATE(), 103), 103) )
     
     
     
      IF @ovaFilter = ''  AND @RespDep IS NOT NULL 
            SET @ovaFilter = 'TD_CodigoDepDest IN ( ' + '''' + @RespDep + '''' + ')' --15
      
      IF @ovaFilter <> ''  AND @RespDep IS NOT NULL AND @RespDep <> ''
            SET @ovaFilter = @ovaFilter + ' OR TD_CodigoDepDest IN ( ' + '''' + @RespDep + '''' + ')' --15

      IF @ovaFilter = '' AND @RespDepReemp IS NOT NULL 
			SET @ovaFilter = 'TD_CodigoDepDest IN ( ' + '''' + @RespDepReemp + '''' + ')'
            --SET @ovaFilter = 'TD_CodigoDepDest = ' + '''' + @RespDepReemp + ''''
              
              
      IF @ovaFilter <> '' AND @RespDepReemp IS NOT NULL 
			SET @ovaFilter = @ovaFilter + ' OR TD_CodigoDepDest IN ( ' + '''' + @RespDepReemp + '''' + ')'
            --SET @ovaFilter = @ovaFilter + ' OR TD_CodigoDepDest = ' + '''' + @RespDepReemp + ''''
           
      IF @ovaFilter is NULL OR @ovaFilter = ''
		 SET @ovaFilter = ''		 
	  SET @ovaFilter = '(' + @ovaFilter + ')'
                        
END


--== Datasource TD_PndDigitalizar (Correspondencia Pendiente de Digitalizar), TD_CR_Rechazadas (Correspondencia Rechazada en la Dependencia), TD_DocConError (Documentos con Error)
 
IF @iinIdDataSource IN (1003,1004,1006) BEGIN
 
           
      set @Vsql = 'SELECT CodigoCGC FROM DBPETROPERU.dbo.TR_RADICADOR_CGC WHERE Registro = ' + '''' + @ivaUser + ''''
 
     IF @UserReemp IS NOT NULL AND @UserReemp <> ''
            SET @Vsql = @Vsql + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
            --SET @Vsql = @Vsql + ' OR UPPER(Registro) = UPPER(' + '''' + @UserReemp + '''' + ')' 
            
      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_sCodigoCGC', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + @ClausulaOR + + 'AND TD_sCorrelativo  NOT LIKE ''CEE%'''
      ELSE
            SET @ovaFilter = @ovaFilter + 'TD_sCodigoCGC = ' + '''' + '--' + ''''
 
END


--== Datasource TD_Acciones (Asignaciones)

IF @iinIdDataSource IN (1007, 9025, 9026, 9027, 9028) BEGIN
	
	 
	 SET @temp = '0'
     SET @ovaFilter = '('
		
	  
     --  Determina Jefe por dependencia
     EXEC DBPETROPERU.dbo.sic_sp_obtener_si_es_jefe @ivaUser, @MJefe out
      
   
     IF  @MJefe = 'SI' BEGIN
		
		--- Reemplazo
		IF @UserReemp IS NOT NULL AND @UserReemp <> '' BEGIN
			
			SET @UserReemp = @ivaUser + '''' +',' + '''' + @UserReemp
			
			SET @ovaFilter = '(' + @ovaFilter + ' sVersion < ''7.0''  And ( TD_sRegistroResp IN ( ' + '''' + UPPER(@UserReemp)  + '''' + ') OR ' + 'TD_sRegistroResp IN (' + '''' + LOWER(@UserReemp) + '''' + ')'
			
			
			--SET @ovaFilter = '(('+ @ovaFilter + 'TD_sRegistroResp IN ( ' + '''' + UPPER(@UserReemp)  + '''' + ') OR ' +  'TD_sRegistroResp IN (' + '''' + LOWER(@UserReemp) + '''' + ')) And sVersion < ''7.0''' 
			SET @temp = '1'
			
		END
		 
		
		
		SET @Vsql = 'SELECT RegistroF FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro IN (' + '''' + @ivaUser + '''' + ')'
		SET @valores = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro IN (' + '''' + @ivaUser + '''' + ')'
		
		DECLARE @cntReempAd int
		SET @userReepJefeAdicion = ''
		
		SELECT @cntReempAd = COUNT(*) FROM AP8DB.dbo.TAP8_LPA_REEMPLAZOS WHERE CDUsuarioEnt = '' + @ivaUser + ''  AND FEInicio <= convert(date, convert(char, GETDATE(), 103), 103) AND FEFin >= convert(date, convert(char, GETDATE(), 103), 103)
		
	    IF  @cntReempAd <> '0' BEGIN
			SELECT @userReepJefeAdicion =    UPPER( COALESCE(@userReepJefeAdicion +''',''','') + CDUsuarioSal )	FROM AP8DB.dbo.TAP8_LPA_REEMPLAZOS WHERE CDUsuarioEnt = '' + @ivaUser + '' AND FEInicio <= convert(date, convert(char, GETDATE(), 103), 103) AND FEFin >= convert(date, convert(char, GETDATE(), 103), 103)
			SET @userReepJefeAdicion = ' AND Registro NOT IN (' + '''' + @userReepJefeAdicion + '''' + ')'
		END
	   
	   
	   PRINT @userReepJefeAdicion
		IF @UserReemp IS NOT NULL AND @UserReemp <> '' BEGIN
		    
			SET @valores = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro IN (' + '''' + @UserReemp + '''' +')' + @userReepJefeAdicion
			
			SET @Vsql = 'SELECT RegistroF FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro IN (' + '''' + @UserReemp + '''' +')' + @userReepJefeAdicion 
			
		END

	
		EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @valores out, 'TD_CodigoDepAsig', @JefeAdicOR out
				 
		
		EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_sRegistroResp', @ClausulaOR out
		
	    
		IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> '' BEGIN
					
			IF @temp = '1' BEGIN
			    
			   SET @ovaFilter = @ovaFilter + ' OR ' + 'TD_sRegistroResp IN (' + '''' + UPPER(@UserReemp)  + '''' + ') OR ' + 'TD_sRegistroResp IN (' + '''' + LOWER(@UserReemp) + '''' + ') OR ' + @ClausulaOR

			END  
			
		END	
				
	       	
		DECLARE @sWhereDep varchar(200)
		SET @sWhereDep = + '''' + @ivaUser + '''' 
		
		
	    IF @UserReemp IS NOT NULL AND @UserReemp <> '' BEGIN
			SET @sWhereDep = + '''' + @ivaUser + '''' + ','  + ''''+ @UserReemp + '''' 
		END
		 
		
		SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE Registro IN ( ' +  @sWhereDep  + ')'
		
	    EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepAsig', @ClausulaOR out
	    ---------------------
	    IF @JefeAdicOR IS NOT NULL AND @JefeAdicOR <> '' BEGIN
	      SET @ClausulaOR = @ClausulaOR +' OR '+ @JefeAdicOR
	    END
	    --------------------
	   
	    IF @temp = '0' BEGIN

			SET @ovaFilter = @ovaFilter + '((' + @ClausulaOR 
			SET @ovaFilter = @ovaFilter + ') and  sVersion >= ''7.0'')'    
		END	
		ELSE BEGIN
			SET @ovaFilter = @ovaFilter + '))'
			SET @ovaFilter = @ovaFilter + ' OR (' + @ClausulaOR 
			SET @ovaFilter = @ovaFilter + ' and  sVersion >= ''7.0'')'    

		END	
               
       
        SET @ovaFilter = @ovaFilter  + ' OR ( (TD_sRegistroResp IN (' + '''' + UPPER(@UserReemp) + '''' + ') OR ' + 'TD_sRegistroResp IN (' + '''' + LOWER(@UserReemp) + '''' + ')) And ' + 'TD_CodigoDepAsig = 0 )' 
     END
   
     
     ---- Determina si es gestor por dependencia
     SELECT TOP 1 @MCodigoDependencias = codigodependencia
      FROM DBPETROPERU.DBO.TR_GESTOR_DEP
      WHERE Registro = @ivaUser
      
      declare @vall varchar(10)
      
      SET @vall = ' '
      SET @aux = ' '
      
      
      IF @MCodigoDependencias > 0 BEGIN
	      
	       IF(@MJefe = 'SI' AND @MCodigoDependencias > 0) BEGIN
	         -- SET @vall = ' OR ' 
		     SET @aux = ' OR'
	         SET @vall = '  ' 
	       END
	       
			SET @ovaFilter = @vall + ' ('+ @ovaFilter + @aux+' TD_sRegistroResp = ' + '''' + UPPER(@ivaUser)  + '''' + ' OR ' + 'TD_sRegistroResp = ' + '''' + LOWER(@ivaUser) + '''' 

			IF @UserReemp IS NOT NULL AND @UserReemp <> '' BEGIN	
			    
			    --SET @ovaFilter = @ovaFilter +' OR '+  'TD_sRegistroResp = ' + '''' + UPPER(@UserReemp)  + '''' + ' OR ' +  'TD_sRegistroResp = ' + '''' + LOWER(@UserReemp) + '''' 
			    SET @ovaFilter = @ovaFilter +' OR '+  'TD_sRegistroResp IN (' + '''' + UPPER(@UserReemp)  + '''' + ') OR ' +  'TD_sRegistroResp IN (' + '''' + LOWER(@UserReemp) + '''' + ')' 
			END	 
			
		    -- Otras dependencias del gestor
			SET @Vsql = 'SELECT codigodependencia FROM DBPETROPERU.dbo.TR_GESTOR_DEP WHERE Registro = ' + '''' + @ivaUser + ''''
        
            EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepAsig', @ClausulaOR out
                 
            IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
                 SET @ovaFilter = @ovaFilter + ') OR ((' + @ClausulaOR 
                 SET @ovaFilter = @ovaFilter + ') and  sVersion >= ''7.0'')'    
                            
      END
      ----- 
  	  -- Determina si es ejecutor 
	  
	  SELECT @bRespuesta = count(*)
	  FROM DBPETROPERU.dbo.TV_DEPENDENCIAS a , DBPETROPERU.dbo.TR_GESTOR_DEP b
	  WHERE a.registro = @ivaUser OR b.registro = @ivaUser
    
      DECLARE @TD_CodigoDepAsig varchar(50)
 	  SET @TD_CodigoDepAsig = ' '
 	  
 	  print @bRespuesta
	  IF @bRespuesta = 0 BEGIN 
	    
	     print 'asas'
	     IF(@MJefe = 'SI'  AND @bRespuesta = 0) BEGIN
	         SET @vall = ' OR '  
	        
	     END
	         --- 03
	     --ELSE
	     --  BEGIN
	      
	        SET @TD_CodigoDepAsig = ' AND TD_CodigoDepAsig = 0'
	         
	     --END
	     ---
	     PRINT 'A' + @TD_CodigoDepAsig
		  PRINT @ovaFilter
	     SET @ovaFilter = @ovaFilter  +  @vall + '  ( ( TD_sRegistroResp IN (' + '''' + UPPER(@UserReemp) + '''' + ') OR ' + 'TD_sRegistroResp IN (' + '''' + LOWER(@UserReemp) + '''' + ') OR ' + 'TD_sRegistroResp = ' + '''' + @ivaUser + '''' + ')'  + @TD_CodigoDepAsig + ')'
		 PRINT @ovaFilter
	  END
	  
	 SET @ovaFilter = @ovaFilter + ')'
END	

--== Datasource TD_CE_PndAprobar (Despachos por Aprobar)

IF @iinIdDataSource IN (1008) BEGIN

          
      SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE Registro = ' + '''' + @ivaUser + ''''
      
      IF @UserReemp IS NOT NULL AND @UserReemp <> ''
            SET @Vsql = @Vsql + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
            --SET @Vsql = @Vsql + ' OR UPPER(Registro) = UPPER(' + '''' + @UserReemp + '''' + ')' 
	
 
      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_iCodigoDepAutorizador', @ClausulaOR out
      
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> '' BEGIN
            SET @ovaFilter = @ovaFilter + @ClausulaOR 
			--print '@@ClausulaOR '+@ClausulaOR
		END
		/*
		ELSE
		BEGIN
			if @reemplazoActivo IS NOT null begin
				SET @ovaFilter = @ovaFilter + 'TD_iCodigoDepAutorizador = ''-1'''
			END
		END
		*/

			
	-- ** jefe de otras dependencias
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro = ' + '''' + @ivaUser + ''''
     
     EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_iCodigoDepAutorizador', @ClausulaOR out
 
     IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + ' OR ' + @ClausulaOR  
      
      /*
      SET @ovaFilter = 'TD_sRegistroAutorizador = ' + '''' + @ivaUser + '''' + ' OR ' + 
			'TD_sRegistroAutorizador = ' + '''' + LOWER(@ivaUser) + ''''
              
      IF @ovaFilter <> '' AND @UserReemp IS NOT NULL 
         SET @ovaFilter = @ovaFilter + ' OR TD_sRegistroAutorizador = ' + '''' + @UserReemp + '''' + ' OR ' + 
			'TD_sRegistroAutorizador = ' + '''' + LOWER(@UserReemp) + ''''
	  */
		
END

--== Datasource TD_CE_Aprobadas (Despachos aprobados)

IF @iinIdDataSource IN (1009) BEGIN

	 SET @Vsql = 'SELECT CodigoCGC FROM DBPETROPERU.dbo.TR_RADICADOR_CGC WHERE Registro = ' + '''' + @ivaUser + '''' 	
					
     
      IF @UserReemp IS NOT NULL AND @UserReemp <> ''
			SET @Vsql = @Vsql + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
            --SET @Vsql = @Vsql + ' OR UPPER(Registro) = UPPER(' + '''' + @UserReemp + '''' + ')' 
 
      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_sCodigoCGC', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + @ClausulaOR 
	

	/*

	SET @ovaFilter = 'TD_sRegistroAutorizador = ' + '''' + @ivaUser + '''' + ' OR ' + 
			'TD_sRegistroAutorizador = ' + '''' + LOWER(@ivaUser) + ''''
	
			
	SET @ovaFilter = @ovaFilter + ' OR sRegistroRadicador = ' + '''' + @ivaUser + '''' + ' OR ' + 
			' sRegistroRadicador = ' + '''' + LOWER(@ivaUser) + ''''
              
    IF @UserReemp IS NOT NULL  BEGIN
         SET @ovaFilter = @ovaFilter + ' OR TD_sRegistroAutorizador = ' + '''' + @UserReemp + '''' + ' OR ' + 
			'TD_sRegistroAutorizador = ' + '''' + LOWER(@UserReemp) + ''''
			
		 SET @ovaFilter = @ovaFilter + ' OR sRegistroRadicador = ' + '''' + @UserReemp + '''' + ' OR ' + 
			'sRegistroRadicador = ' + '''' + LOWER(@UserReemp) + ''''
	END
	*/
	
END


/* Documentos en Redacción 
	Solo accede quien hizo el registro del documento y/o su reemplazo.
	Filtro por el Registro del Redactor (propiedad: s_RegistroRedactor)
*/

-- Datasource TD_DocRedaccion (Documentos en Redaccion)
IF @iinIdDataSource IN (1010) BEGIN
	SET @ovaFilter = ' ( s_RegistroRedactor = ' + '''' + @UserReemp + '''' + ' OR  s_RegistroRedactor = ' + '''' + @ivaUser + '''' + ')' 
	RETURN
END



/* Documentos para Aprobar
	Solo accede el Jefe de la Dependencia o su reemplazante para Acciones distintas a Dar Visto. El Gestor puede ver pero no hacer acciones.
	Solo accede el usuario al que se le pido el visto para acciones de Dar Visto
	
*/
-- Datasource TD_DocAprobacion (Documentos para Aprobar)
IF @iinIdDataSource IN (1011) BEGIN
	-- Determina la dependencia del usuario y la dependencia del usuario al que reemplaza.
	
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE  ( Registro = ' + '''' + @ivaUser + '''' +
				  ' OR Registro IN ( ' + '''' + @UserReemp + '''' + ')) '	
				 --' OR Registro = ' + '''' + @UserReemp + '''' + ') '	
				 
					

      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + '((' + @ClausulaOR + ') AND TD_sAccion <> ' + '''' + 'DAR VISTO' + '''' + ') OR ' 
			--SET @ovaFilter = @ovaFilter + ' ((sRegistroVisto = ' + '''' + LOWER(@ivaUser) + '''' + ' OR sRegistroVisto = ' + '''' + LOWER(@UserReemp) + '''' + ' OR sRegistroVisto =' + '''' + UPPER(@ivaUser) + '''' + ' OR sRegistroVisto = ' + '''' + UPPER(@UserReemp) + '''' + ') AND TD_sAccion = ' + '''' + 'DAR VISTO' + '''' + ')'
			SET @ovaFilter = @ovaFilter + ' ((sRegistroVisto = ' + '''' + LOWER(@ivaUser) + '''' + ' OR sRegistroVisto IN (' + '''' + LOWER(@UserReemp) + '''' + ') OR sRegistroVisto =' + '''' + UPPER(@ivaUser) + '''' + ' OR sRegistroVisto = ' + '''' + UPPER(@UserReemp) + '''' + ') AND TD_sAccion = ' + '''' + 'DAR VISTO' + '''' + ')'


	-- ** jefe de otras dependencias
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro = ' + '''' + @ivaUser + ''''
     
     EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 
     IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + ' OR ' + @ClausulaOR 


	--  Determina Gestor
	--EXEC DBPETROPERU.dbo.sic_sp_obtener_si_es_jefe @ivaUser, @MJefe out
	
	--IF @MJefe = 'SI' BEGIN

	  --SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TR_GESTOR_DEP WHERE Registro = ' + '''' + @ivaUser + '''' + ' OR UPPER(Registro) = UPPER(' + '''' + @UserReemp + '''' + ')' 
	  SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TR_GESTOR_DEP WHERE Registro = ' + '''' + @ivaUser + '''' + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
	 
      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + ' OR (' +  @ClausulaOR + ')'
      
      IF @ovaFilter = '' BEGIN
			SET @ovaFilter = ' s_RegistroRedactor = ' + '''' + ' mxjd8skjfkjalj123332' + ''''
	  END
	  
	--END  
END


/* Documentos Rechazados
	Solo accede el Jefe de la Dependencia o su reemplazante para Acciones distintas a Dar Visto. 
	Tambien acceden el redactor del documento.
	
*/
-- Datasource TD_DocRechazados (Documentos Rechazados)
IF @iinIdDataSource IN (1012) BEGIN
	-- Determina la dependencia del usuario y la dependencia del usuario al que reemplaza.
	
	SELECT @UserReemp = CDUsuarioEnt
	FROM AP8DB.dbo.TAP8_LPA_REEMPLAZOS
	WHERE CDUsuarioSal = @ivaUser AND FEInicio <= convert(date, convert(char, GETDATE(), 103), 103)
	 AND FEFin >= convert(date, convert(char, GETDATE(), 103), 103)
		
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE  ( Registro = ' + '''' + @ivaUser + '''' +
				 ' OR Registro IN (' + '''' + @UserReemp + '''' + ') ) '	
				 --' OR Registro = ' + '''' + @UserReemp + '''' + ') '	
					

      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_iCodigoDepOrig', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + '(' + @ClausulaOR + ')'  + ' OR s_RegistroRedactor = ' + '''' + @ivaUser + '''' + ' OR s_RegistroRedactor IN( ' + '''' + @UserReemp + '''' +')'
      ELSE
			SET @ovaFilter = @ovaFilter + 's_RegistroRedactor = ' + '''' + @ivaUser + '''' + ' OR s_RegistroRedactor IN (' + '''' + @UserReemp + '''' + ')'
                 
      
      --IF @ovaFilter = '' BEGIN
		--	SET @ovaFilter = ' s_RegistroRedactor = ' + '''' + ' mxjd8skjfkjalj123332' + ''''
	  --END
END




/* Documentos para Firmar
	Solo acceden el Gestor y  el Jefe de la Dependencia o su reemplazante. 
	
*/

IF @iinIdDataSource IN (1014) BEGIN
	-- Determina la dependencia del usuario y la dependencia del usuario al que reemplaza.
	
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE  ( Registro = ' + '''' + @ivaUser + '''' +
				 ' OR Registro IN ( ' + '''' + @UserReemp + '''' + ') ) '	
				 --' OR Registro = ' + '''' + @UserReemp + '''' + ') '	
					

      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + '(' + @ClausulaOR + ') '

	-- ** jefe de otras dependencias
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro = ' + '''' + @ivaUser + ''''
     
     EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 
     IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + ' OR ' + @ClausulaOR 


	--  Determina Gestor

	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TR_GESTOR_DEP WHERE Registro = ' + '''' + @ivaUser + '''' + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
					
 
      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + ' (' +  @ClausulaOR + ')'
      
      IF @ovaFilter = '' 
			SET @ovaFilter = ' s_RegistroRedactor = ' + '''' + ' mxjd8skjfkjalj123332' + ''''
	  
END


--IF @ovaFilter <> ''
 --SET @ovaFilter = '(' + @ovaFilter + ')'


--INSERT INTO DBPETROPERU.dbo.Test (test) VALUES ('@ivaUser = ' + @ivaUser + ' @iinIdDataSource = ' + @iinIdDataSource + '@ovaFilter = ' + @ovaFilter)

--IF @iinIdDataSource = 1007
	--INSERT INTO DBPETROPERU.dbo.Test (test) VALUES ('@ovaFilter = ' + @ovaFilter + '; @ivaUser = ' + @ivaUser)


/* prueba de filtros

DECLARE @Filtro varchar(2000)
EXEC SP_OBTENER_FILTRO 'ejecutor7', 1007, @Filtro out
select @Filtro

select * from DBPETROPERU.dbo.td_funcionarios where Registro = 'jefe1'

 declare @ivaUser varchar(30), @UserReemp varchar (30), @Vsql varchar(2000), @ClausulaOR varchar(8000)
 SET @ivaUser = 'gestor8'
 SET @UserReemp = 'gestor8'
 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TR_GESTOR_DEP WHERE Registro = ' + '''' + @ivaUser + '''' + ' OR UPPER(Registro) = UPPER(' + '''' + @UserReemp + '''' + ')' 
 EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 
 select @ClausulaOR
 
 */

 /*
 DECLARE @Filtro varchar(2000)
EXEC SP_OBTENER_FILTRO 'jefe8', 1008, @Filtro out
select @Filtro

SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE Registro = 'jefe8' OR UPPER(Registro) IN ('JEFE4')
SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro = 'jefe8'

select * from DBPETROPERU.dbo.td_funcionarios where Registro = 'jefe1'
*/
