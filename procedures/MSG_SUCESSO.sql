CREATE DEFINER=`dba`@`%` PROCEDURE `MSG_SUCESSO`(IN  P_TEX_IDENTIFICADOR VARCHAR(30),
												 IN  P_PARAM1            VARCHAR(100),
												 IN  P_PARAM2            VARCHAR(100),
												 IN  P_PARAM3            VARCHAR(100),
												 IN  P_PARAM4            VARCHAR(100),
												 IN  P_PARAM5            VARCHAR(100),
                                                 OUT P_OK	             CHAR(1),
                                                 OUT P_RETORNO	         VARCHAR(2000))
BEGIN

DECLARE V_MSGSUCESSO         VARCHAR(2000);

	  -- PEGA A MSG DE ERRO    
      SET V_MSGSUCESSO = MSG_TEXTO(P_TEX_IDENTIFICADOR);
    
      -- SUBSTITUI OS PARÂMETROS
      IF P_PARAM1 IS NOT NULL THEN
       SET V_MSGSUCESSO = REPLACE(V_MSGSUCESSO, ':param1', P_PARAM1);
      END IF;
      IF P_PARAM2 IS NOT NULL THEN
       SET V_MSGSUCESSO = REPLACE(V_MSGSUCESSO, ':param2', P_PARAM2);
      END IF;
      IF P_PARAM3 IS NOT NULL THEN
       SET V_MSGSUCESSO = REPLACE(V_MSGSUCESSO, ':param3', P_PARAM3);
      END IF;
      IF P_PARAM4 IS NOT NULL THEN
       SET V_MSGSUCESSO = REPLACE(V_MSGSUCESSO, ':param4', P_PARAM4);
      END IF;
      IF P_PARAM5 IS NOT NULL THEN
       SET V_MSGSUCESSO = REPLACE(V_MSGSUCESSO, ':param5', P_PARAM5);
      END IF;
	
      IF V_MSGSUCESSO IS NULL THEN
         
         SET P_RETORNO  = CONCAT('ERRO ! MENSAGEM DE SUCESSO NAO CADASTRADA PARA O PARAMETRO: ', P_TEX_IDENTIFICADOR);
         SET P_OK 	    = 'N';
      
		ELSE	
        
	     SET P_OK	   = 'S';
	     SET P_RETORNO = V_MSGSUCESSO;
         
	  END IF;
  
END