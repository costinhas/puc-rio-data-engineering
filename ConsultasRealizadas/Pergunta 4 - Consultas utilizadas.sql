/* Variáveis auxiliares */
DECLARE total_respondentes, total_respondentes_brasil INT64;

SET (total_respondentes) = (
	SELECT AS STRUCT COUNT(*)
	FROM `sprint1-mvp.state_of_data.respostas` 
); 

SET (total_respondentes_brasil) = (
	SELECT AS STRUCT COUNT(*)
	FROM `sprint1-mvp.state_of_data.respostas` 
	WHERE MORA_NO_BRASIL = true
	AND TEMPO_EXPERIENCIA_DADOS is not null
	AND TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
); 







/* Visão geral da satisfação com a empresa atual */
SELECT 	SATISFACAO_EMPRESA_ATUAL,
				COUNT(*) as Total,
				ROUND((COUNT(*)/total_respondentes_brasil)*100, 2) as Percentual
FROM    `sprint1-mvp.state_of_data.respostas` 
WHERE   MORA_NO_BRASIL = true
AND     TEMPO_EXPERIENCIA_DADOS is not null
AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
GROUP BY SATISFACAO_EMPRESA_ATUAL;







/* Visão dos motivos de insatisfação com a empresa atual */
WITH INSATISFEITOS AS (
		SELECT 	
				COUNTIF(INSATISFACAO_FALTA_OPORTUNIDADE_CRESCIMENTO = TRUE) as FALTA_OPORTUNIDADE_CRESCIMENTO,
				COUNTIF(INSATISFACAO_SALARIO_BAIXO = TRUE) as SALARIO_BAIXO,
				COUNTIF(INSATISFACAO_RELACAO_GESTOR = TRUE) as RELACAO_GESTOR,
				COUNTIF(INSATISFACAO_DESEJO_OUTRA_AREA = TRUE) as DESEJO_OUTRA_AREA,
				COUNTIF(INSATISFACAO_POUCOS_BENEFICIOS = TRUE) as POUCOS_BENEFICIOS,
				COUNTIF(INSATISFACAO_CLIMA_TRABALHO = TRUE) as CLIMA_TRABALHO,
				COUNTIF(INSATISFACAO_FALTA_MATURIDADE_ANALITICA = TRUE) as FALTA_MATURIDADE_ANALITICA
		FROM    `sprint1-mvp.state_of_data.respostas` 
		WHERE   MORA_NO_BRASIL = true
		AND     TEMPO_EXPERIENCIA_DADOS is not null
		AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
		AND 	SATISFACAO_EMPRESA_ATUAL = false
)
SELECT 	MOTIVO_INSATISFACAO,
				RESPONDENTES,
				ROUND((RESPONDENTES/total_respondentes_brasil)*100, 2) as PERCENTUAL 
FROM INSATISFEITOS
UNPIVOT(RESPONDENTES 
				FOR MOTIVO_INSATISFACAO IN 
						(FALTA_OPORTUNIDADE_CRESCIMENTO,
						SALARIO_BAIXO,
						RELACAO_GESTOR,
						DESEJO_OUTRA_AREA,
						POUCOS_BENEFICIOS,
						CLIMA_TRABALHO,
						FALTA_MATURIDADE_ANALITICA)
		)
ORDER BY RESPONDENTES DESC;