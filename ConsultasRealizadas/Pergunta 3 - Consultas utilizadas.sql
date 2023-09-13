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






/* Agrupamento por faixa salarial */
/* Criada subquery com Case para incluir uma ordenação forçada, por faixa salarial */
/* Este sequencial usado na ordenação é excluído na query principal, com a função SUBSTRING*/
SELECT	SUBSTRING(FAIXA_SALARIAL, 6) AS FAIXA_SALARIAL,
				Total,
				Percentual
FROM (
	SELECT CASE FAIXA_SALARIAL
						WHEN 'Menos de R$ 1.000/mês' 			THEN '01 - Menos de R$ 1.000/mês'
						WHEN 'de R$ 1.001/mês a R$ 2.000/mês' 	THEN '02 - de R$ 1.001/mês a R$ 2.000/mês'
						WHEN 'de R$ 2.001/mês a R$ 3.000/mês' 	THEN '03 - de R$ 2.001/mês a R$ 3.000/mês'
						WHEN 'de R$ 3.001/mês a R$ 4.000/mês' 	THEN '04 - de R$ 3.001/mês a R$ 4.000/mês'
						WHEN 'de R$ 4.001/mês a R$ 6.000/mês'   THEN '05 - de R$ 4.001/mês a R$ 6.000/mês'
						WHEN 'de R$ 6.001/mês a R$ 8.000/mês'   THEN '06 - de R$ 6.001/mês a R$ 8.000/mês'
						WHEN 'de R$ 8.001/mês a R$ 12.000/mês'  THEN '07 - de R$ 8.001/mês a R$ 12.000/mês'
						WHEN 'de R$ 12.001/mês a R$ 16.000/mês' THEN '08 - de R$ 12.001/mês a R$ 16.000/mês'
						WHEN 'de R$ 16.001/mês a R$ 20.000/mês' THEN '09 - de R$ 16.001/mês a R$ 20.000/mês'
						WHEN 'de R$ 20.001/mês a R$ 25.000/mês' THEN '10 - de R$ 20.001/mês a R$ 25.000/mês'
						WHEN 'de R$ 25.001/mês a R$ 30.000/mês' THEN '11 - de R$ 25.001/mês a R$ 30.000/mês'
						WHEN 'de R$ 30.001/mês a R$ 40.000/mês' THEN '12 - de R$ 30.001/mês a R$ 40.000/mês'
						WHEN 'Acima de R$ 40.001/mês' 			THEN '13 - Acima de R$ 40.001/mês'
						ELSE FAIXA_SALARIAL
					END AS FAIXA_SALARIAL,
				COUNT(*) as Total,
				TRUNC((COUNT(*)/total_respondentes_brasil)*100) as Percentual
	FROM    `sprint1-mvp.state_of_data.respostas` 
	WHERE   MORA_NO_BRASIL = true
	AND     TEMPO_EXPERIENCIA_DADOS is not null
	AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
	GROUP BY FAIXA_SALARIAL
	ORDER BY FAIXA_SALARIAL);




/* Agrupamento por nível de cargo atual e faixa salarial */
/* Criada subquery com Case para incluir uma ordenação forçada, por faixa salarial */
/* Este sequencial usado na ordenação é excluído na query principal, com a função SUBSTRING*/
SELECT	NIVEL_CARGO_ATUAL,
				SUBSTRING(FAIXA_SALARIAL, 6) AS FAIXA_SALARIAL,
				Total,
				Percentual
FROM (
	SELECT 	IFNULL(NIVEL_CARGO_ATUAL, "Gestor") as NIVEL_CARGO_ATUAL,
					CASE FAIXA_SALARIAL
						WHEN 'Menos de R$ 1.000/mês' 			THEN '01 - Até R$ 2.000/mês'
						WHEN 'de R$ 1.001/mês a R$ 2.000/mês' 	THEN '01 - Até R$ 2.000/mês'
						WHEN 'de R$ 2.001/mês a R$ 3.000/mês' 	THEN '02 - de R$ 2.001/mês a R$ 4.000/mês'
						WHEN 'de R$ 3.001/mês a R$ 4.000/mês' 	THEN '02 - de R$ 2.001/mês a R$ 4.000/mês'
						WHEN 'de R$ 4.001/mês a R$ 6.000/mês'   THEN '03 - de R$ 4.001/mês a R$ 6.000/mês'
						WHEN 'de R$ 6.001/mês a R$ 8.000/mês'   THEN '04 - de R$ 6.001/mês a R$ 8.000/mês'
						WHEN 'de R$ 8.001/mês a R$ 12.000/mês'  THEN '05 - de R$ 8.001/mês a R$ 12.000/mês'
						WHEN 'de R$ 12.001/mês a R$ 16.000/mês' THEN '06 - de R$ 12.001/mês a R$ 16.000/mês'
						WHEN 'de R$ 16.001/mês a R$ 20.000/mês' THEN '07 - de R$ 16.001/mês a R$ 20.000/mês'
						WHEN 'de R$ 20.001/mês a R$ 25.000/mês' THEN '08 - de R$ 20.001/mês a R$ 30.000/mês'
						WHEN 'de R$ 25.001/mês a R$ 30.000/mês' THEN '08 - de R$ 20.001/mês a R$ 30.000/mês'
						WHEN 'de R$ 30.001/mês a R$ 40.000/mês' THEN '09 - Acima de R$ 30.001/mês'
						WHEN 'Acima de R$ 40.001/mês' 			THEN '09 - Acima de R$ 30.001/mês'
						ELSE FAIXA_SALARIAL
					END AS FAIXA_SALARIAL,
				COUNT(*) as Total,
				TRUNC((COUNT(*)/total_respondentes_brasil)*100) as Percentual
	FROM    `sprint1-mvp.state_of_data.respostas` 
	WHERE   MORA_NO_BRASIL = true
	AND     TEMPO_EXPERIENCIA_DADOS is not null
	AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
	GROUP BY NIVEL_CARGO_ATUAL, FAIXA_SALARIAL
	ORDER BY NIVEL_CARGO_ATUAL, FAIXA_SALARIAL);
