public with sharing class AccountCasesController {
    
    @AuraEnabled(cacheable=true)
    public static List<Case> findCasesBySubject(Id accountId, String subjectSearchTerm) {
        // Validation des paramètres
        if (String.isBlank(accountId)) {
            throw new AuraHandledException('L\'ID du compte est requis');
        }
        
        // Préparation du terme de recherche
        String searchPattern = '%' + String.escapeSingleQuotes(subjectSearchTerm) + '%';
        
        try {
            // Requête SOQL pour récupérer les cases
            return [
                SELECT Id, Subject, Status, Priority, CreatedDate
                FROM Case
                WHERE AccountId = :accountId 
                AND Subject LIKE :searchPattern
                ORDER BY CreatedDate DESC
                LIMIT 100
            ];
        } catch (Exception e) {
            throw new AuraHandledException('Erreur lors de la recherche des cases : ' + e.getMessage());
        }
    }
}