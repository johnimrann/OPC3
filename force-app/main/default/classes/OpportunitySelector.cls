/**
 * Classe sélecteur pour l'accès aux données des opportunités
 * Implémente le pattern Selector pour une meilleure séparation des responsabilités
 * et une meilleure maintenabilité du code
 * 
 * @author Votre Nom
 * @version 2.0
 * @since 2024-12-17
 */
public inherited sharing class OpportunitySelector {
    
    // Constantes pour les limites et paramètres de requête
    private static final Integer MAX_RECORDS = 1000;
    private static final String DEFAULT_SORT_FIELD = 'CloseDate';
    private static final String DEFAULT_SORT_ORDER = 'DESC';
    
    /**
     * Récupère les opportunités liées à un compte spécifique
     * @param accountId ID du compte pour lequel récupérer les opportunités
     * @return List<Opportunity> Liste des opportunités avec leurs champs pertinents
     * @throws IllegalArgumentException si l'ID du compte est null
     */
    public static List<Opportunity> getOpportunitiesByAccountId(Id accountId) {
        // Validation des entrées
        if (accountId == null) {
            throw new IllegalArgumentException('L\'ID du compte ne peut pas être null');
        }

        return Database.query(
            buildOpportunityQuery(accountId)
        );
    }
    
    /**
     * Construit la requête SOQL de manière dynamique et sécurisée
     * @param accountId ID du compte pour le filtrage
     * @return String Requête SOQL formatée
     */
    private static String buildOpportunityQuery(Id accountId) {
        return String.format(
            'SELECT {0} ' +
            'FROM Opportunity ' +
            'WHERE AccountId = :accountId ' +
            'ORDER BY {1} {2} ' +
            'LIMIT {3}',
            new List<String>{
                String.join(getSelectedFields(), ','),
                DEFAULT_SORT_FIELD,
                DEFAULT_SORT_ORDER,
                String.valueOf(MAX_RECORDS)
            }
        );
    }
    
    /**
     * Liste des champs à sélectionner dans la requête
     * Centralise la définition des champs pour faciliter la maintenance
     * @return List<String> Liste des champs à sélectionner
     */
    private static List<String> getSelectedFields() {
        return new List<String>{
            'Id',                  // Identifiant unique
            'Name',               // Nom de l'opportunité
            'Amount',             // Montant
            'CloseDate',          // Date de clôture
            'StageName',          // Phase de vente
            'Probability',        // Probabilité de succès
            'ExpectedRevenue',    // Revenu attendu
            'Account.Name',       // Nom du compte associé
            'LastModifiedDate'    // Date de dernière modification
        };
    }
    
    /**
     * Récupère les opportunités avec des critères de filtrage avancés
     * @param accountId ID du compte
     * @param stageNames Phases de vente à inclure
     * @param minAmount Montant minimum
     * @return List<Opportunity> Opportunités filtrées
     */
    public static List<Opportunity> getFilteredOpportunities(
        Id accountId,
        Set<String> stageNames,
        Decimal minAmount
    ) {
        // Validation des entrées
        if (accountId == null) {
            throw new IllegalArgumentException('L\'ID du compte ne peut pas être null');
        }

        // Construction de la clause WHERE
        List<String> whereConditions = new List<String>{
            'AccountId = :accountId'
        };
        
        if (stageNames != null && !stageNames.isEmpty()) {
            whereConditions.add('StageName IN :stageNames');
        }
        
        if (minAmount != null && minAmount > 0) {
            whereConditions.add('Amount >= :minAmount');
        }
        
        // Construction de la requête complète
        String query = String.format(
            'SELECT {0} ' +
            'FROM Opportunity ' +
            'WHERE {1} ' +
            'ORDER BY {2} {3} ' +
            'LIMIT {4}',
            new List<String>{
                String.join(getSelectedFields(), ','),
                String.join(whereConditions, ' AND '),
                DEFAULT_SORT_FIELD,
                DEFAULT_SORT_ORDER,
                String.valueOf(MAX_RECORDS)
            }
        );
        
        return Database.query(query);
    }
}