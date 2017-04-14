SELECT
	*

FROM
  (
    SELECT
      dfa.[DFA_V_RAPPORTAGES].gebruiker AS [Gebruiker],
     CASE
        when Cast(dfa.[DFA_V_RAPPORTAGES].DOCUMENTDATUM - getdate() as int) +
        (case
          when dfa.[DFA_RELATIE].BETAALTERMIJN = 'GR' then 50
          else dfa.[DFA_RELATIE].BETAALTERMIJN
        end)  <= 0 then 'Telaat'
        ELSE 'Tijdig'
      End AS [Vervallen],
      dfa.[DFA_V_RAPPORTAGES].documentnr AS Documentnummer



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

PIVOT
  (
    COUNT(Documentnummer)
    FOR [Vervallen] IN (Telaat, Tijdig)
  ) AS PivotTable
