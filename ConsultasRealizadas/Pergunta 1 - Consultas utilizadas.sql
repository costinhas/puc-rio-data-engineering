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






/* Nível de ensino dos profissionais que trabalham no Brasil e possuem experiência em dados */
SELECT  NIVEL_ENSINO, 
		    COUNT(*) as Total,
		    TRUNC((COUNT(*)/total_respondentes_brasil)*100) as Percentual
FROM    `sprint1-mvp.state_of_data.respostas` 
WHERE   MORA_NO_BRASIL = true
AND     TEMPO_EXPERIENCIA_DADOS is not null
AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
GROUP BY NIVEL_ENSINO;






/* Quantidade de respondentes que possuem educação formal */
SELECT CASE 
        WHEN NIVEL_ENSINO = 'Graduação/Bacharelado' then 'Graduação / Pós / Mestrado / Doutorado / PHD'
        WHEN NIVEL_ENSINO = 'Pós-graduação' then 'Graduação / Pós / Mestrado / Doutorado / PHD'
        WHEN NIVEL_ENSINO = 'Mestrado' then 'Graduação / Pós / Mestrado / Doutorado / PHD'
        WHEN NIVEL_ENSINO = 'Doutorado ou Phd' then 'Graduação / Pós / Mestrado / Doutorado / PHD'
      ELSE
        NIVEL_ENSINO
      END as Escolaridade,
		    COUNT(*) as Total,
		    TRUNC((COUNT(*)/total_respondentes_brasil)*100) as Percentual
FROM    `sprint1-mvp.state_of_data.respostas` 
WHERE   MORA_NO_BRASIL = true
AND     TEMPO_EXPERIENCIA_DADOS is not null
AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
GROUP BY Escolaridade;







/* Áreas de atuação dos profissionais */
SELECT  AREA_FORMACAO,
		    COUNT(*) as Total,
		    TRUNC((COUNT(*)/total_respondentes_brasil)*100) as Percentual
FROM    `sprint1-mvp.state_of_data.respostas` 
WHERE   MORA_NO_BRASIL = true
AND     TEMPO_EXPERIENCIA_DADOS is not null
AND     TEMPO_EXPERIENCIA_DADOS <> 'Não tenho experiência na área de dados'
AND     NIVEL_ENSINO in ('Graduação/Bacharelado','Pós-graduação','Mestrado','Doutorado ou Phd')
GROUP BY AREA_FORMACAO
ORDER BY COUNT(*) DESC
