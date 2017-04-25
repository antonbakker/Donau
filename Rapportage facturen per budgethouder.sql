SELECT
  Gebruiker,
  count(Documentnummer)
  [Nee] AS NietVervallen


FROM
  (
    SELECT
      Cast(dfa.[DFA_V_RAPPORTAGES].DOCUMENTDATUM - getdate() as int) +
        (case
          when dfa.[DFA_RELATIE].BETAALTERMIJN = 'GR' then 50
          else dfa.[DFA_RELATIE].BETAALTERMIJN
        end) AS Resteert,
      dfa.[DFA_V_RAPPORTAGES].[stap_oms] AS Stap,
      dfa.[DFA_V_RAPPORTAGES].gebruiker AS Gebruiker,
      Cast(getdate() - dfa.[DFA_V_RAPPORTAGES].ddingang as int) AS DagenBudgethouder,
      datepart(yyyy,dfa.[DFA_V_RAPPORTAGES].DOCUMENTDATUM) AS Boekjaar,
      datepart(mm,dfa.[DFA_V_RAPPORTAGES].DOCUMENTDATUM) AS BTWperiode,
      dfa.[DFA_RELATIE].NAAM AS Relatie,
      dfa.[DFA_V_RAPPORTAGES].DOCUMENTDATUM AS Factuurdatum,
      dfa.[DFA_V_RAPPORTAGES].[EXTERNE_REFERENTIE] AS ExterneReferentie,
      dfa.[DFA_V_RAPPORTAGES].BRUTOBEDRAG AS [Factuur_Brutobedrag],
      dfa.[DFA_V_RAPPORTAGES].BTWBEDRAG AS [Factuur_BTWbedrag],
      dfa.[DFA_V_RAPPORTAGES].NETTOBEDRAG AS [Factuur_Nettobedrag],
      dfa.[DFA_ADMINISTRATIE].OMSCHRIJVING AS Werkmaatschappij,
      dfa.[DFA_PERIODE].CODE AS Periode,
      dfa.[DFA_V_RAPPORTAGES].DDRAPPEL AS Rappeldatum,
      datepart(mm,dfa.[DFA_V_RAPPORTAGES].DOCUMENTDATUM) AS [BTW_aangiftevak],
      CASE
        when Cast(dfa.[DFA_V_RAPPORTAGES].DOCUMENTDATUM - getdate() as int) +
        (case
          when dfa.[DFA_RELATIE].BETAALTERMIJN = 'GR' then 50
          else dfa.[DFA_RELATIE].BETAALTERMIJN
        end)  <= 0 then 'Ja'
        ELSE 'Nee'
      End AS Vervallen,
      dfa.[DFA_V_RAPPORTAGES].aantalnotities AS Notities,
      dfa.[DFA_V_RAPPORTAGES].documentnr AS Documentnummer,
      dfa.[DFA_V_RAPPORTAGES].stapnr AS STAPNR,
      dfa.[DFA_V_RAPPORTAGES].hasimage AS Image,
      case
        when dfa.[WMS_STAP].DDEIND is null then cast(getdate() - dfa.[WMS_STAP].DDINGANG as int)
        else cast(dfa.[WMS_STAP].DDEIND - dfa.[WMS_STAP].DDINGANG as int)
        end as [ActiefDagen],
      dfa.[WMS_STAP].GEBRCODE as [VorigeBudgethouder]

    FROM
      dfa.[DFA_ADMINISTRATIE]
      RIGHT JOIN dfa.[DFA_V_RAPPORTAGES] ON dfa.[DFA_ADMINISTRATIE].[ID_ADMINISTRATIE] = dfa.[DFA_V_RAPPORTAGES].[ID_ADMINISTRATIE]
      LEFT JOIN dfa.[DFA_DAGBOEK] ON dfa.[DFA_DAGBOEK].[ID_DAGBOEK] = dfa.[DFA_V_RAPPORTAGES].[ID_DAGBOEK]
      LEFT JOIN dfa.[DFA_RELATIE] ON dfa.[DFA_RELATIE].[ID_RELATIE] = dfa.[DFA_V_RAPPORTAGES].[ID_RELATIE]
      LEFT JOIN dfa.[DFA_VALUTA] ON dfa.[DFA_VALUTA].[ID_VALUTA] = dfa.[DFA_V_RAPPORTAGES].[ID_VALUTA]
      LEFT JOIN dfa.[DFA_PERIODE] ON dfa.[DFA_PERIODE].[ID_PERIODE] = dfa.[DFA_V_RAPPORTAGES].[ID_PERIODE]
      LEFT JOIN dfa.[DFA_BTWCODE] ON dfa.[DFA_BTWCODE].[ID_BTWCODE] = dfa.[DFA_V_RAPPORTAGES].[ID_BTWCODE]
      JOIN dfa.[WMS_STAP] ON dfa.[DFA_V_RAPPORTAGES].STAPNR = dfa.[WMS_STAP].STAPNR
  ) AS QVervallen

Group by
  Gebruiker
