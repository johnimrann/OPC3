/**
 * Classe de test pour le contrôleur AccountOpportunitiesController
 * Teste les fonctionnalités de récupération des opportunités
 * et la gestion des erreurs
 */
@IsTest
public class AccountOpportunitiesControllerTest {
    
    /**
     * Configuration initiale des données de test
     * Crée un compte et une opportunité pour les tests
     */
    @TestSetup
    static void makeData() {
        // Création d'un compte de test
        Account testAccount = new Account(
            Name = 'Test Account'
        );
        insert testAccount;
        
        // Création d'une opportunité de test avec montant
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opportunity',
            AccountId = testAccount.Id,
            CloseDate = Date.today().addDays(30),
            StageName = 'Prospecting',
            Amount = 10000
        );
        insert testOpp;
    }
    
    /**
     * Test le scénario positif : récupération des opportunités
     * Vérifie que les données sont correctement retournées
     */
    @IsTest
    static void testGetOpportunities() {
        // Récupération du compte de test
        Account testAcc = [SELECT Id FROM Account WHERE Name = 'Test Account' LIMIT 1];
        
        Test.startTest();
        // Appel de la méthode à tester
        List<Opportunity> opportunities = AccountOpportunitiesController.getOpportunities(testAcc.Id);
        Test.stopTest();
        
        // Vérifications
        System.assertEquals(1, opportunities.size(), 'Une seule opportunité devrait être retournée');
        System.assertEquals('Test Opportunity', opportunities[0].Name, 'Le nom de l\'opportunité ne correspond pas');
        System.assertEquals(10000, opportunities[0].Amount, 'Le montant ne correspond pas');
    }
    
    /**
     * Test le scénario d'erreur : ID de compte null
     * Vérifie que l'exception appropriée est levée
     */
    @IsTest
    static void testGetOpportunitiesNullId() {
        try {
            Test.startTest();
            AccountOpportunitiesController.getOpportunities(null);
            Test.stopTest();
            System.assert(false, 'Une exception aurait dû être levée');
        } catch (AuraHandledException e) {
            System.assertEquals('L\'ID du compte est requis', e.getMessage(), 'Message d\'erreur incorrect');
        }
    }
    
    /**
     * Test le scénario sans données : compte sans opportunités
     * Vérifie que la liste retournée est vide
     */
    @IsTest
    static void testGetOpportunitiesNoResults() {
        // Création d'un nouveau compte sans opportunités
        Account emptyAccount = new Account(Name = 'Empty Account');
        insert emptyAccount;
        
        Test.startTest();
        List<Opportunity> opportunities = AccountOpportunitiesController.getOpportunities(emptyAccount.Id);
        Test.stopTest();
        
        // Vérification
        System.assertEquals(0, opportunities.size(), 'La liste devrait être vide');
    }
}