SELECT
dfa.[DFA_DOCUMENT].DOCUMENTNR,
dfa.[DFA_ADMINISTRATIE].OMSCHRIJVING AS Werkmaatschappij,
dfa.[DFA_DOCUMENTREGEL].ROUTECODE,
dfa.[DFA_DOCUMENT].[EXTERNE_REFERENTIE],
dfa.[DFA_DOCUMENT].DOCUMENTDATUM,
dfa.[DFA_DOCUMENT].BRUTOBEDRAG,
dfa.[DFA_DOCUMENT].INBOEKDATUM,
dfa.[DFA_RELATIE].NAAM,
dfa.[DFA_DOCUMENT].[MUTATIE_DOOR],
dfa.[WMS_GEBRCODE].[GEBR_OMS],
dfa.[WMS_SSTAP].[STAP_OMS],
dfa.[WMS_SSTAP].[ACTIE_SYS],
dfa.[WMS_STAP].STAPNR,
dfa.[WMS_SSTAP].STAPCODE,
dfa.[WMS_SSTAP].PROCCODE,
dfa.[WMS_STAP].DDINGANG,
dfa.[DFA_DOCUMENTREGEL].MEDEWERKER,
dfa.[DFA_GEBRUIKER].NAAM AS Gebruiker,
dfa.[DFA_KOSTENPLAATS].CODE AS Kostenplaats,
dfa.[DFA_KOSTENPLAATS].OMSCHRIJVING AS [Kpl_omschrijving],
dfa.[DFA_DOCUMENT].CREATIEDATUM,
dfa.[DFA_DOCUMENT].[CREATIE_DOOR],
dfa.[DFA_DOCUMENT].INBOEKER
FROM
dfa.[DFA_DOCUMENT]
JOIN dfa.[DFA_ADMINISTRATIE]
ON dfa.[DFA_DOCUMENT].[ID_ADMINISTRATIE] = dfa.[DFA_ADMINISTRATIE].[ID_ADMINISTRATIE] 
JOIN dfa.[DFA_RELATIE]
ON dfa.[DFA_RELATIE].[ID_RELATIE] = dfa.[DFA_DOCUMENT].[ID_RELATIE] 
JOIN dfa.[DFA_DOCUMENTREGEL]
ON dfa.[DFA_DOCUMENT].DOCUMENTNR = dfa.[DFA_DOCUMENTREGEL].DOCUMENTNR 
JOIN dfa.[WMS_STAP]
ON dfa.[DFA_DOCUMENTREGEL].REGELNR = dfa.[WMS_STAP].[OBJECT_KEY] 
JOIN dfa.[WMS_SSTAP]
ON dfa.[WMS_SSTAP].PROCCODE = dfa.[WMS_STAP].PROCCODE
AND dfa.[WMS_SSTAP].STAPCODE = dfa.[WMS_STAP].STAPCODE 
JOIN dfa.[WMS_GEBRCODE]
ON dfa.[WMS_GEBRCODE].GEBRCODE = dfa.[WMS_STAP].GEBRCODE 
LEFT JOIN dfa.[DFA_GEBRUIKER]
ON dfa.[DFA_GEBRUIKER].[ID_GEBRUIKER] = dfa.[DFA_DOCUMENTREGEL].[ID_GRBR] 
LEFT JOIN dfa.[DFA_KOSTENPLAATS]
ON dfa.[DFA_KOSTENPLAATS].[ID_KSTP] = dfa.[DFA_DOCUMENTREGEL].[ID_KSTP]
WHERE
dfa.[DFA_DOCUMENT].[EXTERNE_REFERENTIE] = 'F1007263'
ORDER BY
dfa.[WMS_STAP].DDINGANG ASC