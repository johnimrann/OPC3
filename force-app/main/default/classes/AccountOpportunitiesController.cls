/**
 * Contrôleur Apex pour la gestion des opportunités liées à un compte
 * 
 * Modifications apportées :
 * - Ajout du cache pour optimiser les performances
 * - Validation des entrées pour la sécurité
 * - Gestion des exceptions pour la robustesse
 * - Délégation au sélecteur pour la séparation des responsabilités
 *
 * @author Votre Nom
 * @version 1.0
 * @since 2024-12-17
 */
public with sharing class AccountOpportunitiesController {
    
    /**
     * Récupère les opportunités liées à un compte spécifique
     * Cette méthode est accessible depuis les composants Lightning
     * et met en cache les résultats pour optimiser les performances
     *
     * @param accountId ID du compte pour lequel récupérer les opportunités
     * @return List<Opportunity> Liste des opportunités associées au compte
     * @throws AuraHandledException si l'ID du compte est null ou si une erreur survient
     * 
     * Améliorations :
     * - Mise en cache des résultats avec cacheable=true
     * - Validation de l'ID du compte
     * - Gestion explicite des exceptions
     */
    @AuraEnabled(cacheable=true)  // Optimisation avec mise en cache
    public static List<Opportunity> getOpportunities(Id accountId) {
        try {
            // Validation des entrées pour la sécurité
            if (accountId == null) {
                throw new AuraHandledException('L\'ID du compte est requis');
            }
            
            // Délégation au sélecteur pour la séparation des responsabilités
            return OpportunitySelector.getOpportunitiesByAccountId(accountId);
        } catch (Exception e) {
            // Conversion en AuraHandledException pour une meilleure gestion côté client
            throw new AuraHandledException(e.getMessage());
        }
    }
}