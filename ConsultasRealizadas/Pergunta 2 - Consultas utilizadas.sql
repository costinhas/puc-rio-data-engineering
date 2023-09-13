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

SELECT total_respondentes, total_respondentes_brasil, total_respondentes_brasil/total_respondentes as Percentual
FROM (SELECT SESSION_USER());







/* Distribuição dos respondentes entre cargos gerenciais e não gerenciais */
	SELECT  'NÃO GESTOR' as Nivel_Cargo, 
				COUNT(*) as Total,
				TRUNC((COUNT(*)/total_respondentes_brasil)*100) as Percentual
	FROM    `sprint1-mvp.state_of_data.respostas` 
	WHERE   MORA_NO_BRASIL = true
	AND     TEMPO_EXPERIENCIA_DADOS is not null
	AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
	AND     CARGO_ATUAL_COMO_NAO_GESTOR is not null
	AND     CARGO_ATUAL_COMO_GESTOR is null;
UNION ALL
	SELECT  'GESTOR' as Nivel_Cargo, 
				COUNT(*) as Total,
				TRUNC((COUNT(*)/total_respondentes_brasil)*100) as Percentual
	FROM    `sprint1-mvp.state_of_data.respostas` 
	WHERE   MORA_NO_BRASIL = true
	AND     TEMPO_EXPERIENCIA_DADOS is not null
	AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
	AND     CARGO_ATUAL_COMO_NAO_GESTOR is null
	AND     CARGO_ATUAL_COMO_GESTOR is not null;
	
	
	


/* Principais cargos ou funções ocupadas pelos gestores */
SELECT  CARGO_ATUAL_COMO_GESTOR, 
			COUNT(*) as Total,
			TRUNC((COUNT(*)/total_respondentes_brasil)*100) as Percentual
FROM    `sprint1-mvp.state_of_data.respostas` 
WHERE   MORA_NO_BRASIL = true
AND     TEMPO_EXPERIENCIA_DADOS is not null
AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
AND     CARGO_ATUAL_COMO_NAO_GESTOR is null
AND     CARGO_ATUAL_COMO_GESTOR is not null
GROUP BY CARGO_ATUAL_COMO_GESTOR
ORDER BY COUNT(*) desc;





/* Principais cargos ou funções ocupadas pelos respondentes que não são gestores */
SELECT  CARGO_ATUAL_COMO_NAO_GESTOR, 
			COUNT(*) as Total,
			TRUNC((COUNT(*)/total_respondentes_brasil)*100) as Percentual
FROM    `sprint1-mvp.state_of_data.respostas` 
WHERE   MORA_NO_BRASIL = true
AND     TEMPO_EXPERIENCIA_DADOS is not null
AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
AND     CARGO_ATUAL_COMO_NAO_GESTOR is not null
AND     CARGO_ATUAL_COMO_GESTOR is null
GROUP BY CARGO_ATUAL_COMO_NAO_GESTOR
ORDER BY COUNT(*) desc