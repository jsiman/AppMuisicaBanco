CREATE DEFINER=`dba`@`%` PROCEDURE `EXCLUIR_PLAYLIST_MUSICA`(IN  P_ID_PLAYLIST_MUSICA INT,
		                                                     IN  P_ID_PLAYLIST 	      INT,
                                                             IN  P_ID_MUSICA	      INT,
															 IN  P_ID_USUARIO         INT,
													         IN  P_COMMIT             CHAR(1),
													         OUT P_OK 	              CHAR(1),
															 OUT P_RETORNO     		  VARCHAR(2000))
EXCLUIR_PLAYLIST_MUSICA:BEGIN

DECLARE V_PLA_NOME VARCHAR(255);
DECLARE V_MUS_NOME  VARCHAR(255);

CALL VALIDA_USUARIO(P_ID_USUARIO, 'USUARIO', P_OK, P_RETORNO);

	 IF P_OK = 'N' THEN
        LEAVE EXCLUIR_PLAYLIST_MUSICA;
     END IF;

CALL VALIDA_LOOKUP(P_ID_PLAYLIST_MUSICA, 'PLAYLIST_MUSICA', 'ID_PLAYLIST_MUSICA', P_OK, P_RETORNO);

	 IF P_OK = 'N' THEN
        LEAVE EXCLUIR_PLAYLIST_MUSICA;
     END IF;


CALL VALIDA_LOOKUP(P_ID_PLAYLIST, 'PLAYLIST', 'ID_PLAYLIST', P_OK, P_RETORNO);

	 IF P_OK = 'N' THEN
        LEAVE EXCLUIR_PLAYLIST_MUSICA;
     END IF;


CALL VALIDA_LOOKUP(P_ID_MUSICA, 'MUSICA', 'ID_MUSICA', P_OK, P_RETORNO);

	 IF P_OK = 'N' THEN
        LEAVE EXCLUIR_PLAYLIST_MUSICA;
     END IF;


   -- DADOS DA PLAYLIST
   SELECT P.PLA_NOME
	      INTO V_PLA_NOME
	  FROM PLAYLIST P
     WHERE P.ID_PLAYLIST = P_ID_PLAYLIST;
  
   -- VALIDA SE PLAYLIST PERTENCE AO MESMO USUÁRIO
   SELECT COUNT(1)
	    INTO @V_COUNT
     FROM PLAYLIST P
	WHERE P.ID_USUARIO   = P_ID_USUARIO
	  AND P.ID_PLAYLIST  = P_ID_PLAYLIST;
      
IF @V_COUNT = 0 THEN
    CALL MSG_ERRO('PLAYLIST_NAO_PERTENCE_USUARIO', V_PLA_NOME, NULL, NULL, NULL, NULL, P_OK, P_RETORNO);
	      -- A playlist :param1 não pertence ao seu usuário.
       
        LEAVE EXCLUIR_PLAYLIST_MUSICA;
        
END IF;

    -- DADOS DA MUSCIA
    SELECT M.MUS_NOME
		   INTO V_MUS_NOME
	  FROM MUSICA M
	 WHERE M.ID_MUSICA = P_ID_MUSICA;
     
   -- VALIDA SE MUSICA PERTENCE A PLAYLIST
   SELECT COUNT(1)
	    INTO @V_COUNT
     FROM PLAYLIST_MUSICA PM
	WHERE PM.ID_MUSICA   = P_ID_MUSICA
	  AND PM.ID_PLAYLIST = P_ID_PLAYLIST;
    
IF @V_COUNT = 0 THEN
   CALL MSG_ERRO('MUSICA_NAO_PERTENCE_PLAYLIST', V_MUS_NOME, V_PLA_NOME, NULL, NULL, NULL, P_OK, P_RETORNO);
	      -- A música :param1 não pertence a playlist :param2.
       
	     LEAVE EXCLUIR_PLAYLIST_MUSICA;
        
END IF;
      
  
   -- EXCLUIR PLAYLIST_MUSICA
  DELETE FROM PLAYLIST_MUSICA
		WHERE ID_PLAYLIST_MUSICA = P_ID_PLAYLIST_MUSICA;


CALL MSG_SUCESSO('EXCLUIR_PLAYLIST_MUSICA', V_MUS_NOME, V_PLA_NOME, NULL, NULL, NULL, P_OK, P_RETORNO);  
				-- A música :param1 foi excluída da playlist :param2 com sucesso.
                
	 IF P_OK = 'N' THEN
        LEAVE EXCLUIR_PLAYLIST_MUSICA;
     END IF;

IF IFNULL(P_COMMIT, 'N') = 'S'THEN
 COMMIT;
END IF;

END