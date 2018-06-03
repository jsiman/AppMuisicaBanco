CREATE DEFINER=`dba`@`%` PROCEDURE `VALIDA_CAMPO_OBRIGATORIO`(IN  P_VALUE   VARCHAR(255),
														      IN  P_TABELA  VARCHAR(30),
														      IN  P_CAMPO   VARCHAR(30),
                                                              OUT P_OK	    CHAR(1),
                                                              OUT P_RETORNO VARCHAR(2000))
BEGIN
     
     IF TRIM(P_VALUE) = '' THEN
       SET P_VALUE := NULL;
     END IF;
     
     IF P_VALUE IS NULL THEN
     
      -- PEGA O NOME DO CAMPO
      SELECT IFNULL(A.TAC_DESCRICAO, P_CAMPO)
        INTO P_CAMPO
        FROM TABELA TA, TABELA_CAMPO A
       WHERE TA.ID_TABELA = A.ID_TABELA
         AND TA.TAB_NOME = P_TABELA
         AND A.TAC_NOME = P_CAMPO;
         
      CALL MSG_ERRO('ERRO_CAMPO_OBRIGATORIO', P_CAMPO,NULL,NULL,NULL,NULL,P_OK,P_RETORNO);
      
	 ELSE
      
      CALL MSG_SUCESSO('SUCESSO_CAMPO_OBRIGATORIO', P_CAMPO, NULL, NULL, NULL, NULL, P_OK, P_RETORNO);
      
     END IF;
   
END