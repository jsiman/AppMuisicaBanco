CREATE DEFINER=`dba`@`%` PROCEDURE `MSG_ERRO`(IN  P_TEX_IDENTIFICADOR VARCHAR(30),
											  IN  P_PARAM1            VARCHAR(100),
											  IN  P_PARAM2            VARCHAR(100),
											  IN  P_PARAM3            VARCHAR(100),
											  IN  P_PARAM4            VARCHAR(100),
											  IN  P_PARAM5            VARCHAR(100),
                                              OUT P_OK	              CHAR(1),
                                              OUT P_RETORNO	          VARCHAR(2000))
BEGIN

    
DECLARE V_MSGERRO         VARCHAR(2000);

	  -- PEGA A MSG DE ERRO    
      SET V_MSGERRO = MSG_TEXTO(P_TEX_IDENTIFICADOR);
    
      -- SUBSTITUI OS PARÂMETROS
      IF P_PARAM1 IS NOT NULL THEN
       SET V_MSGERRO = REPLACE(V_MSGERRO, ':param1', P_PARAM1);
      END IF;
      IF P_PARAM2 IS NOT NULL THEN
       SET V_MSGERRO = REPLACE(V_MSGERRO, ':param2', P_PARAM2);
      END IF;
      IF P_PARAM3 IS NOT NULL THEN
       SET V_MSGERRO = REPLACE(V_MSGERRO, ':param3', P_PARAM3);
      END IF;
      IF P_PARAM4 IS NOT NULL THEN
       SET V_MSGERRO = REPLACE(V_MSGERRO, ':param4', P_PARAM4);
      END IF;
      IF P_PARAM5 IS NOT NULL THEN
       SET V_MSGERRO = REPLACE(V_MSGERRO, ':param5', P_PARAM5);
      END IF;
	
    
    IF V_MSGERRO IS NULL THEN
      SET V_MSGERRO = CONCAT('ERRO ! MENSAGEM DE ERRO NAO CADASTRADA PARA O PARAMETRO: ', P_TEX_IDENTIFICADOR);
    END IF;
    
    SET P_OK	  = 'N';
    SET P_RETORNO = V_MSGERRO;
    

END