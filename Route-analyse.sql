SELECT
Werkmaatschappij,
Relatie,
Werkmaatschappij,
Factuurdatum,
ExactBetaaltermijn,
Vervaldatum,
ExtReferentie,
Factuurbedrag,
Inboeker,
Budgethouder,
Interval
/*Rownr,
Resterend*/


FROM
(SELECT
dfa.[DFA_ADMINISTRATIE].OMSCHRIJVING AS Werkmaatschappij,
dfa.[DFA_RELATIE].NAAM AS Relatie,
CAST(dfa.[DFA_DOCUMENT].DOCUMENTDATUM AS DATE) AS Factuurdatum,

case dfa.[DFA_RELATIE].BETAALTERMIJN
	when 'GR' then 50
	else dfa.[DFA_RELATIE].BETAALTERMIJN
end AS ExactBetaaltermijn,

CAST(dfa.[DFA_DOCUMENT].DOCUMENTDATUM +
(case dfa.[DFA_RELATIE].BETAALTERMIJN
when 'GR' then 50
else dfa.[DFA_RELATIE].BETAALTERMIJN
end) AS DATE) AS Vervaldatum,

dfa.[DFA_DOCUMENT].[EXTERNE_REFERENTIE] AS ExtReferentie,
dfa.[DFA_DOCUMENT].BRUTOBEDRAG AS Factuurbedrag,
dfa.[DFA_DOCUMENT].INBOEKER AS Inboeker,

ROW_NUMBER() over(PARTITION BY dfa.[DFA_DOCUMENT].DOCUMENTNR ORDER BY dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].ID ASC) AS Rownr,
dfa.[WMS_GEBRCODE].[GEBR_OMS] AS Budgethouder,
CAST(dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].CREATIONDATE - dfa.[DFA_DOCUMENT].DOCUMENTDATUM AS INT) AS Interval,

/*dfa.[DFA_DOCUMENT].DOCUMENTNR,
dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].ID, */

CAST(dfa.[DFA_DOCUMENT].DOCUMENTDATUM +
(case dfa.[DFA_RELATIE].BETAALTERMIJN
when 'GR' then 50
else dfa.[DFA_RELATIE].BETAALTERMIJN
end) - dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].CREATIONDATE AS INT) AS Resterend

FROM
dfa.[DFA_DOCUMENT]
JOIN dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT]
ON dfa.[DFA_DOCUMENT].DOCUMENTNR = dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].DOCUMENTNR
JOIN dfa.[WMS_GEBRCODE]
ON dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].GEBRCODE = dfa.[WMS_GEBRCODE].GEBRCODE
JOIN dfa.[DFA_ADMINISTRATIE]
ON dfa.[DFA_DOCUMENT].[ID_ADMINISTRATIE] = dfa.[DFA_ADMINISTRATIE].[ID_ADMINISTRATIE]
JOIN dfa.[DFA_RELATIE]
ON dfa.[DFA_DOCUMENT].[ID_RELATIE] = dfa.[DFA_RELATIE].[ID_RELATIE]
WHERE
dfa.[DFA_DOCUMENT].DOCUMENTNR IN (500,501,502)
) AS SUB

PIVOT
(
SUM(Resterend)
FOR Rownr IN ([1],[2],[3])
) AS PVT




ORDER BY
dfa.[DFA_DOCUMENT].DOCUMENTNR ASC,
dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].ID ASC


























DECLARE @teller int = 0;


SELECT
dfa.[DFA_ADMINISTRATIE].OMSCHRIJVING AS Werkmaatschappij,
dfa.[DFA_RELATIE].NAAM,
dfa.[DFA_ADMINISTRATIE].OMSCHRIJVING,

CAST(dfa.[DFA_DOCUMENT].DOCUMENTDATUM AS DATE) AS Factuurdatum,

case dfa.[DFA_RELATIE].BETAALTERMIJN
	when 'GR' then 50
	else dfa.[DFA_RELATIE].BETAALTERMIJN
end AS ExactBetaaltermijn,

CAST(dfa.[DFA_DOCUMENT].DOCUMENTDATUM +
(case dfa.[DFA_RELATIE].BETAALTERMIJN
when 'GR' then 50
else dfa.[DFA_RELATIE].BETAALTERMIJN
end) AS DATE) AS Vervaldatum,

dfa.[DFA_DOCUMENT].[EXTERNE_REFERENTIE],
dfa.[DFA_DOCUMENT].BRUTOBEDRAG,
dfa.[DFA_DOCUMENT].INBOEKER,
dfa.[WMS_GEBRCODE].[GEBR_OMS],
CAST(dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].CREATIONDATE - dfa.[DFA_DOCUMENT].DOCUMENTDATUM AS INT) AS Interval,

dfa.[DFA_DOCUMENT].DOCUMENTNR,
dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].ID,

/* ROW_NUMBER() over(ORDER BY dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].ID ASC) AS Rownr, */
CAST(dfa.[DFA_DOCUMENT].DOCUMENTDATUM +
(case dfa.[DFA_RELATIE].BETAALTERMIJN
when 'GR' then 50
else dfa.[DFA_RELATIE].BETAALTERMIJN
end) - dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].CREATIONDATE AS INT) AS Resterend

FROM
dfa.[DFA_DOCUMENT]
JOIN dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT]
ON dfa.[DFA_DOCUMENT].DOCUMENTNR = dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].DOCUMENTNR
JOIN dfa.[WMS_GEBRCODE]
ON dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].GEBRCODE = dfa.[WMS_GEBRCODE].GEBRCODE
JOIN dfa.[DFA_ADMINISTRATIE]
ON dfa.[DFA_DOCUMENT].[ID_ADMINISTRATIE] = dfa.[DFA_ADMINISTRATIE].[ID_ADMINISTRATIE]
JOIN dfa.[DFA_RELATIE]
ON dfa.[DFA_DOCUMENT].[ID_RELATIE] = dfa.[DFA_RELATIE].[ID_RELATIE]
WHERE
dfa.[DFA_DOCUMENT].DOCUMENTNR IN (500,501,502)

ORDER BY
dfa.[DFA_DOCUMENT].DOCUMENTNR ASC,
dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].ID ASC










-- 1
Select * FROM
(SELECT
ROW_NUMBER()
over(ORDER BY dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].ID ASC) AS Rownr,

dfa.[WMS_GEBRCODE].[GEBR_OMS] /*,
CAST(dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].CREATIONDATE - DOCNR.DOCUMENTDATUM AS INT) AS Interval,

CAST(DOCNR.DOCUMENTDATUM +
(case dfa.[DFA_RELATIE].BETAALTERMIJN
when 'GR' then 50
else dfa.[DFA_RELATIE].BETAALTERMIJN
end) - dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].CREATIONDATE AS INT) AS Resterend */


FROM
dfa.[DFA_DOCUMENT] AS DOCNR
JOIN dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT]
ON DOCNR.DOCUMENTNR = dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].DOCUMENTNR
JOIN dfa.[WMS_GEBRCODE]
ON dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].GEBRCODE = dfa.[WMS_GEBRCODE].GEBRCODE
JOIN dfa.[DFA_ADMINISTRATIE]
ON DOCNR.[ID_ADMINISTRATIE] = dfa.[DFA_ADMINISTRATIE].[ID_ADMINISTRATIE]
JOIN dfa.[DFA_RELATIE]
ON DOCNR.[ID_RELATIE] = dfa.[DFA_RELATIE].[ID_RELATIE]

where
DOCNR.DOCUMENTNR = 6 /*dfa.[DFA_DOCUMENT].DOCUMENTNR */
/* AND Rownr = 1 */
) AS SQA






-- 2



-- 3



-- 4






JOIN dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT]
ON dfa.[DFA_DOCUMENT].DOCUMENTNR = dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].DOCUMENTNR
JOIN dfa.[WMS_GEBRCODE]
ON dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].GEBRCODE = dfa.[WMS_GEBRCODE].GEBRCODE
JOIN dfa.[DFA_ADMINISTRATIE]
ON dfa.[DFA_DOCUMENT].[ID_ADMINISTRATIE] = dfa.[DFA_ADMINISTRATIE].[ID_ADMINISTRATIE]
JOIN dfa.[DFA_RELATIE]
ON dfa.[DFA_DOCUMENT].[ID_RELATIE] = dfa.[DFA_RELATIE].[ID_RELATIE]
WHERE
dfa.[DFA_DOCUMENT].DOCUMENTNR = 6
ORDER BY
dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].ID ASC






/*

SELECT
ROW_NUMBER()
over(ORDER BY dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].ID ASC) AS [Rownr],

dfa.[WMS_GEBRCODE].[GEBR_OMS],
CAST(dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].CREATIONDATE - dfa.[DFA_DOCUMENT].DOCUMENTDATUM AS INT) AS Interval,

CAST(dfa.[DFA_DOCUMENT].DOCUMENTDATUM +
(case dfa.[DFA_RELATIE].BETAALTERMIJN
when 'GR' then 50
else dfa.[DFA_RELATIE].BETAALTERMIJN
end) - dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].CREATIONDATE AS INT) AS Resterend


FROM
dfa.[DFA_DOCUMENT]
JOIN dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT]
ON dfa.[DFA_DOCUMENT].DOCUMENTNR = dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].DOCUMENTNR
JOIN dfa.[WMS_GEBRCODE]
ON dfa.[DFA_SUBSCRIPTION_PROFILE_EVENT].GEBRCODE = dfa.[WMS_GEBRCODE].GEBRCODE
JOIN dfa.[DFA_ADMINISTRATIE]
ON dfa.[DFA_DOCUMENT].[ID_ADMINISTRATIE] = dfa.[DFA_ADMINISTRATIE].[ID_ADMINISTRATIE]
JOIN dfa.[DFA_RELATIE]
ON dfa.[DFA_DOCUMENT].[ID_RELATIE] = dfa.[DFA_RELATIE].[ID_RELATIE]

where dfa.[DFA_DOCUMENT].DOCUMENTNR = 6 and Rownr = 3

*/
