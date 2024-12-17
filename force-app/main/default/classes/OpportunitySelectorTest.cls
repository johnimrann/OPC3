/**
 * Classe de test pour OpportunitySelector
 * Vérifie le bon fonctionnement des méthodes de sélection des opportunités
 * 
 * @author Votre Nom
 * @version 2.0
 * @since 2024-12-17
 */
@isTest
private class OpportunitySelectorTest {
    
    /**
     * Configuration initiale des données de test
     */
    @TestSetup
    static void makeData() {
        // Création d'un compte de test
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        // Création de plusieurs opportunités de test
        List<Opportunity> testOpps = new List<Opportunity>();
        Date today = Date.today();
        
        // Opportunité 1: Montant élevé, en cours
        testOpps.add(new Opportunity(
            Name = 'High Value Opp',
            AccountId = testAccount.Id,
            Amount = 100000,
            CloseDate = today.addMonths(3),
            StageName = 'Prospecting'
        ));
        
        // Opportunité 2: Montant moyen, gagnée
        testOpps.add(new Opportunity(
            Name = 'Won Opp',
            AccountId = testAccount.Id,
            Amount = 50000,
            CloseDate = today,
            StageName = 'Closed Won'
        ));
        
        // Opportunité 3: Petit montant, perdue
        testOpps.add(new Opportunity(
            Name = 'Lost Opp',
            AccountId = testAccount.Id,
            Amount = 10000,
            CloseDate = today.addDays(-30),
            StageName = 'Closed Lost'
        ));
        
        insert testOpps;
    }
    
    /**
     * Test de la méthode getOpportunitiesByAccountId
     * Vérifie que toutes les opportunités sont correctement récupérées
     */
    @isTest
    static void testGetOpportunitiesByAccountId() {
        // Récupération du compte de test
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Test.startTest();
        
        // Appel de la méthode à tester
        List<Opportunity> opportunities = OpportunitySelector.getOpportunitiesByAccountId(testAccount.Id);
        
        Test.stopTest();
        
        // Vérifications
        Assert.areEqual(3, opportunities.size(), 'Le nombre d\'opportunités récupérées est incorrect');
        Assert.isTrue(opportunities[0].CloseDate >= opportunities[1].CloseDate, 'Le tri par date n\'est pas correct');
    }
    
    /**
     * Test de la méthode getFilteredOpportunities
     * Vérifie le filtrage par phase et montant
     */
    @isTest
    static void testGetFilteredOpportunities() {
        // Récupération du compte de test
        Account testAccount = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        // Paramètres de filtrage
        Set<String> stages = new Set<String>{'Prospecting', 'Closed Won'};
        Decimal minAmount = 50000;
        
        Test.startTest();
        
        // Appel de la méthode à tester
        List<Opportunity> opportunities = OpportunitySelector.getFilteredOpportunities(
            testAccount.Id,
            stages,
            minAmount
        );
        
        Test.stopTest();
        
        // Vérifications
        Assert.areEqual(2, opportunities.size(), 'Le nombre d\'opportunités filtrées est incorrect');
        for (Opportunity opp : opportunities) {
            Assert.isTrue(opp.Amount >= minAmount, 'Le filtrage par montant n\'est pas respecté');
            Assert.isTrue(stages.contains(opp.StageName), 'Le filtrage par phase n\'est pas respecté');
        }
    }
    
    /**
     * Test de la gestion des erreurs
     * Vérifie que les exceptions sont correctement levées
     */
    @isTest
    static void testErrorHandling() {
        Test.startTest();
        
        try {
            OpportunitySelector.getOpportunitiesByAccountId(null);
            Assert.fail('Une exception aurait dû être levée pour un ID null');
        } catch (IllegalArgumentException e) {
            Assert.isTrue(e.getMessage().contains('null'), 'Message d\'erreur incorrect');
        }
        
        try {
            OpportunitySelector.getFilteredOpportunities(null, null, null);
            Assert.fail('Une exception aurait dû être levée pour un ID null');
        } catch (IllegalArgumentException e) {
            Assert.isTrue(e.getMessage().contains('null'), 'Message d\'erreur incorrect');
        }
        
        Test.stopTest();
    }
}