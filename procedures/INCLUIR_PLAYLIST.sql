CREATE DEFINER=`dba`@`%` PROCEDURE `INCLUIR_PLAYLIST`(OUT P_ID_PLAYLIST INT,
													  IN  P_ID_USUARIO  INT,
                                                      IN  P_PLA_NOME    VARCHAR(255),
													  IN  P_COMMIT      CHAR(1),
													  OUT P_OK 	        CHAR(1),
													  OUT P_RETORNO     VARCHAR(2000))
INCLUIR_PLAYLIST:BEGIN

CALL VALIDA_CAMPO_OBRIGATORIO(P_PLA_NOME, 'PLAYLIST', 'PLA_NOME', P_OK, P_RETORNO);

     IF P_OK = 'N' THEN
        LEAVE INCLUIR_PLAYLIST;
	 END IF;

CALL VALIDA_USUARIO(P_ID_USUARIO, 'USUARIO', P_OK, P_RETORNO);

     IF P_OK = 'N' THEN
        LEAVE INCLUIR_PLAYLIST;
	 END IF;

   
   -- VALIDA SE USUÁRIO JÁ POSSUI A MESMA PLAYLIST
   SELECT COUNT(1)
	    INTO @V_COUNT
     FROM PLAYLIST P
	WHERE P.ID_USUARIO = P_ID_USUARIO
	  AND UPPER(TRIM(P.PLA_NOME)) = UPPER(TRIM(P_PLA_NOME));

 IF @V_COUNT > 0 THEN
    CALL MSG_ERRO('PLAYLIST_USUARIO_EXISTE', P_PLA_NOME, NULL, NULL, NULL, NULL, P_OK, P_RETORNO);
	      -- Você já possui a playlist :param1.
          
          LEAVE INCLUIR_PLAYLIST;
          
 END IF;
  
   -- INCLUIR PLAYLIST
   INSERT INTO PLAYLIST 
			 (ID_USUARIO, 
              PLA_NOME)
	  VALUES (P_ID_USUARIO, 
              P_PLA_NOME);

CALL MSG_SUCESSO('INCLUIR_PLAYLIST', P_PLA_NOME, NULL, NULL, NULL, NULL, P_OK, P_RETORNO);  
				-- A playlist :param1 foi incluída com sucesso.
                
                IF P_OK = 'N' THEN
                   LEAVE INCLUIR_PLAYLIST;
                END IF;


IF IFNULL(P_COMMIT, 'N') = 'S'THEN
 COMMIT;
END IF;

    -- RETORNA ID DA PLAYLIST INCLUÍDA
SET P_ID_PLAYLIST := LAST_INSERT_ID();

END