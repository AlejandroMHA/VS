CREATE PROCEDURE [dbo].[SP_TEST_01] 
@ivaUser varchar(64),
@iinIdDataSource int,
@ovaFilter varchar(6000) output

as
 
DECLARE @EsAdmin varchar(2), @Vsql varchar(2000), @ClausulaOR varchar(6000), @UserReemp varchar(200), @RespDep varchar(20), @RespDepReemp varchar(200),
		@UserAutoriza varchar(20), @Conta int, @MJefe varchar(2), @MGestor varchar(2), @MCodigoDependencias varchar(7), @temp varchar(1), @bRespuesta int
 

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

	insert into test (texto) values ('Usuario Conectado: ' +  @ivaUser + ' Datarsource: ' + STR(@iinIdDataSource) + '  Filtro: '  + @ovaFilter)
		
	RETURN
END



EXEC DBPETROPERU.dbo.sic_sp_obtiene_si_es_Admin @ivaUser, @EsAdmin out
 
 
IF @EsAdmin = 'SI' AND @iinIdDataSource IN (1001,1003,1004,1006) 
      RETURN
 

--SET @UserReemp = '' 
SELECT @UserReemp =    UPPER( COALESCE(@UserReemp +''',''','') + CDUsuarioSal ) -- 1. CDUsuarioSal
FROM AP8DB.dbo.TAP8_LPA_REEMPLAZOS
WHERE CDUsuarioEnt = @ivaUser AND FEInicio <= convert(date, convert(char, GETDATE(), 103), 103)
 AND FEFin >= convert(date, convert(char, GETDATE(), 103), 103)
 
IF @UserReemp = ''  OR @UserReemp IS NULL BEGIN
	SET @UserReemp = @ivaUser
	PRINT '1.-'
END

--== TD_PndAceptar, TD_Aceptadas y sus subquerys
 
IF @iinIdDataSource IN (1001,1002,9029,9030,9031,38111) BEGIN
 
           
      SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TR_GESTOR_DEP WHERE Registro = ' + '''' + @ivaUser + ''''
     PRINT '1.-'
      IF @UserReemp IS NOT NULL AND @UserReemp <> ''
			--2.-      
            --SET @Vsql = @Vsql + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
            SET @Vsql = @Vsql + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
 
      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 PRINT '2.-'
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + @ClausulaOR 

	-- ** jefe de otras dependencias
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro = ' + '''' + @ivaUser + ''''
     PRINT '3.-'
     EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 PRINT '4.-'
     IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + @ClausulaOR 
     
           
     SELECT @RespDep = CodigoDependencia 
     FROM DBPETROPERU.DBO.TV_DEPENDENCIAS
     WHERE Registro = @ivaUser
     
     PRINT '5.-'
     
     SELECT @RespDepReemp = COALESCE(@RespDepReemp +''',''','') + CONVERT(VARCHAR(20),CodigoDependencia) -- CodigoDependencia 
     FROM DBPETROPERU.DBO.TV_DEPENDENCIAS
     --3.-
     --WHERE Registro = @UserReemp
     WHERE Registro COLLATE Latin1_General_100_CI_AS IN ( SELECT CDUsuarioSal FROM AP8DB.dbo.TAP8_LPA_REEMPLAZOS WHERE CDUsuarioEnt = @ivaUser AND FEInicio <= convert(date, convert(char, GETDATE(), 103), 103) AND FEFin >= convert(date, convert(char, GETDATE(), 103), 103) )
     
     PRINT '6.-'
      IF @ovaFilter = ''  AND @RespDep IS NOT NULL 
            SET @ovaFilter = 'TD_CodigoDepDest = ' + '''' + @RespDep + ''''
      
      IF @ovaFilter <> ''  AND @RespDep IS NOT NULL AND @RespDep <> ''
            SET @ovaFilter = @ovaFilter + ' OR TD_CodigoDepDest = ' + '''' + @RespDep + ''''

      IF @ovaFilter = '' AND @RespDepReemp IS NOT NULL 
              SET @ovaFilter = 'TD_CodigoDepDest IN ( ' + '''' + @RespDepReemp + '''' + ')'
              PRINT '7.-'
              --4.-
              --SET @ovaFilter = 'TD_CodigoDepDest = ' + '''' + @RespDepReemp + ''''
              
              
      IF @ovaFilter <> '' AND @RespDepReemp IS NOT NULL 
			  SET @ovaFilter = @ovaFilter + ' OR TD_CodigoDepDest IN ( ' + '''' + @RespDepReemp + '''' + ')'
			  PRINT '8.-'
			  --SET @ovaFilter = @ovaFilter + ' OR TD_CodigoDepDest = ' + '''' + @RespDepReemp + ''''
              --5.-
           
      IF @ovaFilter is NULL OR @ovaFilter = ''
		 SET @ovaFilter = ''		 
	  SET @ovaFilter = '(' + @ovaFilter + ')'
                        
END


--== TD_PndDigitalizar, TD_CR_Rechazadas, TD_DocConError
 
IF @iinIdDataSource IN (1003,1004,1006) BEGIN
 
           
      set @Vsql = 'SELECT CodigoCGC FROM DBPETROPERU.dbo.TR_RADICADOR_CGC WHERE Registro = ' + '''' + @ivaUser + ''''
 
     IF @UserReemp IS NOT NULL AND @UserReemp <> ''
            SET @Vsql = @Vsql + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
            --SET @Vsql = @Vsql + ' OR UPPER(Registro) = UPPER(' + '''' + @UserReemp + '''' + ')' 
            --6.-
            
      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_sCodigoCGC', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + @ClausulaOR
      ELSE
            SET @ovaFilter = @ovaFilter + 'TD_sCodigoCGC = ' + '''' + '--' + ''''
 
END


--== TD_Acciones y sus subquerys

IF @iinIdDataSource IN (1007, 9025, 9026, 9027, 9028) BEGIN
      
      SET @temp = '0'
      --  Determina Jefe por dependencia
      EXEC DBPETROPERU.dbo.sic_sp_obtener_si_es_jefe @ivaUser, @MJefe out
      
      PRINT '2.-'	
      
      IF @MJefe = 'SI' BEGIN   

			-- Si reemplaza a usuarios
			IF @UserReemp IS NOT NULL AND @UserReemp <> '' BEGIN	
			    SET @ovaFilter = '('+ @ovaFilter + 'TD_sRegistroResp IN ( ' + '''' + @UserReemp  + '''' + ') OR ' +  'TD_sRegistroResp IN ( ' + '''' + LOWER(@UserReemp) + '''' +')' 
			    --7.-
			    --SET @ovaFilter = '('+ @ovaFilter + 'TD_sRegistroResp = ' + '''' + UPPER(@UserReemp)  + '''' + ' OR ' +  'TD_sRegistroResp = ' + '''' + LOWER(@UserReemp) + '''' 
				SET @temp = '1'
			END	 
			-- jefe de otras dependencias
			SET @Vsql = 'SELECT RegistroF FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro = ' + '''' + @ivaUser + ''''
			
			EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_sRegistroResp', @ClausulaOR out
			
			IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''  
			BEGIN
				IF @temp = '1'
				BEGIN
					SET @ovaFilter = @ovaFilter + ' OR ' + 'TD_sRegistroResp = ' + '''' + UPPER(@ivaUser)  + '''' + ' OR ' + 'TD_sRegistroResp = ' + '''' + LOWER(@ivaUser) + '''' + ' OR ' + @ClausulaOR
				END   
			END				
			-- consulta las dependencias del Jefe
            SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE Registro = ' + '''' + @ivaUser + ''''
     
            EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepAsig', @ClausulaOR out
 
            IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> '' 
			BEGIN
				IF @temp = 0
				BEGIN
					SET @ovaFilter = @ovaFilter + '((' + @ClausulaOR 
					SET @ovaFilter = @ovaFilter + ') and  sVersion >= ''7.0'')'    
				END	
				ELSE
				BEGIN
					SET @ovaFilter = @ovaFilter + ')'
					SET @ovaFilter = @ovaFilter + ' OR (' + @ClausulaOR 
					SET @ovaFilter = @ovaFilter + 'and  sVersion >= ''7.0'')'    
				END	
			END	
			ELSE
			    	SET @ovaFilter = @ovaFilter + ')'
      END
      
      -- Determina si es gestor por dependencia
      SELECT TOP 1 @MCodigoDependencias = codigodependencia
      FROM DBPETROPERU.DBO.TR_GESTOR_DEP
      WHERE Registro = @ivaUser
      
      PRINT '3.-' + @MCodigoDependencias
      
      IF @MCodigoDependencias > 0 BEGIN
	        
			SET @ovaFilter = '('+ @ovaFilter + 'TD_sRegistroResp = ' + '''' + UPPER(@ivaUser)  + '''' + ' OR ' + 'TD_sRegistroResp = ' + '''' + LOWER(@ivaUser) + '''' 
			
			IF @UserReemp IS NOT NULL AND @UserReemp <> '' BEGIN	
			    SET @ovaFilter = @ovaFilter +' OR '+  'TD_sRegistroResp IN ( ' + '''' + @UserReemp  + '''' + ') OR ' +  'TD_sRegistroResp IN (' + '''' + LOWER(@UserReemp) + '''' + ')' 
			    --9.-
			    --SET @ovaFilter = @ovaFilter +' OR '+  'TD_sRegistroResp = ' + '''' + UPPER(@UserReemp)  + '''' + ' OR ' +  'TD_sRegistroResp = ' + '''' + LOWER(@UserReemp) + '''' 
			END	 
			
		    -- Otras dependencias del gestor
			SET @Vsql = 'SELECT codigodependencia FROM DBPETROPERU.dbo.TR_GESTOR_DEP WHERE Registro = ' + '''' + @ivaUser + ''''
        
            EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepAsig', @ClausulaOR out
                 
            IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
                 SET @ovaFilter = @ovaFilter + ') OR ((' + @ClausulaOR 
                 SET @ovaFilter = @ovaFilter + ') and  sVersion >= ''7.0'')'    
                            
      END
	  
	  -- Determina si es ejecutor 
	  
	  SELECT @bRespuesta = count(*)
	  FROM DBPETROPERU.dbo.TV_DEPENDENCIAS a , DBPETROPERU.dbo.TR_GESTOR_DEP b
	  WHERE a.registro = @ivaUser OR b.registro = @ivaUser
	  PRINT '4.-' 
	  IF @bRespuesta = 0 BEGIN 
	  PRINT '5.-'
	     PRINT @UserReemp
		SET @ovaFilter = '(TD_sRegistroResp IN (' + '''' + @UserReemp + '''' + ') OR ' + 'TD_sRegistroResp IN (' + '''' + LOWER(@UserReemp) + '''' + ') OR ' + 'TD_sRegistroResp = ' + '''' + @ivaUser + '''' + ')' 
		PRINT  @ovaFilter
		--10.-
		--SET @ovaFilter = '(TD_sRegistroResp = ' + '''' + UPPER(@UserReemp) + '''' + ' OR ' + 'TD_sRegistroResp = ' + '''' + LOWER(@UserReemp) + '''' + ' OR ' + 'TD_sRegistroResp = ' + '''' + @ivaUser + '''' + ')' 
      END
      
 --Prueba bladimir
  --INSERT DBPETROPERU.DBO.BORRARBLADI (sql) values (@temp + 'TEMP' + @UserReemp + 'ANTES' + @Vsql+ ' ALGO ' + @ovaFilter);
 	            
END	

--== TD_CE_PndAprobar (despachos pnd de aprobar)

IF @iinIdDataSource IN (1008) BEGIN

          
      SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE Registro = ' + '''' + @ivaUser + ''''
      
      IF @UserReemp IS NOT NULL AND @UserReemp <> ''
            SET @Vsql = @Vsql + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
 
 
      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_iCodigoDepAutorizador', @ClausulaOR out
      
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + @ClausulaOR 

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

--== TD_CE_Aprobadas (Despachos aprobados)

IF @iinIdDataSource IN (1009) BEGIN

	 SET @Vsql = 'SELECT CodigoCGC FROM DBPETROPERU.dbo.TR_RADICADOR_CGC WHERE Registro = ' + '''' + @ivaUser + '''' 	
					
     
      IF @UserReemp IS NOT NULL AND @UserReemp <> ''
            SET @Vsql = @Vsql + ' OR UPPER(Registro) IN (' + '''' + @UserReemp + '''' + ')' 
 
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


IF @iinIdDataSource IN (1010) BEGIN
	SET @ovaFilter = ' ( s_RegistroRedactor IN ( ' + '''' + @UserReemp + '''' + ') OR  s_RegistroRedactor = ' + '''' + @ivaUser + '''' + ')' 
	--11.-
	--SET @ovaFilter = ' ( s_RegistroRedactor IN ( ' + '''' + @UserReemp + '''' + ') OR  s_RegistroRedactor = ' + '''' + @ivaUser + '''' + ')' 
	RETURN
END



/* Documentos para Aprobar
	Solo accede el Jefe de la Dependencia o su reemplazante para Acciones distintas a Dar Visto. El Gestor puede ver pero no hacer acciones.
	Solo accede el usuario al que se le pido el visto para acciones de Dar Visto
	
*/

IF @iinIdDataSource IN (1011) BEGIN
	-- Determina la dependencia del usuario y la dependencia del usuario al que reemplaza.
	
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE  ( Registro = ' + '''' + @ivaUser + '''' +
				 ' OR Registro IN ( ' + '''' + @UserReemp + '''' + ')) '	
					

      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + '((' + @ClausulaOR + ') AND TD_sAccion <> ' + '''' + 'DAR VISTO' + '''' + ') OR ' 
			SET @ovaFilter = @ovaFilter + ' ((sRegistroVisto = ' + '''' + LOWER(@ivaUser) + '''' + ' OR sRegistroVisto IN (' + '''' + @UserReemp + '''' + ' ) OR sRegistroVisto =' + '''' + UPPER(@ivaUser) + '''' + ' OR sRegistroVisto IN (' + '''' + @UserReemp + '''' + ')) AND TD_sAccion = ' + '''' + 'DAR VISTO' + '''' + ')'


	-- ** jefe de otras dependencias
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TD_JEFES_VARIAS_DEP WHERE Registro = ' + '''' + @ivaUser + ''''
     
     EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_CodigoDepDest', @ClausulaOR out
 
     IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + ' OR ' + @ClausulaOR 


	--  Determina Gestor
	--EXEC DBPETROPERU.dbo.sic_sp_obtener_si_es_jefe @ivaUser, @MJefe out
	
	--IF @MJefe = 'SI' BEGIN

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

IF @iinIdDataSource IN (1012) BEGIN
	-- Determina la dependencia del usuario y la dependencia del usuario al que reemplaza.
	
	SELECT @UserReemp = UPPER( COALESCE(@UserReemp +''',''','') + CDUsuarioSal )-- CDUsuarioEnt
	FROM AP8DB.dbo.TAP8_LPA_REEMPLAZOS
	WHERE CDUsuarioSal = @ivaUser AND FEInicio <= convert(date, convert(char, GETDATE(), 103), 103)
	 AND FEFin >= convert(date, convert(char, GETDATE(), 103), 103)
		
	 SET @Vsql = 'SELECT CodigoDependencia FROM DBPETROPERU.dbo.TV_DEPENDENCIAS WHERE  ( Registro = ' + '''' + @ivaUser + '''' +
				 ' OR Registro IN (' + '''' + @UserReemp + '''' + ') ) '	
					

      EXEC AP8DB.dbo.SP_LPA_ARMA_CLAUSULA_OR @Vsql out, 'TD_iCodigoDepOrig', @ClausulaOR out
 
      IF @ClausulaOR IS NOT NULL AND @ClausulaOR <> ''
            SET @ovaFilter = @ovaFilter + '(' + @ClausulaOR + ')'  + ' OR s_RegistroRedactor = ' + '''' + @ivaUser + '''' + ' OR s_RegistroRedactor IN (' + '''' + @UserReemp + '''' + ')'
      ELSE
			SET @ovaFilter = @ovaFilter + 's_RegistroRedactor = ' + '''' + @ivaUser + '''' + ' OR s_RegistroRedactor IN (' + '''' + @UserReemp + '''' +')'
                 
      
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



